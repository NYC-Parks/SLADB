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
select *
from sladb.dbo.tbl_ref_unit as l
left join
	 [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects as r
on l.unit_id = r.obj_code collate SQL_Latin1_General_CP1_CI_AS


select l.obj_code, 
	   case when l.obj_udfchar02 = 'NULL' then null
			else l.obj_udfchar02
	   end as sla_old,
	   r.obj_udfchar02 as sla_new
from ipmdb.dbo.tbl_sla_export as l
left join
	 [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects as r
on l.obj_code = r.obj_code collate SQL_Latin1_General_CP1_CI_AS
where l.obj_udfchar02 !=  r.obj_udfchar02 collate SQL_Latin1_General_CP1_CI_AS


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

select l.obj_code, 
	   r2.sla_code,
	   case when r.obj_commiss >= '2014-01-01' then cast(r.obj_commiss as date)
			else cast('2014-01-01' as date)
	   end as effective_from,
	   coalesce(r.obj_withdraw, null) as effective_to
from (select *,
	         case when obj_udfchar02 = 'NULL' then 'N'
				  else obj_udfchar02
		     end as sla_id
	   from ipmdb.dbo.tbl_sla_export) as l
left join
	 (select obj_code collate SQL_Latin1_General_CP1_CI_AS as obj_code,
			 obj_commiss,
			 obj_withdraw,
			 case when obj_udfchar02 = 'NULL' then 'N'
				  else obj_udfchar02
		     end as obj_udfchar02
	  from [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects) as r
on l.obj_code = r.obj_code collate SQL_Latin1_General_CP1_CI_AS
left join
	 slas as r2
on l.sla_id = r2.sla_id
where l.obj_udfchar02 =  r.obj_udfchar02 collate SQL_Latin1_General_CP1_CI_AS

