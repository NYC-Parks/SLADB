/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  01/29/2020																							   
 Modified Date: 02/26/2020																							   
											       																	   
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

create or alter trigger dbo.trg_u_tbl_sla_season
on sladb.dbo.tbl_sla_season
for update as
	begin
		/*Try the insert*/
		begin try
			/*Since the new record already would have been inserted by the insert on the tbl_change_request status table, find existing effective record for that unit
			  and set the effective value to 0 and the effective_date to today.*/
			begin transaction;
				update sladb.dbo.tbl_sla_season
					set updated_date_utc = getutcdate()
					from inserted as s
					inner join
						 sladb.dbo.tbl_sla_season as u
					on s.season_id = u.season_id;
			commit;

			/*Call the stored procedure that will update the date values in the tbl_sla_season table.*/
			exec sladb.dbo.sp_season_dates;

		end try

		/*Catch any errors and if applicable, rollback the above transaction.*/
		begin catch
			rollback transaction;
		end catch
	end;