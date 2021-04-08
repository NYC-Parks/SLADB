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

set nocount on;

/*Turn all the triggers off for tbl_change_request
disable trigger dbo.trg_ai_tbl_change_request_status on dbo.tbl_change_request_status;
go*/

/*Turn identity insert on*/
set identity_insert sladb.dbo.tbl_change_request_status on;
go

/*Open the sym key*/
open symmetric key sladb_symkey
	decryption by certificate sladb_cert;

if object_id('tempdb..#change_status') is not null
	 drop table #change_status;

/*Read the json data file, decrypt the edited_user column*/
select change_request_status_id,
		change_request_id,
		sla_change_status,
		created_date_utc,
		isnull(convert(nvarchar(7), decryptbykey(created_user)), '0000000') as created_user
into #change_status
from openjson((select cast(bulkcolumn as nvarchar(max))
				from openrowset(bulk 'D:/Projects/SLADB_Data/tbl_change_request_status.json', single_clob) as j))
				with(change_request_status_id int,
						change_request_id int,
						sla_change_status int, 
						created_date_utc datetime,
						created_user varbinary(max))

declare @min_id int = (select min(change_request_status_id) from #change_status);

declare @max_id int = (select max(change_request_status_id) from #change_status);

declare @i int = @min_id;

while @i <= @max_id
	begin
		print @i
		if exists(select * from #change_status where change_request_status_id = @i)
			begin
				begin transaction
					insert into sladb.dbo.tbl_change_request_status(change_request_status_id,
																	change_request_id,
																	sla_change_status,
																	created_date_utc,
																	created_user)
						select change_request_status_id,
							   change_request_id,
							   sla_change_status,
							   created_date_utc,
							   created_user
						from #change_status
						where change_request_status_id = @i
				commit;
			end;
		set @i = @i + 1
	end;
/*Close the sym key*/
close symmetric key sladb_symkey;
go


/*Turn identity insert off*/
set identity_insert sladb.dbo.tbl_change_request_status off;
go

/*Enable all the triggers on tbl_change_request_status
enable trigger dbo.trg_ai_tbl_change_request_status on dbo.tbl_change_request_status;
go*/