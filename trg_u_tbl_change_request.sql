/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  <MM/DD/YYYY>																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
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

create or alter trigger dbo.trg_u_tbl_change_request
on sladb.dbo.tbl_change_request
for update as 
	begin

		begin transaction
			/*After a new record is submitted into the tbl_change_request, insert a corresponding record into the tbl_change_request_status table*/
			insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, created_user)
				select change_request_id,
					   sla_change_status,
					   /*Insert a default value for the status_user right now. The true value will need to be pulled through active directory, 
					   expertise of ITT required. It is stored in the employeeID attribute. If the sla_change_status is set to 4 = Invalid, then use
					   SYSTEM as the user.*/
					   case when sla_change_status = 4 then 'SYSTEM'
							else '0000000' 
					   end as created_user
				from inserted
				/*Updates are made to the effective_start_adj column, so these need to be ignored by filtering out any records with the default
				  sla_change_status of 1 = 'Submitted'*/
				where sla_change_status != 1
		commit;

	end;


	 