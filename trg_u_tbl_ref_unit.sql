/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  10/15/2019																							   
 Modified Date: 02/20/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: inserted																						   
 			  sladb.dbo.tbl_ref_unit																								   		
			  																				   
 Description: Create a trigger that sets an SLA and Season to inactive if a unit has its status in AMPS (obj_status)
			  move from active (obj_status = I) to decommissioned (obj_status = D).
																													   												
***********************************************************************************************************************/
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_u_tbl_ref_unit
on sladb.dbo.tbl_ref_unit
after update as

	begin transaction;
		/*Create a CTE from the updated records. Note that updates go into both the inserted (new) and deleted (old)tables, but the new 
		  records are the only ones that matter for this trigger.*/
		with updates as(
		select unit_id, unit_status
		from inserted
		/*Filter to include only objects with a unit_status of D = Decommissioned. All other statuses are still considered to be active.*/
		where unit_status = 'D')
	
		/*Merge the updated rows and see if there is an effective SLA and Season for the given unit. If so, set the value of effective to 
		  0 and the effective_end date to the current date.*/
		merge sladb.dbo.tbl_unit_sla_season as tgt using updates as src
			on (tgt.unit_id = src.unit_id)
			when matched and effective = 1 and effective_end is null
				then update set tgt.effective = 0,
						        tgt.effective_end = cast(getdate() as date); 
	commit;

	begin transaction;
		/*Insert invalid status records for any change requests that have not been approved and for units that have been
		  decommissioned.*/
		insert into sladb.dbo.tbl_change_request_status(change_request_id, status_user, sla_change_status)
			select i.change_request_id,
				   'SYSTEM' as status_user,
				   4 as sla_change_status /*4 = Invalid*/
				 /*Select change requests that have ONLY 1 record in the status table.*/
			from (select change_request_id
				  from sladb.dbo.tbl_change_request_status
				  group by change_request_id
				  having count(*) = 1) as i
			inner join
			/*Inner join with the change requests bsased on the change_request_id*/
				  sladb.dbo.tbl_change_request as s1
			on i.change_request_id = s1.change_request_id
			/*Inner join with the inserted units that were decommissioned in AMPS*/
			inner join	
				(select unit_id
				 from inserted
				 /*Filter to include only objects with a unit_status of D = Decommissioned. All other statuses are still considered to be active.*/
				 where unit_status = 'D') as s2
			on s1.unit_id = s2.unit_id
	commit;