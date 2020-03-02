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

create or alter procedure dbo.sp_i_tbl_unit_sla_season as
	begin
		begin try
			begin transaction
				insert into sladb.dbo.tbl_unit_sla_season(unit_id, sla_code, season_id, effective, effective_start)											  
					select l.unit_id, 
						   l.sla_code, 
						   l.season_id, 
						   1 as effective, 
						   l.effective_start
					from sladb.dbo.tbl_change_request as l
					inner join
						 sladb.dbo.tbl_change_request_status as r
					on l.change_request_id = r.change_request_id
					/*If the change request status is approved and the effective date is today then insert the new record*/
					where r.sla_change_status = 2 and
						  l.effective_start_adj = cast(dateadd(hour, -1, getdate()) as date);
			commit;

			end try

			begin catch
				rollback transaction;
			end catch
	end;