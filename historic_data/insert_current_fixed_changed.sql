/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  10/25/2019																   
 Modified Date: 12/27/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: ipmdb.dbo.tbl_sla_export																						   
 			  ipmdb.dbo.tbl_sla_seasonal_export																								   
 			  [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects
			  sladb.dbo.tbl_unit_sla_season
			  																				   
 Description: Create a script to insert SLA and Season values for units that haven't changed since 1/1/2014.									   
																													   												
***********************************************************************************************************************/
begin transaction;
	with slas as(
		select l.sla_code,
			   l.sla_id
		from (select sla_id,
					 sla_code
			  from sladb.dbo.tbl_ref_sla_translation
			  where date_category_id = 1) as l
		left join
			 (select sla_id,
					 sla_code
			  from sladb.dbo.tbl_ref_sla_translation
			  where date_category_id = 2) as r
		on l.sla_code = r.sla_code
		where l.sla_id = r.sla_id)

	,fixed_except as(
		select r.obj_code,
			   r.obj_udfchar02
		from(select obj_code
			 from ipmdb.dbo.tbl_sla_export
			 except
			 select unit_id as obj_code
			 from ipmdb.dbo.tbl_sla_seasonal_export) as l
		left join
			 ipmdb.dbo.tbl_sla_export as r
		on l.obj_code = r.obj_code)

	insert into sladb.dbo.tbl_unit_sla_season(unit_id,
											  sla_code,
											  season_id,
											  effective,
											  effective_from,
											  effective_to)

		select l.obj_code as unit_id,
			   r3.sla_code,
			   1 as season_id,
			   1 as effective,
			  case when r2.obj_commiss >= '2019-07-01' then cast(r2.obj_commiss as date)
				   else cast('2019-07-01' as date)
			  end as effective_from,
			  cast(coalesce(r2.obj_withdraw, null) as date) as effective_to
		from fixed_except as l
		left join
			 slas as r
		on l.obj_udfchar02 = r.sla_id
		inner join
			 (select obj_code collate SQL_Latin1_General_CP1_CI_AS as obj_code,
					 obj_commiss,
					 obj_withdraw,
					 /*If there is a null value assign it a value of 'N' since all sites have been reviewed.*/
					 coalesce(obj_udfchar02, 'N') as obj_udfchar02
			 from [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects
			 where obj_withdraw >= '2019-07-01' or
				   obj_withdraw is null) as r2
		on l.obj_code = r2.obj_code
		left join
			 slas as r3
		on r2.obj_udfchar02 collate SQL_Latin1_General_CP1_CI_AS = r3.sla_id
		inner join 
			 sladb.dbo.tbl_ref_unit as r4
		on l.obj_code = r4.unit_id
		where (r3.sla_code != r.sla_code or
			   r.sla_code is null and r3.sla_code is not null or
			   r3.sla_code is null and r.sla_code is not null) /*and
			   r2.obj_udfchar02 != 'NA'*/
commit;

