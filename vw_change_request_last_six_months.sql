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

create or alter view dbo.vw_change_request_last_six_months as 
	select l.change_request_id,
		   l.unit_id,
		   r4.season_desc,
		   r5.in_season_sla,
		   r5.off_season_sla,
		   l.effective_start_adj,
		   l.change_request_justification,
		   l.change_request_comments,
		   r.created_date_utc as submitted_date,
		   r2.created_date_utc as lastedit_date,
		   r.created_user as submitted_user,
		   r2.created_user as lastedit_user,
		   l.sla_change_status as current_status,
		   left(r6.unit_mrc, 1) as borough
	from sladb.dbo.tbl_change_request as l
	left join
		 sladb.dbo.tbl_change_request_status as r
	/*Join to the change request status based on the submitted request*/
	on l.change_request_id = r.change_request_id and 
	   r.sla_change_status = 1
	left join
		 sladb.dbo.tbl_change_request_status as r2
	/*Join to the change request status based on the most recent status. In these cases, the sla_change_status is equal.*/
	on l.change_request_id = r2.change_request_id and
	   l.sla_change_status = r2.sla_change_status
	/*left join
		 sladb.dbo.tbl_ref_sla_change_status as r3
	on l.sla_change_status = r3.sla_change_status*/
	left join
		 sladb.dbo.tbl_sla_season as r4
	on l.season_id = r4.season_id
	left join
		 sladb.dbo.vw_sla_code_pivot as r5
	on l.sla_code = r5.sla_code
	left join
		 sladb.dbo.tbl_ref_unit as r6
	on l.unit_id = r6.unit_id
	/*Convert the UTC datetimes to Eastern Standard time and include only submitted change requests from the last six months.*/
	where cast(r.created_date_utc at Time Zone 'UTC' at Time Zone 'Eastern Standard Time' as date) between dateadd(month, -6, cast(getdate() as date)) and cast(getdate() as date)