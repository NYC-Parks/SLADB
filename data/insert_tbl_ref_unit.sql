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

begin transaction
		insert into sladb.dbo.tbl_ref_unit(unit_id, 
										   unit_desc, 
										   unit_class, 
										   unit_mrc, 
										   unit_status, 
										   gisobjid, 
										   unit_commiss, 
										   unit_updated, 
										   unit_withdraw)

			/*Read the json data file, decrypt the edited_user column*/
			select unit_id, 
				   unit_desc, 
				   unit_class, 
				   unit_mrc, 
				   unit_status, 
				   gisobjid, 
				   unit_commiss, 
				   unit_updated, 
				   unit_withdraw
			from openjson((select cast(bulkcolumn as nvarchar(max))
						   from openrowset(bulk 'D:/Projects/SLADB_Data/tbl_ref_unit.json', single_clob) as j))
							with(unit_id nvarchar(30),
								 unit_desc nvarchar(80),
								 unit_class nvarchar(8),
								 unit_mrc nvarchar(15),
								 unit_status nvarchar(4),
								 gisobjid numeric(38,0),
								 unit_commiss datetime,
								 unit_updated datetime,
								 unit_withdraw datetime);
	commit;
go