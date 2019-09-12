/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  09/12/2019																							   
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
		   r.season_year_round,
		   r2.season_date_category_id
	from sladb.dbo.tbl_ref_sla_season_definition as l
	inner join
		sladb.dbo.tbl_sla_season as r
	on l.season_id = r.season_id
	left join
		sladb.dbo.tbl_ref_sla_season_date_type as r2
	on l.season_date_type_id = r2.season_date_type_id
	/*Exclude Seasons that are no longer active.*/
	where r.season_active = 1;