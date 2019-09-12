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
--drop view dbo.vw_date_ref_fixed
create view dbo.vw_date_ref_fixed as 
	select l.season_id,
			r.actual_date,
			r.adjusted_date,
			row_number() over(partition by season_id, season_date_type_id order by season_id, season_date_type_id) as date_row,
			l.season_date_type_id,
			l.season_date_category_id
	from sladb.dbo.vw_ref_sla_season_definition as l
	left join
		 sladb.dbo.vw_season_dates_adjusted as r
	on l.season_date_month_name_desc = r.month_name and
		l.season_date_ref_day_number = r.season_date_ref_day_number
	where l.season_date_ref_fixed = 1;