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