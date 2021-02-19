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
use sladb
go

open symmetric key sladb_symkey
	decryption by certificate sladb_cert;
go

create or alter view dbo.vw_change_request_export as
	select change_request_id,
		   unit_id,
		   sla_code,
		   season_id,
		   effective_start,
		   effective_start_adj,
		   change_request_justification,
		   change_request_comments,
		   sla_change_status,
		   encryptbykey(key_guid('sladb_symkey'), edited_user) as edited_user
	from sladb.dbo.tbl_change_request;

go
close symmetric key sladb_symkey;