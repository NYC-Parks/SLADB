/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/30/2019																							   
 Modified Date: 01/24/2020																							   
											       																	   
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
	   coalesce(r.effective_start, '2014-01-01') as effective_start, 
	   case when r.effective_end  >= cast(getdate() as date) then cast(getdate() as date)
			else dbo.fn_getdate(r.effective_end, 0) 
	   end as effective_end
from sladb.dbo.tbl_ref_unit as l
left join
	 sladb.dbo.tbl_unit_sla_season as r
on l.unit_id = r.unit_id
where cast(unit_withdraw as date) >= '2014-01-01' or
	  unit_withdraw is null)

select top 100 percent l.unit_id,
	   case when l.effective_end is null and dbo.fn_getdate(l.effective_start, 1) between r.effective_start_adj and effective_end_adj then dbo.fn_getdate(l.effective_start, 1)
			else r.effective_start_adj
	   end as effective_start_adj,
	   case when coalesce(l.effective_end, r.effective_end_adj)  >= cast(getdate() as date) then cast(getdate() as date)
			else coalesce(dbo.fn_getdate(l.effective_end, 0), r.effective_end_adj) 
	   end as effective_end_adj,
	   r2.sla_id,
	   r3.sla_min_days,
	   r3.sla_max_days
from units as l
left join
	 sladb.dbo.tbl_sla_season_date as r
on l.season_id = r.season_id and
   ((l.effective_start <= r.effective_start and l.effective_end between r.effective_start and r.effective_end) or
    (l.effective_end is null and l.effective_start <= r.effective_end) or
    (l.effective_end between r.effective_start and r.effective_end))
left join
	 sladb.dbo.tbl_ref_sla_translation as r2
on l.sla_code = r2.sla_code and
   r.date_category_id = r2.date_category_id
left join
	 sladb.dbo.tbl_ref_sla as r3
on r2.sla_id = r3.sla_id
where effective_end_adj <= cast(getdate() as date) or
	  l.effective_end is null
order by unit_id, effective_start_adj