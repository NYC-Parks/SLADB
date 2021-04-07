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
disable trigger dbo.trg_ai_tbl_change_request on dbo.tbl_change_request;
go

disable trigger dbo.trg_ii_tbl_change_request on dbo.tbl_change_request;
go

disable trigger dbo.trg_fu_tbl_change_request on dbo.tbl_change_request;
go

/*Turn off the check constraint*/
alter table sladb.dbo.tbl_change_request 
	nocheck constraint ck_change_request_effective_start;
go

/*Turn identity insert on*/
set identity_insert sladb.dbo.tbl_change_request on;
go

/*Open the sym key*/
open symmetric key sladb_symkey
	decryption by certificate sladb_cert;


	begin transaction
		insert into sladb.dbo.tbl_change_request(change_request_id,
												 unit_id,
												 sla_code,
												 season_id,
												 effective_start,
												 effective_start_adj,
												 change_request_justification,
												 change_request_comments,
												 sla_change_status,
												 edited_user)

			/*Read the json data file, decrypt the edited_user column*/
			select change_request_id,
				   unit_id,
				   sla_code,
				   season_id,
				   effective_start,
				   effective_start_adj,
				   change_request_justification,
				   change_request_comments,
				   sla_change_status,
				   isnull(convert(nvarchar(7), decryptbykey(edited_user)), '0000000') as edited_user
			from openjson((select cast(bulkcolumn as nvarchar(max))
						   from openrowset(bulk 'D:/Projects/SLADB_Data/tbl_change_request.json', single_clob) as j))
							with(change_request_id int,
								 unit_id nvarchar(30),
								 sla_code int,
								 season_id int,
								 effective_start date,
								 effective_start_adj date,
								 change_request_justification nvarchar(2000),
								 change_request_comments nvarchar(2000),
								 sla_change_status int,
								 edited_user varbinary(max))
			order by change_request_id asc;
	commit;
go
/*Close the sym key*/
close symmetric key sladb_symkey;
go

/*Turn identity insert off*/
set identity_insert sladb.dbo.tbl_change_request off;
go

/*Turn on the check constraint*/
alter table sladb.dbo.tbl_change_request 
	check constraint ck_change_request_effective_start;
go

/*Enable all the triggers on tbl_change_request*/
enable trigger dbo.trg_ai_tbl_change_request on dbo.tbl_change_request;
go

enable trigger dbo.trg_ii_tbl_change_request on dbo.tbl_change_request;
go

enable trigger dbo.trg_fu_tbl_change_request on dbo.tbl_change_request;
go