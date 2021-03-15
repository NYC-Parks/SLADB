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

create or alter view dbo.vw_change_request_email as

	with requests as(
	select change_request_id,
		   unit_id,
		   sla_code,
		   season_id,
		   effective_start_adj,
		   change_request_justification,
		   change_request_comments,
		   sla_change_status,
		   'request' as record_type
	from sladb.dbo.tbl_change_request
	where effective_start >= cast(getdate() as date) or
		  effective_start_adj >= cast(getdate() as date))
	
	,requests_current as(
	select r.change_request_id as change_request_id,
		   l.unit_id,
		   l.sla_code,
		   l.season_id,
		   null as effective_start_adj,
		   null as change_request_justification,
		   null as change_request_comments,
		   null as sla_change_status,
		   'current' as record_type
	from sladb.dbo.tbl_unit_sla_season as l
	inner join
		 requests as r
	on l.unit_id = r.unit_id
	where l.effective = 1
	union
	select change_request_id,
		   unit_id,
		   sla_code,
		   season_id,
		   effective_start_adj,
		   change_request_justification,
		   change_request_comments,
		   sla_change_status,
		   'request' as record_type
	from requests)

	select r4.sla_change_status_desc, /*Only email #2*/
		   l.change_request_comments, /*Only email #2*/
		   l.change_request_id,
		   l.unit_id,
		   r.unit_desc,
		   r.unit_mrc as district,
		   r5.sector as sector,
		   r3.season_desc as season_desc,
		   r2.in_season_sla as in_season_sla,
		   r2.off_season_sla as off_season_sla,
		   l.effective_start_adj,
		   r6.created_user,
		   l.record_type
	from requests_current as l
	left join
		sladb.dbo.tbl_ref_unit as r
	on l.unit_id = r.unit_id
	left join
		sladb.dbo.vw_sla_code_pivot as r2
	on l.sla_code = r2.sla_code
	left join
		sladb.dbo.tbl_sla_season as r3
	on l.season_id = r3.season_id
	left join
		sladb.dbo.tbl_ref_sla_change_status as r4
	on l.sla_change_status = r4.sla_change_status
	left join
		 (select *
		  from [appdb].dailytasks_dev.dbo.ref_sector_districts
		  where active = 1 and 
				lower(sector) not like '%all' and
				/*Exclude these two sectors to prevent duplication*/
				lower(sector) not in('q-swfd', 'r-sob')) as r5
	on r.unit_mrc = r5.district
	left join
		 sladb.dbo.tbl_change_request_status as r6
	on l.change_request_id = r6.change_request_id
	where r6.sla_change_status = 1
