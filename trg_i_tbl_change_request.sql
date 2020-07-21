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

create trigger dbo.trg_i_tbl_change_request
on sladb.dbo.tbl_change_request
for insert as 

	begin transaction
		/*After a new record is submitted into the tbl_change_request, insert a corresponding record into tbl_change_request_status*/
		insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_user)
			select change_request_id,
				   1, --representing the change request has been "Submitted"
				   '0000000' --where can the ERN be pulled from?
			from inserted
		 	
	commit;
	 