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

create or alter procedure dbo.sp_season_dates as
begin

	if object_id('tempdb..#seasondates') is not null 
		drop table #seasondates; 

	select *, 
		   rank() over (partition by season_id order by ref_date asc) dtrk
	into #seasondates
	from (
		-- start and end dates
		select l.season_id, 
			   ref_date, 
			   null date_type_id
		from sladb.dbo.tbl_sla_season as l
		left join 
			 sladb.dbo.tbl_ref_calendar as r
		on ref_date >= effective_start
		where ref_date in (effective_start,coalesce(effective_end,cast(dateadd(year,1,getdate()) as date)))
		union
		-- retrieve all dates that are within the range of the start and end dates for all seasons. seasonal transitions
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
		   (l.effective_end is null and r2.ref_date >= l.effective_start)
		where r2.ref_date <= cast(dateadd(year,1,getdate()) as date) and
			  l.year_round != 1 and-- just worrying about seasonal seasons for now
			  r.month_name_desc = r2.month_name_desc and
			  (r.date_ref_day_number = r2.day_number or 
			   (r.day_name_desc = r2.day_name_desc and
				r.day_rank_id = r2.day_rank_id))) changedates;

	/*begin transaction
	truncate table sladb.dbo.tbl_sla_season_date
	commit;*/

	if object_id('tempdb..#sla_season_dates') is not null 
		drop table #sla_season_dates; 

	select l.season_id,
		   l.ref_date as effective_start,
		   case when r.date_type_id is null then r.ref_date --this happens when a season is retired
			    else dateadd(dd,-1,r.ref_date) 
		   end as effective_end, --this happens when a season transitions 
		   case when l.date_type_id is null and r.date_type_id is null then 1 --this happens when season is year round
			when l.date_type_id is null and r.date_type_id = 1 then 2 --at end of a season
			when l.date_type_id is null and r.date_type_id = 2 then 1 --at start of a season
			else l.date_type_id 
		 end as date_category_id --season transition 
	into #sla_season_dates
	from #seasondates as l 
	inner join 
		 #seasondates r 
	on l.season_id = r.season_id and 
	   l.dtrk = r.dtrk - 1
	order by season_id, effective_start;

	begin transaction
		merge sladb.dbo.tbl_sla_season_date as tgt using #sla_season_dates as src
		/*The combination of season_id and effective_start should never change.*/
		on (tgt.season_id = src.season_id and 
			tgt.effective_start = src.effective_start)
		when matched and (src.effective_end != tgt.effective_end)
			then update
				set tgt.effective_end = src.effective_end
		when not matched by target
			then insert(season_id, effective_start, effective_end, date_category_id)
				values(src.season_id, src.effective_start, src.effective_end, src.date_category_id)
		when not matched by source
			then delete; 
	commit;

end;
