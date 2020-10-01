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
use sladb;
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_ai_tbl_change_request_status
on sladb.dbo.tbl_change_request_status
after insert as
	begin

		/*If new approvals have been made then execute the stored procedure.
		if exists(select * from inserted where sla_change_status = 2)*/
			--begin
				/*After a new record is inserted into the tbl_change_request status table, execute the stored procedure
				 to see if the row should be inserted into tbl_unit_sla_season immediately.*/
				exec sladb.dbo.sp_i_tbl_unit_sla_season;
			--end;

	end;