/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  01/30/2020																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
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

create trigger dbo.trg_i_tbl_change_request_status
on sladb.dbo.tbl_change_request_status
for insert as
	begin
		/*Try the insert*/
		begin try
			/*Since the new record already would have been inserted by the insert on the tbl_change_request status table, find existing effective record for that unit
			  and set the effective value to 0 and the effective_date to today.*/
			begin transaction;
				insert into sladb.dbo.tbl_unit_sla_season(unit_id, sla_code, season_id, effective, effective_start)
					select l.unit_id, 
						   l.sla_code, 
						   l.season_id, 
						   1 as effective, 
						   l.effective_start
					from inserted as l
					left join
						 sladb.dbo.tbl_change_request as r
					on l.change_request_id = r.change_request_id 
					where l.sla_change_status = 2 and
						  r.effective_start_adj = cast(getdate() as date)
			commit;
		end try

		/*Catch any errors and if applicable, rollback the above transaction.*/
		begin catch
			rollback transaction;
		end catch
	end;