
if object_id('tempdb..#original') is not null drop table #original; 

-- original SLA prior to 7/1/2019
select unit_id, sla_code, season_id
	, case when tbl_ref_unit.unit_commiss >= '2014-01-01' then cast(tbl_ref_unit.unit_commiss as date)
		else cast('2014-01-01' as date) end as effective_start
	, 'Original Review' change_request_justification
into #original
from sladb.dbo.tbl_ref_unit
left join ipmdb.dbo.tbl_sla_export on unit_id = obj_code 
left join sladb.dbo.vw_sla_code_pivot on obj_udfchar02 = in_season_sla and obj_udfchar02 = off_season_sla 
left join sladb.dbo.tbl_sla_season on year_round = 1 and in_season_sla = off_season_sla 
where obj_udfchar02 in ('A', 'B', 'C', 'N')

if object_id('tempdb..#seasonal') is not null drop table #seasonal; 

-- units that changed to seasonal effective 7/1/2019
select unit_id, sla_code, season_id, effective_start, justification change_request_justification
into #seasonal
from ipmdb.dbo.tbl_sla_seasonal_export 
left join sladb.dbo.vw_sla_code_pivot on in_sla = in_season_sla and off_sla = off_season_sla 
left join sladb.dbo.tbl_sla_season on lower(season_desc) like '%'+lower(season)+'%' 
	and (('2019-07-01' between effective_start and effective_end) or ('2019-07-01' >= effective_start and effective_end is null))

if object_id('tempdb..#amps_updates') is not null drop table #amps_updates; 

-- units that changed sla since the original review but are not captured in seasonal changes above
select tbl_ref_unit.unit_id, vw_sla_code_pivot.sla_code, tbl_sla_season.season_id
	, case when tbl_ref_unit.unit_commiss >= '2019-07-01' then cast(tbl_ref_unit.unit_commiss as date)
		else cast('2019-07-01' as date) end as effective_start
	, 'AMPS updates since original review' change_request_justification
into #amps_updates
from sladb.dbo.tbl_ref_unit
left join #original on tbl_ref_unit.unit_id = #original.unit_id
left join [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects on tbl_ref_unit.unit_id = obj_code collate SQL_Latin1_General_CP1_CI_AS
left join sladb.dbo.vw_sla_code_pivot on coalesce(obj_udfchar02,'N') collate SQL_Latin1_General_CP1_CI_AS = in_season_sla and coalesce(obj_udfchar02,'N') collate SQL_Latin1_General_CP1_CI_AS = off_season_sla 
left join sladb.dbo.tbl_sla_season on year_round = 1 and in_season_sla = off_season_sla 
where tbl_ref_unit.unit_id not in (select unit_id from #seasonal) 
	and (#original.sla_code != vw_sla_code_pivot.sla_code or obj_udfchar02 is null)

if object_id('tempdb..#all_updates') is not null drop table #all_updates; 

-- combine each of the above tables to write to sladb
select *, rank() over(partition by unit_id order by effective_start) dtrk
into #all_updates
from (
select *
from #original
union
select *
from #seasonal
union
select *
from #amps_updates
) all_updates

begin transaction
insert into sladb.dbo.tbl_change_request (unit_id, sla_code, season_id, effective_start, change_request_justification)
select unit_id, sla_code, season_id, effective_start, change_request_justification
from #all_updates
where dtrk = 1
commit;

begin transaction 
insert into sladb.dbo.tbl_change_request_status (change_request_id, sla_change_status, status_user)
select change_request_id, 2 as sla_change_status, '1552495' status_user
from sladb.dbo.tbl_change_request_status
where sla_change_status = 1
commit;

-- need to get the row id for the last record to filter on later
declare @i int = (select ident_current('sladb.dbo.tbl_change_request_status'));

begin transaction
insert into sladb.dbo.tbl_change_request (unit_id, sla_code, season_id, effective_start, change_request_justification)
select unit_id, sla_code, season_id, effective_start, change_request_justification
from #all_updates
where dtrk > 1
commit;

begin transaction 
insert into sladb.dbo.tbl_change_request_status (change_request_id, sla_change_status, status_user)
select change_request_id, 2 as sla_change_status, '1552495' status_user
from sladb.dbo.tbl_change_request_status
where change_request_status_id > @i
commit;

--truncate table sladb.dbo.tbl_change_request_status
--delete from sladb.dbo.tbl_change_request
--truncate table sladb.dbo.tbl_change_request
--DBCC CHECKIDENT ('sladb.dbo.tbl_change_request', RESEED, 1)