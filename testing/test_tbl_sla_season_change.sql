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
begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective, effective_start)
		select season_desc, 
			   year_round, 
			   1 as effective, 
			   effective_start = '2020-07-26'
		from sladb.dbo.tbl_sla_season
		where season_id = 2
commit;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, 
														day_name_desc, day_rank_id, date_type_id)
		select 10 season_id, 
			   date_ref_fixed, 
			   month_name_desc, 
			   date_ref_day_number, 
			   day_name_desc, 
			   day_rank_id, 
			   date_type_id
		from sladb.dbo.tbl_ref_sla_season_definition
		where season_id = 2

commit;

begin transaction
	insert sladb.dbo.tbl_sla_season_change(old_season_id, new_season_id)
		values(2, 10)
commit;

--------------------------------------------------------------------------------------------------
begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective, effective_start)
		select season_desc, 
			   year_round, 
			   1 as effective, 
			   effective_start = '2020-07-26'
		from sladb.dbo.tbl_sla_season
		where season_id = 3
commit;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, 
														day_name_desc, day_rank_id, date_type_id)
		select 9 as season_id, 
			   date_ref_fixed, 
			   month_name_desc, 
			   date_ref_day_number, 
			   day_name_desc, 
			   day_rank_id, 
			   date_type_id
		from sladb.dbo.tbl_ref_sla_season_definition
		where season_id = 3
commit;

begin transaction
	insert sladb.dbo.tbl_sla_season_change(old_season_id, new_season_id)
		values(3, 9)
commit;
--------------------------------------------------------------------------------------------------

begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective_start)
		select season_desc, 
			   year_round, 
			   effective_start = '2020-08-09'
		from sladb.dbo.tbl_sla_season
		where season_id = 10
commit;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, 
														day_name_desc, day_rank_id, date_type_id)
		select 12 season_id, 
			   date_ref_fixed, 
			   month_name_desc, 
			   date_ref_day_number, 
			   day_name_desc, 
			   day_rank_id, 
			   date_type_id
		from sladb.dbo.tbl_ref_sla_season_definition
		where season_id = 10

commit;


begin transaction
	insert sladb.dbo.tbl_sla_season_change(old_season_id, new_season_id)
		values(10, 12)
commit;
--------------------------------------------------------------------------------------------------
begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective_start)
		select season_desc, 
			   year_round, 
			   effective_start = '2020-08-07'
		from sladb.dbo.tbl_sla_season
		where season_id = 9
commit;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, 
														day_name_desc, day_rank_id, date_type_id)
		select 11 season_id, 
			   date_ref_fixed, 
			   month_name_desc, 
			   date_ref_day_number, 
			   day_name_desc, 
			   day_rank_id, 
			   date_type_id
		from sladb.dbo.tbl_ref_sla_season_definition
		where season_id = 9

commit;

begin transaction
	insert sladb.dbo.tbl_sla_season_change(old_season_id, new_season_id)
		values(9, 11)
commit;

