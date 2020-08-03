/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  10/18/2019																							   
 Modified Date: 02/12/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_unit_sla_season																							   			
			  																				   
 Description: Create a trigger that allows values to be updated and inserted in bulk if an existing season is replaced
			  by a new season. This will prevent the user to have to update the season records 1 by 1.
																													   												
***********************************************************************************************************************/
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter procedure dbo.sp_i_tbl_sla_season_change as
	begin
		if object_id('tempdb..#season_change') is not null
			drop table #season_change;

		/*Insert records into a temporary table for each unit with the existing. Carry over the current sla_code and check the
		  validity, calculate the change request justification and use the effective start date of the new season.*/
		select distinct r.unit_id,
			   r.sla_code,
			   l.new_season_id as season_id,
			   r2.effective_start,
			   /*Use this user-defined function to create a justification for the change request using the new and old
					 season_id values.*/
			   dbo.fn_season_change_justification(l.old_season_id, l.new_season_id) as change_request_justification,
			   case when r2.year_round = r3.year_round then cast(1 as bit)
					else cast(0 as bit)
			   end as valid
		into #season_change
		from sladb.dbo.tbl_sla_season_change as l
		inner join
		/*Filter to include only units that are effective = 1 and are assigned to the old season_id.*/
			 (select *
			  from sladb.dbo.tbl_unit_sla_season
			  where effective = 1) as r
		on l.old_season_id = r.season_id
		left join
			 sladb.dbo.tbl_sla_season as r2
		on l.new_season_id = r2.season_id
		left join
			 sladb.dbo.vw_sla_code_pivot as r3
		on r.sla_code = r3.sla_code;

		/*Insert records into the change request table for each unit with the new season and the previous sla_code. Note that this insert
		  happens regardless of the validity of the request, the next step handles that*/
		begin transaction
		insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start, change_request_justification)
			select unit_id,
				   sla_code,
				   season_id,
				   effective_start,
				   change_request_justification
			from #season_change;
		commit;

		/*Join the temporary table with the change request and change request status tables in order to insert the records granting
		  automatic approval of these changes. The idea is to take the human of needing to make these particular changes.*/
		begin transaction
		insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_user)
			select l.change_request_id,
				   /*If the SLA value is valid for the type of season then 2 = approve the change. Note that invalid values will be caught*/
				   2 as sla_change_status,
				   /*Set the status user to SYSTEM because this process is done by the database.*/
				   'SYSTEM' as status_user
			from sladb.dbo.tbl_change_request as l
			inner join
				 sladb.dbo.tbl_change_request_status as r
			on l.change_request_id = r.change_request_id
			left join
				 #season_change as r2
			on l.unit_id = r2.unit_id and
			   l.season_id = r2.season_id and 
			   l.sla_code = r2.sla_code
				  /*Extract only records having the correct change request justification.*/
			where l.change_request_justification = (select distinct change_request_justification from #season_change) and
				  /*Exclude invalid records because these are caught through a different workflow.*/
				  r2.valid = 1;
		commit;
	end;