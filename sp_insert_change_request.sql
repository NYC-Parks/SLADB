/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management  																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: 10/24/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_sla_season																							   
 			  sladb.dbo.tbl_ref_sla_season_definition																								   			
			  																				   
 Description: Create a procedure that performs an insert into two the tbl_sla_season table and the tbl_ref_sla_season_defintion
	          table and carries through the identity value (season_id) from the tbl_sla_season table.
																													   												
***********************************************************************************************************************/
use sladb
go

/*If the user-defined table types don't exist then create them. These user-defined table types
  are used as inputs into the sp_insert_season stored procedure.*/
if type_id('insert_change_request') is null
	create type insert_change_request
		as table(unit_id nvarchar(30) not null,
				 sla_code int not null,
				 season_id int not null,
				 /*Make sure that the effective start date is greater than or equal to today's date.*/
				 effective_start date not null,
				 change_request_justification nvarchar(2000) not null);

go

create or alter procedure dbo.sp_insert_change_request @new_change_request insert_change_request readonly,
													   @auto_approve int = 1 as

begin
	
		declare @change_request_id int;

		/*Set the value of the change_request_id parameter equal to the current identity plus 1, except if the table has not
		  yet been populated.*/
		set @change_request_id = (select case when ident_current('sladb.dbo.tbl_change_request') = 1 then 1 
											  else ident_current('sladb.dbo.tbl_change_request') + 1 end);

	begin transaction
		/*Insert the values into the Season table*/
		insert into sladb.dbo.tbl_change_request(unit_id,
												 sla_code,
												 season_id,
												 /*Make sure that the effective start date is greater than or equal to today's date.*/
												 effective_start,
												 change_request_justification)
			select * from @new_change_request;
	commit;
		
		if @auto_approve = 1
			begin
				begin transaction
					/*Insert values into the change_request_status table to auto-approve the submission.*/
					update sladb.dbo.tbl_change_request
						set sla_change_status = 2
						where change_request_id >= @change_request_id /*and
							  sla_change_status != 4*/;
				commit;
			end;
end;