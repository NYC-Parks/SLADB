/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: 10/25/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Insert the initial historic SLAs to start SLADB.  									   
																													   												
***********************************************************************************************************************/
exec sladb.dbo.sp_insert_tbl_ref_calendar

begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective)
		values('Year-round, not seasonal', 1, 1);		
commit;					

exec sladb.dbo.sp_season_dates @year = 2014;
exec sladb.dbo.sp_season_dates @year = 2015;
exec sladb.dbo.sp_season_dates @year = 2016;
exec sladb.dbo.sp_season_dates @year = 2017;
exec sladb.dbo.sp_season_dates @year = 2018;
--exec sladb.dbo.sp_season_dates @year = 2019;

/*insert into sladb.dbo.tbl_sla_season_date(season_id, effective_from, effective_from_adj, effective_to, effective_to_adj, date_category_id)
	values(2, '2019-07-01', sladb.dbo.fn_getdate('2019-07-01', 1), ),
		  ()*/
begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective)
		values('Beaches, etc.', 0, 1)
commit;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
		values(2, 1, 'May', 1, 1),
			  (2, 1, 'October', 1, 2);
commit;

--exec sladb.dbo.sp_season_dates @year = 2019;

begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective)
		values('Ballfields, etc.', 0, 1);
commit;

insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
	values(3, 1, 'March', 1, 1),
			(3, 1, 'October', 31, 2);
commit;

exec sladb.dbo.sp_season_dates @year = 2019;

begin transaction
	delete from sladb.dbo.tbl_sla_season_date
	where season_id = 2 and effective_from = '2019-01-01';
commit;

begin transaction
	delete from sladb.dbo.tbl_sla_season_date
	where season_id = 3 and effective_from = '2019-01-01';
commit;

begin transaction
	update sladb.dbo.tbl_sla_season_date
		set effective_from = '2019-07-01',
			effective_from_adj = sladb.dbo.fn_getdate('2019-07-01', 1)
	where season_date_id in(7,10);
commit;

