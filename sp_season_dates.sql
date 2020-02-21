/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Samuel Pollack, samuel.pollack@parks.nyc.gob, Innovation & Performance Management																					   			          
 Created Date:  08/30/2019																							   
 Modified Date: 02/21/2020																							   
											       																	   
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

create or alter procedure dbo.sp_season_dates @year int = null as
--alter procedure dbo.sp_season_dates @year int = null as
begin

	if object_id('tempdb..#seasondates') is not null drop table #seasondates; 

	select *, rank() over (partition by season_id order by ref_date asc) dtrk
	into #seasondates
	from (
		-- start and end dates
		select season_id, ref_date, null date_type_id
		from [sladb].[dbo].[tbl_sla_season]
		left join sladb.dbo.tbl_ref_calendar on ref_date >= effective_start_adj
		where ref_date in (effective_start_adj,coalesce(effective_end_adj,cast(dateadd(year,1,getdate()) as date)))

		union

		-- seasonal transitions
		select [tbl_sla_season].season_id, ref_date, date_type_id
		from [sladb].[dbo].[tbl_sla_season]
		left join [sladb].[dbo].[tbl_ref_sla_season_definition] on [tbl_sla_season].season_id = [tbl_ref_sla_season_definition].season_id
		left join sladb.dbo.tbl_ref_calendar on ref_date between effective_start_adj and effective_end_adj
			or (effective_end_adj is null and ref_date >= effective_start_adj)
		where ref_date <= cast(dateadd(year,1,getdate()) as date)
			and year_round != 1 -- just worrying about seasonal seasons for now
			and [tbl_ref_sla_season_definition].month_name_desc = tbl_ref_calendar.month_name_desc
			and (date_ref_day_number = day_number 
				or ([tbl_ref_sla_season_definition].day_name_desc=tbl_ref_calendar.day_name_desc 
					and [tbl_ref_sla_season_definition].day_rank_id=tbl_ref_calendar.day_rank_id))
	) changedates


	begin transaction
	truncate table sladb.dbo.tbl_sla_season_date
	commit;

	begin transaction
	insert into sladb.dbo.tbl_sla_season_date (season_id, effective_start,effective_end,date_category_id)
	select l.season_id
		,l.ref_date effetive_start
		,case when r.date_type_id is null then r.ref_date --this happens when a season is retired
			else dateadd(dd,-1,r.ref_date) end effective_end --this happens when a season transitions 
		,case when l.date_type_id is null and r.date_type_id is null then 1 --this happens when season is year round
			when l.date_type_id is null and r.date_type_id = 1 then 2 --at beginning of season
			when l.date_type_id is null and r.date_type_id = 2 then 1 --at beginning of season
			else l.date_type_id end date_category_id --season transition 
	from #seasondates l inner join #seasondates r on l.season_id = r.season_id and l.dtrk = r.dtrk - 1
	order by season_id, effetive_start;
	commit;

end;
