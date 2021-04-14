/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: 02/27/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Insert the initial historic SLAs to start SLADB.  									   
																													   												
***********************************************************************************************************************/
set nocount on;

use sladb
go

declare @new_season as insert_new_season,
	    @new_season_definition as insert_new_season_definition

insert into @new_season(season_desc, year_round, effective_start)
	values('Year-round, not seasonal', 1, '2014-01-01');

exec sladb.dbo.usp_insert_season @new_season = @new_season, @new_season_definition = @new_season_definition;

delete from @new_season;
delete from @new_season_definition;

insert into @new_season(season_desc, year_round, effective_start)
	values('Beaches, etc.', 0, '2019-07-01');

insert into @new_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, day_name_desc,
								   day_rank_id, date_type_id)
	values(1, 'May', 1, null, null,  1),
		  (1, 'October', 1, null, null,  2);
exec sladb.dbo.usp_insert_season @new_season = @new_season, @new_season_definition = @new_season_definition;

delete from @new_season;
delete from @new_season_definition;

insert into @new_season(season_desc, year_round, effective_start)
	values('Ballfields, etc.', 0, '2019-07-01');

insert into @new_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, day_name_desc,
								   day_rank_id, date_type_id)
	values(1, 'March', 1, null, null,  1),
		  (1, 'October', 31, null, null,  2);

exec sladb.dbo.usp_insert_season @new_season = @new_season, @new_season_definition = @new_season_definition;