/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  10/11/2019																							   
 Modified Date: 10/15/2019																							   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: inserted																						   
 			  sladb.dbo.tbl_change_request																								   		
			  																				   
 Description: Create a trigger  									   
																													   												
***********************************************************************************************************************/
use sladb
go
--drop trigger dbo.trg_sla_season_upsert
create trigger dbo.trg_sla_season_upsert
on sladb.dbo.tbl_change_request_status 
after insert as

	begin transaction;
		declare @inserts table(unit_id nvarchar(30), 
							   sla_code int, 
							   season_id int, 
							   status_date date);

		declare @updates table(unit_id nvarchar(30), 
							   sla_code int, 
							   season_id int, 
							   status_date date,
							   sla_season_id int);

		insert into @inserts(unit_id, sla_code, season_id, status_date)
			select unit_id, sla_code, season_id, status_date 
			from inserted as l
			left join
				 sladb.dbo.tbl_change_request as r
			on l.change_request_id = r.change_request_id
			/*Change request status = Approved*/
			where l.sla_change_status = 2;
		
		/*Account for existing records for a unit that need to be updated*/
		insert into @updates(unit_id, sla_code, season_id, status_date, sla_season_id)
			select l.*,
					r.sla_season_id
			from @inserts as l
			left join
				 sladb.dbo.tbl_unit_sla_season as r
			on l.unit_id = r.unit_id
			where (r.effective = 1 and r.effective_to is null)

		/*Update if required*/
		update sladb.dbo.tbl_unit_sla_season
			set effective = 0,
				effective_to = sladb.dbo.fn_getdate(cast(getdate() as date), 0)
			from @updates as u
			where sladb.dbo.tbl_unit_sla_season.sla_season_id = u.sla_season_id;
	
		/*Insert new records.*/
		insert into sladb.dbo.tbl_unit_sla_season(unit_id, 
												  sla_code, 
												  season_id,
												  effective,
												  effective_from)
			select unit_id, sla_code, season_id, 1 as effective, sladb.dbo.fn_getdate(status_date, 1)
			from @inserts
												 
	commit;