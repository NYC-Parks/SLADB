/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  10/25/2019																   
 Modified Date: 10/30/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla_translation																							   
 			  ipmdb.dbo.tbl_sla_export																								   
 			  [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects
			  sladb.dbo.tbl_unit_sla_season
			  																				   
 Description: Create a script to insert the updated SLA and Season values for units that changed when SLAs and Seasons 
			  were reviewed and updated.
																													   												
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

	,historic as(
	select l.obj_code, 
		   r2.sla_code,
		   case when r.obj_commiss >= '2019-07-01' then cast(r.obj_commiss as date)
				else cast('2019-07-01' as date)
		   end as effective_from,
		   cast(coalesce(r.obj_withdraw, null) as date) as effective_to
	/*Historic SLAs and Seasons snapshot*/
	from (select *,
				 obj_udfchar02 as sla_id
		  from ipmdb.dbo.tbl_sla_export) as l
	left join
	/*Current SLAs and Seasons*/
		 (select obj_code collate SQL_Latin1_General_CP1_CI_AS as obj_code,
				 obj_commiss,
				 obj_withdraw,
				 obj_udfchar02
		  from [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects) as r
	on l.obj_code = r.obj_code collate SQL_Latin1_General_CP1_CI_AS
	left join
		 slas as r2
	/*Join the SLA translation to the current SLAs in AMPS*/
	on r.obj_udfchar02 collate SQL_Latin1_General_CP1_CI_AS = r2.sla_id
	where l.obj_udfchar02 != r.obj_udfchar02 collate SQL_Latin1_General_CP1_CI_AS or
		  /*Include records where the SLA used to be null, but now is not null.*/
		  l.obj_udfchar02 is null and r.obj_udfchar02 is not null)

	insert into sladb.dbo.tbl_unit_sla_season(unit_id, sla_code, season_id, effective, effective_from, effective_to)
		select obj_code as unit_id,
			   sla_code,
			   1 as season_id,
			   case when effective_to is null then 1
					else 0
			   end as effective,
			   effective_from,
			   effective_to
		from historic;
commit;
