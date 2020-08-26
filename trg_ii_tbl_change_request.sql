/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																					   			          
 Created Date:  09/27/2019																							   
 Modified Date: 01/29/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_change_request																							   
 			  sladb.dbo.tbl_change_request_status																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_ii_tbl_change_request
on sladb.dbo.tbl_change_request
instead of insert as 
	begin
		begin transaction
			insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start,
													 change_request_justification, effective_start_adj, sla_change_status)
			select unit_id,
				   sla_code,
				   season_id,
				   effective_start,
				   change_request_justification,
				   dbo.fn_getdate(effective_start, 1) as effective_start_adj,
				   sla_change_status
			from inserted;
		commit;

		--set identity_insert sladb.dbo.tbl_change_request off;

	end;


	 