/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  10/28/2019																							   
 Modified Date: 10/30/2019																						   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
begin transaction;
	with seasonal as(
		select unit_id,
			   justification,
			   case when r.obj_commiss >= '2014-01-01' then cast(r.obj_commiss as date)
					else cast('2014-01-01' as date)
			   end as effective_from,
			   cast(coalesce(r.obj_withdraw, '2019-06-30') as date) as effective_to
		from ipmdb.dbo.tbl_sla_seasonal_export as l
		left join
			 [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects as r
		on l.unit_id = r.obj_code collate SQL_Latin1_General_CP1_CI_AS)

	
		,seasonal_historic as(
		select l.*, r.obj_udfchar02
		from seasonal as l
		left join
			 ipmdb.dbo.tbl_sla_export as r
		on l.unit_id = r.obj_code)

		,slas as(
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

	insert into sladb.dbo.tbl_unit_sla_season(unit_id,
											  season_id,
											  sla_code,
											  effective,
											  effective_from,
											  effective_to)
		select l.unit_id,
			   1 as season_id,
			   r.sla_code,
			   0 as effective,
			   effective_from,
			   effective_to
		from seasonal_historic as l
		inner join
			 slas as r
		on l.obj_udfchar02 = r.sla_id;
commit;	