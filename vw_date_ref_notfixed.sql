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
--drop view dbo.vw_date_ref_notfixed
create view dbo.vw_date_ref_notfixed as 
	select l.season_id,
			r.actual_date,
			r.adjusted_date,
			row_number() over(partition by season_id, season_date_type_id order by season_id, season_date_type_id) as n,
			l.season_date_type_id,
			l.season_date_category_id
	from sladb.dbo.vw_ref_sla_season_definition as l
	left join
		 sladb.dbo.vw_season_dates_adjusted as r
	on l.season_date_day_name_desc = r.day_name and
	   l.season_day_rank_id = r.day_rank
	where l.season_date_ref_fixed = 0