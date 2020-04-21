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
exec sladb.dbo.sp_merge_ref_unit
go 

if object_id('tempdb..#no_slas') is not null
	 drop table #no_slas;

select distinct l.unit_id/*, r.unit_id*/
into #no_slas
from sladb.dbo.tbl_ref_unit as l
left join
     (select distinct unit_id
	  from sladb.dbo.tbl_unit_sla_season) as r
on l.unit_id = r.unit_id
where r.unit_id is null

if object_id('tempdb..#no_slas2') is not null
	 drop table #no_slas2;

select l.unit_id,
	   r.obj_status,
	   r.obj_commiss,
	   case when r.obj_udfchar02 = 'NA' then 'N'
		    else r.obj_udfchar02
	   end as sla_code
into #no_slas2
from #no_slas as l
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
	  obj_withdraw >= '2019-07-01';

if object_id('tempdb..#no_slas3') is not null
	 drop table #no_slas3;

select r2.unit_id,
	   r.ava_from,
	   r.ava_to,
	   r.ava_changed,
	   r.ava_modifiedby,
	   count(r2.unit_id) over(partition by r2.unit_id order by /*ava_changed,*/ unit_id) as nchanges
into #no_slas3
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
	 #no_slas2 as r2
on r.ava_primaryid collate SQL_Latin1_General_CP1_CI_AS = r2.unit_id
where ava_changed < '2020-03-30'
order by unit_id, ava_changed

if object_id('tempdb..#change_request') is not null
	 drop table #change_request;

select l.unit_id,
	   r.sla_code,
	   1 as season_id,
	   cast(l.ava_changed as date) as effective_start,
	  'No previous SLAs.' as change_request_justification
into #change_request
from #no_slas3 as l
left join
	 (select *
	  from sladb.dbo.vw_sla_code_pivot
	  where in_season_sla = off_season_sla) as r
on l.ava_from collate SQL_Latin1_General_CP1_CI_AS = r.in_season_sla

/*Disable the check constraint to allow for historic data to be inserted*/
alter table sladb.dbo.tbl_change_request
	nocheck constraint ck_change_request_effective_start;

begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start, change_request_justification)
		select unit_id, 
			   sla_code, 
			   season_id, 
			   effective_start, 
			   change_request_justification
		from #change_request;
commit;

-- need to get the row id for the last record to filter on later
declare @i int = (select ident_current('sladb.dbo.tbl_change_request_status'));

begin transaction 
	insert into sladb.dbo.tbl_change_request_status (change_request_id, sla_change_status, status_user)
		select change_request_id, 2 as sla_change_status, '1552495' status_user
		from sladb.dbo.tbl_change_request_status
		where change_request_status_id > @i;
commit;

/*Enable the check constraint so that only current or future data can be inserted or updated.*/
alter table sladb.dbo.tbl_change_request
	check constraint ck_change_request_effective_start;
