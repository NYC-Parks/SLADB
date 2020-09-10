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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_fu_tbl_change_request
on sladb.dbo.tbl_change_request
for update as 
	begin
			  
		begin transaction
			/*After a new record is submitted into the tbl_change_request, insert a corresponding record into the tbl_change_request_status table*/
			insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, created_user)
				select l.change_request_id,
					   l.sla_change_status,
					   /*Insert a default value for the status_user right now. The true value will need to be pulled through active directory, 
					   expertise of ITT required. It is stored in the employeeID attribute. If the sla_change_status is set to 4 = Invalid, then use
					   SYSTEM as the user.*/
					   case when l.sla_change_status = 4 then 'SYSTEM'
							else '0000000' 
					   end as created_user
				from inserted as l
				inner join
				/*Join the inserted and deleted tables and exclude any records that are changing from 4 to another status,
				  this type of change is not allowed.*/
					 deleted as r
				on l.change_request_id = r.change_request_id
				where not(r.sla_change_status = 4 and l.sla_change_status != 4) and
					  /*Exclude any updates to change requests with a value of 1 or approved*/
					  l.sla_change_status != 1 and 
					  r.sla_change_status != 4
		commit;

		begin transaction
			update u
				set sla_change_status = 4
				from sladb.dbo.tbl_change_request as u
				inner join
					 inserted as s
				on u.change_request_id = s.change_request_id
				inner join
					/*Join the inserted and deleted tables and exclude any records that are changing from 4 to another status,
					  this type of change is not allowed.*/
					deleted as s1
				on s.change_request_id = s1.change_request_id
				where s1.sla_change_status = 4 and s.sla_change_status != 4
		commit;

	end;


	 