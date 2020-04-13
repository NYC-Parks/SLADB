exec sladb.dbo.sp_merge_ref_unit
go 

with no_slas as(
select distinct l.unit_id/*, r.unit_id*/
from sladb.dbo.tbl_ref_unit as l
left join
     (select distinct unit_id
	  from sladb.dbo.tbl_unit_sla_season) as r
on l.unit_id = r.unit_id
where r.unit_id is null)

,no_slas2 as (
select l.unit_id,
	   r.obj_status,
	   r.obj_commiss,
	   case when r.obj_udfchar02 = 'NA' then 'N'
		    else r.obj_udfchar02
	   end as sla_code
from no_slas as l
left join
	 (select obj_code collate SQL_Latin1_General_CP1_CI_AS as obj_code,
			 obj_desc,
			 obj_class,
			 obj_mrc,
			 obj_status,
			 obj_gisobjid,
			 obj_commiss,
			 obj_updated,
			 obj_withdraw,
			 obj_udfchar02
	 from [dataparks].eamprod.dbo.r5objects) as r
on l.unit_id = r.obj_code
where lower(r.obj_status) = 'i' or
	  obj_withdraw >= '2019-07-01')

select r2.unit_id,
	   r.ava_from,
	   r.ava_to,
	   r.ava_changed,
	   r.ava_modifiedby,
	   count(r2.unit_id) over(partition by r2.unit_id order by ava_changed) as nchanges
from (select aat_code,
			 aat_table
	  from [dataparks].eamprod.dbo.r5audattribs
	  where lower(aat_table) = 'r5objects' and 
		    lower(aat_column) = 'obj_udfchar02') as l
left join
	 [dataparks].eamprod.dbo.r5audvalues as r
on l.aat_table = r.ava_table and
   l.aat_code = r.ava_attribute
inner join
	 no_slas2 as r2
on r.ava_primaryid collate SQL_Latin1_General_CP1_CI_AS = r2.unit_id
order by unit_id, ava_changed

