/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Samuel Pollack, samuel.pollack@parks.nyc.gob, Innovation & Performance Management																					   			          
 Created Date:  08/30/2019																							   
 Modified Date: 02/27/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
use sladb
go

create or alter procedure dbo.sp_m_tbl_sla_season_date  as
begin

	if object_id('tempdb..#seasondates') is not null 
		drop table #seasondates; 

	select *, 
		   rank() over (partition by season_id order by ref_date asc) dtrk
	into #seasondates
	from (
		/*Join the season dates with calendar reference table to get the effective_start dates and the
		  effective_end dates (current date) because these won't be accounted for in the translation table.*/
		select l.season_id, 
			   r.ref_date, 
			   null date_type_id
		from sladb.dbo.tbl_sla_season as l
		left join 
			 sladb.dbo.tbl_ref_calendar as r
		on r.ref_date >= l.effective_start
		/*Filter to include dates that match the effective_start dates and either the effective_end or tomorrow*/
		where r.ref_date in (l.effective_start,coalesce(l.effective_end,cast(dateadd(year,1,getdate()) as date)))
		union
		/*Join the season, season_definition and calendar tables and find all of the seasonal transitions.*/
		select l.season_id, 
			   r2.ref_date, 
			   r.date_type_id
		from sladb.dbo.tbl_sla_season as l
		left join 
			 sladb.dbo.tbl_ref_sla_season_definition as r
		on l.season_id = r.season_id
		left join 
			 sladb.dbo.tbl_ref_calendar as r2
		on r2.ref_date between l.effective_start and l.effective_end or
		   /*If the season has no end date calendar reference date is greater than the effective_start date*/
		   (l.effective_end is null and r2.ref_date >= l.effective_start)
		/*Filter out records to only include those with a ref_date less than tomorrow*/
		where r2.ref_date <= cast(dateadd(year,1,getdate()) as date) and
			  /*Year round dates are not as difficult to handle so they are excluded.*/
			  l.year_round != 1 and
			  /*Only keep records where the months match*/
			  r.month_name_desc = r2.month_name_desc and
			  /*For variable dates keep the values where the date patterns (day number, day name and day rank) match*/
			  (r.date_ref_day_number = r2.day_number or 
			  (r.day_name_desc = r2.day_name_desc and
			   r.day_rank_id = r2.day_rank_id))) changedates;

	if object_id('tempdb..#sla_season_dates') is not null 
		drop table #sla_season_dates; 
	/*Join the #seasondates table to itself in order to get all of the relevant dates.*/
	select l.season_id,
		   l.ref_date as effective_start,
		   r.ref_date as effective_end, 
		   case when l.date_type_id is null and r.date_type_id is null then 1 --this happens when season is year round
		   /*Flip the date_type_ids because they should be the opposite.*/
			when l.date_type_id is null and r.date_type_id = 1 then 2 --at end of a season
			when l.date_type_id is null and r.date_type_id = 2 then 1 --at start of a season
			else l.date_type_id 
		 end as date_category_id --season transition 
	into #sla_season_dates
	from #seasondates as l 
	inner join 
		 #seasondates r 
	on l.season_id = r.season_id and 
	   /*To join the effective_start and effective_end dates properly you need to join the right table based on the date rank minus one.*/
	   l.dtrk = r.dtrk - 1
	order by season_id, effective_start;

	if object_id('tempdb..#final_sla_season_dates') is not null 
	drop table #seasondates; 

	select season_id,
		   /*When the row corresponds to the off-season (date_category_id = 2) then add 1 day to the effective_start date 
			 because it should start one day after the effective_end of the in-season (date_category_id = 1). If it's in-season
			 then don't do anything to the dates.*/
		   case when date_category_id = 2 then dateadd(day, 1, effective_start)
				else effective_start
		   end as effective_start,
		   /*When the row corresponds to the off-season (date_category_id = 2) then subtract 1 day to the effective_end date 
			 because it should end one day before the effective_start of the in-season (date_category_id = 1). If it's in-season
			 then don't do anything to the dates.*/
		   case when date_category_id = 2 then dateadd(day, -1, effective_end)
				else effective_end
		   end as effective_end,
		   date_category_id
	into #final_sla_season_dates
	from #sla_season_dates

	begin transaction
		merge sladb.dbo.tbl_sla_season_date as tgt using #final_sla_season_dates as src
		/*The combination of season_id and effective_start should never change.*/
		on (tgt.season_id = src.season_id and 
			tgt.effective_start = src.effective_start)
		/*When the records are matched between the season_id and the effective_start, but the effective_end is not equal to the effective_end.*/
		when matched and (src.effective_end != tgt.effective_end)
			then update
				set tgt.effective_end = src.effective_end
		/*If the row doesn't exist in the current table then insert the record.*/
		when not matched by target
			then insert(season_id, effective_start, effective_end, date_category_id)
				values(src.season_id, src.effective_start, src.effective_end, src.date_category_id)
		/*If rows are exist in the data currently, but not in the new data set, then delte them. Because the script adds rows for the future,
		  these rows need to be deleted when the season is given an effective_end date.*/
		when not matched by source
			then delete; 
	commit;

end;
