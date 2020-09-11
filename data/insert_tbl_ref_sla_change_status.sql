/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  03/02/2020																							   
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
set nocount on;
set identity_insert sladb.dbo.tbl_ref_sla_change_status on;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_change_status(sla_change_status, sla_change_status_desc)
		values(1, 'Submitted'),
			  (2, 'Approved'),
			  (3, 'Rejected'),
			  (4, 'Invalid'),
			  (5, 'Cancelled');
commit;

set identity_insert sladb.dbo.tbl_ref_sla_change_status off;