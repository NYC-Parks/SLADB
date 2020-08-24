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

create or alter trigger dbo.trg_i_tbl_sla_season_change
on sladb.dbo.tbl_sla_season_change
after insert as
	begin
		begin transaction
				update sladb.dbo.tbl_sla_season
					set effective_end = s.effective_end,
						updated_date_utc = getutcdate()
					from sladb.dbo.tbl_sla_season as u
					inner join
						/*Join the season table with the inserted table on the new (replacing) season on the new season_id. Take the old
						  season_id value and the effective_start date from the new season and use that as the effective_end date of the new
						  season.*/
						(select r.old_season_id as season_id,
								/*Subtract one day from the effective_start adjusted date so that it becomes the Saturday and the effective_end date of the other season.*/
								dateadd(day, -1, l.effective_start_adj) as effective_end
						 from sladb.dbo.tbl_sla_season as l
						 inner join	
							  inserted as r
						 on l.season_id = r.new_season_id) as s
					on u.season_id = s.season_id
		commit;

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
		from inserted as l
		inner join
		/*Filter to include only units that are effective = 1 and are assigned to the old season_id.*/
			 (select *
			  from sladb.dbo.tbl_unit_sla_season
			  where effective = 1) as r
		on l.old_season_id = r.season_id
		inner join
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
		update u
			/*Set the value of sla_change_status to 2 = approve to auto-approve the change. Note that invalid records will
			  be handled else by other scripts.*/
			set u.sla_change_status = 2
			from sladb.dbo.tbl_change_request as u
			inner join
				 #season_change as s
			on u.unit_id = s.unit_id and
			   u.season_id = s.season_id and 
			   u.sla_code = s.sla_code
			/*Extract only records having the correct change request justification.*/
			where u.change_request_justification = (select distinct change_request_justification from #season_change) and
				  /*Don't auto approve records that were already invalidated*/
				  u.sla_change_status != 4
		commit;
	
	end;
