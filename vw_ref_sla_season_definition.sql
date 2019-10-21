/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  09/12/2019																							   
 Modified Date: 10/21/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla_season_definition																							   
 			  sladb.dbo.tbl_sla_season																								   
 			  sladb.dbo.tbl_ref_sla_season_date_type				
			  																				   
 Description: Create a reference view for the season definition stored procedure.  									   
																													   												
***********************************************************************************************************************/
use sladb
go
--drop view dbo.vw_ref_sla_season_definition
create view dbo.vw_ref_sla_season_definition as

	select row_number() over(order by l.season_id, l.season_date_type_id) as row_id,
		   l.season_date_ref_id, 
		   l.season_id, 
		   l.season_date_ref_fixed, 
		   l.season_date_month_name_desc, 
		   l.season_date_ref_day_number, 
		   l.season_date_day_name_desc, 
		   l.season_day_rank_id,
		   l.season_date_type_id,
		   r.year_round,
		   r2.season_date_category_id
	from sladb.dbo.tbl_ref_sla_season_definition as l
	inner join
		sladb.dbo.tbl_sla_season as r
	on l.season_id = r.season_id
	left join
		sladb.dbo.tbl_ref_sla_season_date_type as r2
	on l.season_date_type_id = r2.season_date_type_id
	/*Exclude Seasons that are no longer active.*/
	where r.effective = 1;