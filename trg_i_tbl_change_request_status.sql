/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  01/30/2020																							   
 Modified Date: 03/02/2020																							   
											       																	   
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
--drop trigger dbo.trg_i_tbl_change_request_status
create or alter trigger dbo.trg_i_tbl_change_request_status
on sladb.dbo.tbl_change_request_status
after insert as
	begin
		/*Try the insert*/
		--begin try
			exec sladb.dbo.sp_i_tbl_unit_sla_season;
		--end try

		/*Catch any errors and if applicable, rollback the above transaction.*/
		--begin catch
		--	rollback transaction;
		--end catch
	end;