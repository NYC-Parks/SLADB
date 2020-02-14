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
--drop trigger dbo.trg_sla_season_upsert
create trigger dbo.trg_unit_decommissioned
on sladb.dbo.tbl_ref_unit
after update as

	begin transaction;
		with updates as(
		select unit_id, unit_status
		from inserted
		where unit_status = 'D')
	
		/*Merge the updated rows and see if there is an effective SLA and Season for the given unit. If so, set the value of effective to 0 and
		  the date for effective_to to the Saturday following the date it was decommissioned.*/
		merge sladb.dbo.tbl_unit_sla_season as tgt using updates as src
			on (tgt.unit_id = src.unit_id)
			when matched and effective = 1 and effective_end is null
				then update set tgt.effective = 0,
						        tgt.effective_end = (select dbo.fn_getdate(cast(getdate() as date), 0)); 
	commit;