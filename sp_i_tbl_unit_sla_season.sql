/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  01/29/2020																							   
 Modified Date: 03/02/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: This stored procedure	inserts change requests that have been approved into the tbl_unit_sla_season table.
			  It will only act on records that require an insert on delay, that is the effective start date is later than
			  the date on which the change request reaches the approved status.
																													   												
***********************************************************************************************************************/
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter procedure dbo.sp_i_tbl_unit_sla_season as
	begin
		begin transaction
			insert into sladb.dbo.tbl_unit_sla_season(unit_id, sla_code, season_id, effective, effective_start)
			    /*Join the change request table to the change request status table based on the change_request_id*/
				select l.unit_id, 
					   l.sla_code, 
					   l.season_id, 
					   1 as effective, 
					   l.effective_start
				from sladb.dbo.tbl_change_request as l
				inner join
						sladb.dbo.tbl_change_request_status as r
				on l.change_request_id = r.change_request_id
				/*If the change request status (sla_change_status) is 2 = Approved and the effective_start_adj (adjusted effective_start_date)
					is equal to the current date minus one hour then insert the new record*/
				where r.sla_change_status = 2 and
						l.effective_start_adj = cast(dateadd(hour, -1, getdate()) as date)
				/*Use an except operation to find only records that don't already exist in the tbl_unit_sla_season table. Except will only find the
				  differences in rows between two results sets.*/
				except
					select unit_id, 
							sla_code, 
						    season_id, 
						    effective, 
						    effective_start
					from sladb.dbo.tbl_unit_sla_season;
		commit;
	end;