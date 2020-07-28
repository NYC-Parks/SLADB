/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  10/18/2019																							   
 Modified Date: 02/12/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_unit_sla_season																							   			
			  																				   
 Description: Create a trigger that allows values to be updated and inserted in bulk if an existing season is replaced
			  by a new season. This will prevent the user to have to update the season records 1 by 1.
																													   												
***********************************************************************************************************************/
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_i_tbl_sla_season_change
on sladb.dbo.tbl_sla_season_change
after insert as
	begin
		begin transaction
				update sladb.dbo.tbl_sla_season
					set effective_end = s.effective_end,
						updated_date_utc = getutcdate()
					from sladb.dbo.tbl_sla_season as u
					inner join
						/*Join the season table with the inserted table on the new (replacing) season on the new season_id. Take the old
						  season_id value and the effective_start date from the new season and use that as the effective_end date of the new
						  season.*/
						(select r.old_season_id as season_id,
								l.effective_start as effective_end
						 from sladb.dbo.tbl_sla_season as l
						 inner join	
							  inserted as r
						 on l.season_id = r.new_season_id) as s
					on u.season_id = s.season_id
		commit;
	
		/*Execute the stored procedure to perform the cascading changes*/
		exec sladb.dbo.sp_i_tbl_sla_season_change;
	end;
