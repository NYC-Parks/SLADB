/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/30/2019																							   
 Modified Date: 10/28/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_unit_sla_season																							   
 			  sladb.dbo.tbl_sla_season_date																								   
 			  sladb.dbo.tbl_ref_sla_translation				
			  																				   
 Description: Create a view that shows the current and historic SLAs for sites at a given point in time.  									   
																													   												
***********************************************************************************************************************/
use sladb
go

create view dbo.vw_sla_historic as(
select l.unit_id,
	   coalesce(r.effective_from_adj, l.effective_from) as effective_from_adj, 
	   case when coalesce(l.effective_to, r.effective_to_adj)  >= cast(getdate() as date) then cast(getdate() as date)
			else coalesce(l.effective_to, r.effective_to_adj) 
	   end as effective_to_adj,
	   r2.sla_id
from sladb.dbo.tbl_unit_sla_season as l
left join
	 sladb.dbo.tbl_sla_season_date as r
on l.season_id = r.season_id and
   ((l.effective_from <= r.effective_from and
     l.effective_to between r.effective_from and r.effective_to) or
    (l.effective_to is null and 
	 l.effective_from <= r.effective_to) or
    (l.effective_to <= r.effective_from and 
	 l.effective_to > r.effective_to))
left join
	 sladb.dbo.tbl_ref_sla_translation as r2
on l.sla_code = r2.sla_code and
   r.date_category_id = r2.date_category_id
where effective_to_adj <= cast(getdate() as date) or
	  l.effective_to is null
order by unit_id)


