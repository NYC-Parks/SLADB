/****** Script for SelectTopNRows command from SSMS  ******/
begin transaction;
with updates as(
select l.sla_season_id
from sladb.dbo.tbl_unit_sla_season as l
right join
	 (select *
	  from sladb.dbo.tbl_change_request
	  where effective_start = '2020-03-22') as r
on l.unit_id = r.unit_id
where l.effective_end = '2020-07-01' and
	  l.season_id != 4)

update l
	set effective_end = '2020-03-21'
	from sladb.dbo.tbl_unit_sla_season as l
	inner join
		 updates as r
	on l.sla_season_id = r.sla_season_id;

commit;

begin transaction;
with updates as(
select l.sla_season_id
from sladb.dbo.tbl_unit_sla_season as l
right join
	 (select *
	  from sladb.dbo.tbl_change_request
	  where effective_start = '2020-04-05') as r
on l.unit_id = r.unit_id
where l.effective_end = '2020-07-01' and
	  l.season_id != 4)

update l
	set effective_end = '2020-04-04'
	from sladb.dbo.tbl_unit_sla_season as l
	inner join
		 updates as r
	on l.sla_season_id = r.sla_season_id;

commit;