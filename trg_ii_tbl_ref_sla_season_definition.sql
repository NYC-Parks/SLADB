/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  <MM/DD/YYYY>																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: <Project Name>	
 																							   
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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_ii_tbl_ref_sla_season_definition
on sladb.dbo.tbl_ref_sla_season_definition
instead of insert as 
begin
	/*If the #inserts temporary table exists then drop it.*/
	if object_id('tempdb..#inserts') is not null
		drop table #inserts;

	/*Insert records into a temporary table to make sure that the date_ref_fixed row signatures don't have
	  column values when they're not needed.*/
	select season_id,
		   date_ref_fixed,
		   month_name_desc,
		   /*If the row is for a fixed date then use the date_ref_day_number value, otherwise set it to null.*/
		   case when date_ref_fixed = 1 then date_ref_day_number
				else null
		   end as date_ref_day_number,
		   /*If the row is not for a fixed date then use the day_name_desc value, otherwise set it to null.*/
		   case when date_ref_fixed = 0 then day_name_desc
				else null
		   end as day_name_desc,
		   /*If the row is not for a fixed date then use the day_rank_id value, otherwise set it to null.*/
		   case when date_ref_fixed = 0 then day_rank_id
				else null
		   end as day_rank_id,
		   date_type_id,
		   /*Calculate the month number by concatenating the month name with a day of 1 and the year 2014.*/
		   month(month_name_desc + '1 2014') as month_num,
		   /*Calculate the maximum month number for each season*/
		   max(month(month_name_desc + '1 2014')) over(partition by season_id order by season_id) max_month_num,
		   /*Calculate the minimum month number for each season*/
		   min(month(month_name_desc + '1 2014')) over(partition by season_id order by season_id) min_month_num
	into #inserts
	from sladb.dbo.tbl_ref_sla_season_definition;

	/*If the #inserts2 temporary table exists then drop it.*/
	if object_id('tempdb..#inserts2') is not null
		drop table #inserts2;

	select season_id,
		   date_ref_fixed,
		   month_name_desc,
		   date_ref_day_number,
		   day_name_desc,
		   day_rank_id,
		   date_type_id,
		   /*For records with date_type_id = 1, or the beginning of the in season, make sure the month number is less than the 
			 max month number for a given season. If so, set the record to valid.*/ 
		   case when date_type_id = 1 and month_num < max_month_num then 1
				when date_type_id = 2 and month_num > min_month_num then 1
				else 0
		   end as month_valid,
		   /*For fixed dates (date_ref_fixed = 1) set the valid value to 0 if the date_ref_day_number is null.*/ 
		   case when date_ref_fixed = 1 and date_ref_day_number is null then 0
		   /*For variable dates (date_ref_fixed = 0) set the valid value to 0 if the day_name_desc is null or the day_rank_id
		     is null.*/ 
				when date_ref_fixed = 0 and (day_name_desc is null or day_rank_id is null) then 0
				else 1
		   end as dates_valid
	into #inserts2
	from #inserts;

	/*If the #valid temporary table exists then drop it.*/
	if object_id('tempdb..#valid') is not null
		drop table #valid;

	/*Determine the validity by season.*/
	select season_id,
		   /*Sum the month_valid and date_valid values for each row and season_id. This value should always equal 4, meaning
		     that both the month_valid and dates_valid values are 1 for each row for each season. If it's 4 then assign a value
			 of 1 (valid) otherwise 0 (invalid).*/
		   case when sum(month_valid + dates_valid) over(partition by season_id order by season_id) = 4 then 1
				else 0
		   end as valid,
		   month_valid,
		   dates_valid
	into #valid
	from #inserts2;

	/*Insert only rows for seasons that are completely valid*/
	begin transaction
		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id,
															date_ref_fixed,
															month_name_desc,
															date_ref_day_number,
															day_name_desc,
															day_rank_id,
															date_type_id)
		select l.season_id,
			   l.date_ref_fixed,
			   l.month_name_desc,
			   l.date_ref_day_number,
			   l.day_name_desc,
			   l.day_rank_id,
			   l.date_type_id
		from #inserts2 as l
		inner join
			 #valid as r
		on l.season_id = r.season_id
		/*If the season is valid then insert it*/
		where r.valid = 1
	commit;
end;