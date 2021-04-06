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

/*Turn all the triggers off for tbl_change_request*/
disable trigger dbo.trg_ai_tbl_change_request_status on dbo.tbl_change_request_status;
go

/*Turn identity insert on*/
set identity_insert sladb.dbo.tbl_change_request_status on;
go

/*Open the sym key*/
open symmetric key sladb_symkey
	decryption by certificate sladb_cert;


	begin transaction
		insert into sladb.dbo.tbl_change_request(change_request_status_id,
												 change_request_id,
												 sla_change_status,
												 created_date_utc,
												 created_user)

			/*Read the json data file, decrypt the edited_user column*/
			select change_request_status_id,
				   change_request_id,
				   sla_change_status,
				   created_date_utc,
				   convert(nvarchar(7), decryptbykey(created_user)) as created_user
			from openjson((select cast(bulkcolumn as nvarchar(max))
							from openrowset(bulk 'D:/Projects/SLADB_Data/tbl_change_request_status.json', single_clob) as j))
							with(change_request_status_id int,
								 change_request_id int,
								 sla_change_status int, 
								 created_date_utc datetime,
								 created_user varbinary(max));
	commit;
go
/*Close the sym key*/
close symmetric key sladb_symkey;
go

/*Turn identity insert off*/
set identity_insert sladb.dbo.tbl_change_request_status off;
go

/*Enable all the triggers on tbl_change_request_status*/
enable trigger dbo.trg_ai_tbl_change_request_status on dbo.tbl_change_request_status;
go