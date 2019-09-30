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

create view dbo.vw_sla_historic as(
select l.unit_id,
	   date_start_adj, 
	   coalesce(l.effective_to, r.date_end_adj) as date_end_adj,
	   r2.sla_in,
	   r2.sla_off
from sladb.dbo.tbl_unit_sla_season as l
left join
	 sladb.dbo.tbl_sla_season_date as r
on l.season_id = r.season_id and
   ((l.effective_from <= r.date_start and
     l.effective_to between r.date_start and r.date_end) or
    (l.effective_to is null and 
	 l.effective_from <= r.date_end) or
    (l.effective_to <= r.date_start and 
	 l.effective_to > r.date_end))
left join
	 sladb.dbo.tbl_ref_sla_translation as r2
on l.sla_code = r2.sla_code)
--where effective_to is not null



