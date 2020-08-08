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

create or alter trigger dbo.trg_i_tbl_change_request
on sladb.dbo.tbl_change_request
for insert as 
	begin
		begin transaction
			/*After a new record is submitted into the tbl_change_request, insert a corresponding record into the tbl_change_request_status table*/
			insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_user)
				select change_request_id,
					   1, /*1 = Submitted*/
					   '0000000' /*Insert a default value for now. The true value will need to be pulled through active directory, expertise of ITT required. It
								   is stored in the employeeID attribute.*/
				from inserted
		 	
		commit;

		/*Insert records for any invalid combinations of year round seasons and year round SLAs. This is a terminal status.*/
		begin transaction
			insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_user)
				select l.change_request_id,
					   4 as sla_change_status, /*4 = Invalid*/
					  'SYSTEM' as status_user /*This is system generated, so adding SYSTEM as the user.*/
				from inserted as l
				left join
					 sladb.dbo.tbl_sla_season as r
				on l.season_id = r.season_id
				left join
						sladb.dbo.vw_sla_code_pivot as r2
				on l.sla_code = r2.sla_code
				/*Invalidate seasons/slas with mismatches in year round status or where the season is no longer effective.*/
				where r.year_round != r2.year_round or
					  (r.effective = 0 and r.effective_end is not null);
		commit;
	end;


	 