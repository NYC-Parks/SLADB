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

	if object_id('tempdb..#season_change') is not null
	drop table #season_change

	select distinct r.unit_id,
		   r.sla_code,
		   l.new_season_id as season_id,
		   r2.effective_start,
		   dbo.fn_season_change_justification(l.old_season_id, l.new_season_id) as change_request_justification,
		   case when r.sla_code = r3.sla_code then cast(1 as bit)
				else cast(0 as bit)
		   end as valid
	--into #season_change
	from sladb.dbo.tbl_sla_season_change as l
	left join
		 (select *
		  from sladb.dbo.tbl_unit_sla_season
		  where effective = 1) as r
	on l.old_season_id = r.season_id
	left join
		 sladb.dbo.tbl_sla_season as r2
	on l.new_season_id = r2.season_id
	outer apply
		dbo.fn_sla_code_valid(l.new_season_id) as r3
	where r.sla_code = r3.sla_code

	begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start, change_request_justification)
		select unit_id,
			   sla_code,
			   season_id,
			   effective_start,
			   change_request_justification
		from #season_change
	commit;

	insert into tbl_change_request_status(change_request_id, sla_change_status, status_user)
		select l.change_request_id,
			   2 as sla_change_status,
			   'SYSTEM' as status_user
		from sladb.dbo.tbl_change_request as l
		inner join
			 sladb.dbo.tbl_change_request_status as r
		on l.change_request_id = r.change_request_id
		where change_request_justification = (select distinct change_request_justification from #season_change)
