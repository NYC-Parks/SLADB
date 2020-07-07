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
begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id,
											 sla_code,
											 season_id,
											 effective_start,
											 change_request_justification)
		select l.unit_id,
			   l.sla_code,
			   l.season_id,
			   '2020-07-05' as effective_start,
			   'Reactivate SLA prior to COVID-19 NY Pause' as change_request_justification
		from sladb.dbo.tbl_unit_sla_season as l
		right join
			 (select *
			  from sladb.dbo.tbl_change_request
			  where effective_start = '2020-03-22') as r
		on l.unit_id = r.unit_id
		where l.effective_end = '2020-03-21' and
			  l.season_id != 4;
commit;

begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id,
											 sla_code,
											 season_id,
											 effective_start,
											 change_request_justification)
		select l.unit_id,
			   l.sla_code,
			   l.season_id,
			   '2020-07-05' as effective_start,
			   'Reactivate SLA prior to COVID-19 NY Pause' as change_request_justification
		from sladb.dbo.tbl_unit_sla_season as l
		right join
			 (select *
			  from sladb.dbo.tbl_change_request
			  where effective_start = '2020-04-05') as r
		on l.unit_id = r.unit_id
		where l.effective_end = '2020-04-04' and
			  l.season_id != 4;
commit;

begin transaction
	update sladb.dbo.tbl_change_request_status
		set status_user = '1552495'
		where status_date = '2020-07-01' and
			  sla_change_status = 1;
commit; 

begin transaction
insert into sladb.dbo.tbl_change_request_status(change_request_id,
												sla_change_status,
												status_user)

	select change_request_id, 
		   2 as sla_change_status, 
		   '1552495' status_user
	from sladb.dbo.tbl_change_request_status
	where status_date = '2020-07-01';
commit;