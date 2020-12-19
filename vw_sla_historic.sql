/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/30/2019																							   
 Modified Date: 03/10/2020																							   
											       																	   
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
	   l.unit_mrc as district,
	   left(l.unit_mrc, 1) as borough,
	   l.unit_desc,
	   r.sla_code,
	   r.season_id,
	   r.effective,
	   coalesce(r.effective_start_adj, sladb.dbo.fn_getdate('2014-01-01', 1)) as effective_start_adj,
	   /*coalesce(r.effective_end_adj, dbo.fn_getdate(cast(getdate() as date), 0)) as effective_end_adj
	   coalesce(r.effective_start, '2014-01-01') as effective_start,*/ 
	   case when r.effective_end_adj  >= cast(getdate() as date) then cast(getdate() as date)
			else r.effective_end_adj
	   end as effective_end_adj
from sladb.dbo.tbl_ref_unit as l
left join
	 sladb.dbo.tbl_unit_sla_season as r
on l.unit_id = r.unit_id
where cast(unit_withdraw as date) >= '2014-01-01' or
	  unit_withdraw is null)

select top 100 percent l.borough,
	   l.district,
	   l.unit_id,
	   l.unit_desc,
	   /*If the unit effective_start_adj date is greater than that of the season, use the date from the unit otherwise
	     use the date from the season.*/
	   case when l.effective_start_adj > r.effective_start_adj then l.effective_start_adj
			else r.effective_start_adj
	   end as effective_start_adj,
	   /*If the unit effective_end_adj date is less than that of the season, use the date from the unit otherwise
	     use the date from the season.*/
	   case when coalesce(l.effective_end_adj, cast(getdate() as date)) < r.effective_end_adj then coalesce(l.effective_end_adj, cast(getdate() as date))
			else r.effective_end_adj
	   end as effective_end_adj,
	   r2.sla_id,
	   r3.sla_min_days,
	   r3.sla_max_days
from units as l
left join
	 sladb.dbo.tbl_sla_season_date as r
on l.season_id = r.season_id and
   ((l.effective_start_adj between r.effective_start_adj and r.effective_end_adj) or
   (coalesce(l.effective_end_adj, cast(getdate() as date)) between r.effective_start_adj and r.effective_end_adj) or
   (r.effective_start_adj between l.effective_start_adj and l.effective_end_adj) or 
   (coalesce(r.effective_end_adj, cast(getdate() as date)) between l.effective_start_adj and l.effective_end_adj)) 
left join
	 sladb.dbo.tbl_ref_sla_translation as r2
on l.sla_code = r2.sla_code and
   r.date_category_id = r2.date_category_id
left join
	 sladb.dbo.tbl_ref_sla as r3
on r2.sla_id = r3.sla_id
--where l.effective_start_adj <= cast(getdate() as date) and
--	  r.effective_start_adj <= cast(getdate() as date)
order by unit_id, effective_start_adj