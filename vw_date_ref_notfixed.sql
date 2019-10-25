/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  09/12/2019																							   
 Modified Date: 10/24/2019																							   
											       																	   
 Project: SLADB	
 																							   
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
--drop view dbo.vw_date_ref_notfixed
create view dbo.vw_date_ref_notfixed as 
	select l.season_id,
			r.ref_date,
			r.saturday_ref_date,
			r.sunday_ref_date,
			row_number() over(partition by season_id, date_type_id order by season_id, date_type_id) as date_row,
			l.date_type_id,
			l.date_category_id
	from sladb.dbo.vw_ref_sla_season_definition as l
	left join
		 sladb.dbo.vw_season_dates_adjusted as r
	on l.month_name_desc = r.month_name_desc and
	   l.day_name_desc = r.day_name_desc and
	   l.day_rank_id = r.day_rank_id
	where l.date_ref_fixed = 0