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
/*Insert the NY Pause, COVID-19 Pandemic Season into SLADB so that this information can be track.*/
begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective, effective_start)
		values('NY Pause, COVID-19 Pandemic', 1, 1, '2020-03-22');
commit;

if object_id('tempdb..#audits') is not null
	drop table #audits;

select r.ava_primaryid as unit_id,
	   r.ava_from,
	   case when r.ava_to = 'NA' then 'N'
		    else r.ava_to
	   end as in_season_sla,
	   case when r.ava_to = 'NA' then 'N'
		    else r.ava_to
	   end as off_season_sla,
	   count(*) over(partition by r.ava_primaryid  order by cast(r.ava_changed as date) asc) as n,
	   row_number() over(partition by r.ava_primaryid  order by cast(r.ava_changed as date) asc) as maxn,
	   r.ava_changed
into #audits
from (select aat_code,
			 aat_table
	  from [dataparks].eamprod.dbo.r5audattribs
	  where lower(aat_table) = 'r5objects' and 
		    lower(aat_column) = 'obj_udfchar02') as l
left join
	 [dataparks].eamprod.dbo.r5audvalues as r
on l.aat_table = r.ava_table and
   l.aat_code = r.ava_attribute
where r.ava_changed >= '2020-03-22';

if object_id('tempdb..#change_request') is not null
	drop table #change_request;

select l.unit_id,
	   r.sla_code,
	   4 as season_id,
	   case when cast(l.ava_changed as date) between '2020-03-22' and '2020-03-30' then '2020-03-22'
		    else '2020-04-05'
	   end as effective_start,
	   case when cast(l.ava_changed as date) between '2020-03-22' and '2020-03-30' and l.ava_from = 'C' then 'C SLAs are suspended; C sites should be maintained only on an ‘as-needed’ or ‘as-able’ basis'
			when cast(l.ava_changed as date) between '2020-03-22' and '2020-03-30' and l.ava_from = 'B' then 'B SLAs sites are now Cs'
			when cast(l.ava_changed as date) between '2020-03-22' and '2020-03-30' and l.ava_from = 'A' then 'A SLAs sites are now Bs, except playgrounds which remain A as long as they are open'
			else 'Due to closures, playground SLAs are suspended'
	   end as change_request_justification
into #change_request
from #audits as l
left join
	 (select *
	  from sladb.dbo.vw_sla_code_pivot
	  where in_season_sla = off_season_sla) as r
on l.in_season_sla collate SQL_Latin1_General_CP1_CI_AS = r.in_season_sla and
   l.off_season_sla collate SQL_Latin1_General_CP1_CI_AS = r.off_season_sla
where n = maxn;

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
		from #change_request
		where effective_start = '2020-03-22';
commit;

-- need to get the row id for the last record to filter on later
declare @i int = (select ident_current('sladb.dbo.tbl_change_request_status'));

begin transaction 
	insert into sladb.dbo.tbl_change_request_status (change_request_id, sla_change_status, status_user)
		select change_request_id, 2 as sla_change_status, '1552495' status_user
		from sladb.dbo.tbl_change_request_status
		where change_request_status_id > @i;
commit;


begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start, change_request_justification)
		select unit_id, 
			   sla_code, 
			   season_id, 
			   effective_start, 
			   change_request_justification
		from #change_request
		where effective_start = '2020-04-05';
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
