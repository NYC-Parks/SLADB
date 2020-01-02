/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/30/2019																							   
 Modified Date: 01/02/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_unit_sla_season																							   
 			  sladb.dbo.tbl_sla_season_date																								   
 			  sladb.dbo.tbl_ref_sla_translation				
			  																				   
 Description: Create a view that shows the current and historic SLAs for sites at a given point in time.  									   
																													   												
***********************************************************************************************************************/
use sladb
go

create or alter view dbo.vw_sla_historic as

with units as (
select l.unit_id,
	   r.sla_code,
	   r.season_id,
	   r.effective,
	   coalesce(r.effective_from, '2014-01-01') as effective_from, 
	   case when r.effective_to  >= cast(getdate() as date) then cast(getdate() as date)
			else dbo.fn_getdate(r.effective_to, 0) 
	   end as effective_to
from sladb.dbo.tbl_ref_unit as l
left join
	 sladb.dbo.tbl_unit_sla_season as r
on l.unit_id = r.unit_id
where cast(unit_withdraw as date) >= '2014-01-01' or
	  unit_withdraw is null)

select top 100 percent l.unit_id,
	   coalesce(r.effective_from_adj, l.effective_from) as effective_from_adj, 
	   case when coalesce(l.effective_to, r.effective_to_adj)  >= cast(getdate() as date) then cast(getdate() as date)
			else coalesce(dbo.fn_getdate(l.effective_to, 0), r.effective_to_adj) 
	   end as effective_to_adj,
	   r2.sla_id
from units as l
left join
	 sladb.dbo.tbl_sla_season_date as r
on l.season_id = r.season_id and
   ((l.effective_from <= r.effective_from and l.effective_to between r.effective_from and r.effective_to) or
    (l.effective_to is null and l.effective_from <= r.effective_to) or
    (l.effective_to between r.effective_from and r.effective_to))
left join
	 sladb.dbo.tbl_ref_sla_translation as r2
on l.sla_code = r2.sla_code and
   r.date_category_id = r2.date_category_id
order by unit_id, effective_from_adj
/*where effective_to_adj <= cast(getdate() as date) or
	  l.effective_to is null*/


