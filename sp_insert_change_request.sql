/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  10/28/2019																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: sladb.dbo.tbl_change_request																							   
 			  sladb.dbo.tbl_change_request_justification																								   		
			  																				   
 Description: Create a stored procedure to insert records into the change request table and tie a justification to the
			  specific change request.
																													   												
***********************************************************************************************************************/
use sladb
go
create procedure dbo.sp_insert_change_request @unit_id nvarchar(30),
											  @sla_code int,
											  @season_id int,
											  @change_request_justification nvarchar(2000) as
begin
	
	declare @change_request_id int = ident_current('sladb.dbo.tbl_change_request');

	begin transaction
		insert into sladb.dbo.tbl_change_request(unit_id,
												 sla_code,
												 season_id)
			values(@unit_id, @sla_code, @season_id);

	
		insert into sladb.dbo.tbl_change_request_justification(change_request_id,
															   change_request_justification)
			values(@change_request_id, @change_request_justification);
	commit transaction;



end;