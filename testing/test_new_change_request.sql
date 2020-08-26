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
/*Insert 4 records with new SLAs and seasons*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   1 as sla_code,
		   6 as season_id,
		   cast(getdate() as date) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.vw_unit_sla_season_unassigned;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Insert 4 records for where the effective_start date is after the effective_end date of the season they are assigned*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   12 as season_id,
		   dateadd(day, 2, cast(getdate() as date)) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.vw_unit_sla_season_unassigned;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Change the SLA/Season of 4 existing units with seasonal slas for year round seasons*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   6 as season_id,
		   dateadd(day, 2, cast(getdate() as date)) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.tbl_unit_sla_season
	where effective = 1;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Insert 4 records for where the effective_start date is after the effective_start date of a season with a current value on 8-14-2020
  effective = 0*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   14 as season_id,
		   dateadd(day, 2, cast(getdate() as date)) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.vw_unit_sla_season_unassigned;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Change the SLA/Season of 4 existing units*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   6 as sla_code,
		   6 as season_id,
		   dateadd(day, 2, cast(getdate() as date)) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.tbl_unit_sla_season
	where effective = 1;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Submit multiple change requests for the same unit with different effective_start dates*/
/*Disable the check constraint.*/
alter table sladb.dbo.tbl_change_request
	nocheck constraint ck_change_request_effective_start

declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	values('BZ410', 1, 6, '2020-08-11', 'Testing inserting new records.'),
		  ('BZ410', 6, 6, '2020-08-12', 'Testing inserting new records.'),
		  ('BZ410', 11, 6, '2020-08-13', 'Testing inserting new records.'),
		  ('BZ410', 16, 6, '2020-08-14', 'Testing inserting new records.')

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Enable the check constraint without checking records that were inserted since it was disabled.*/
alter table sladb.dbo.tbl_change_request
	check constraint ck_change_request_effective_start;

/*Submit multiple change requests for the same unit with different effective_start dates*/
/*Disable the check constraint.*/
alter table sladb.dbo.tbl_change_request
	nocheck constraint ck_change_request_effective_start

declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	values('BZ410', 1, 6, '2020-08-17', 'Testing inserting new records.')

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	values('BZ410', 6, 6, '2020-08-18', 'Testing inserting new records.')

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Enable the check constraint without checking records that were inserted since it was disabled.*/
alter table sladb.dbo.tbl_change_request
	check constraint ck_change_request_effective_start;

/*Add change requests for a periodic season*/
alter table sladb.dbo.tbl_change_request
	nocheck constraint ck_change_request_effective_start

declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select unit_id,
		   2 as sla_code,
		   14 as season_id,
		   '2020-08-23' as effective_start,
		   'Testing inserting new records.' as change_request_justification
	from sladb.dbo.vw_unit_sla_season_unassigned
	order by unit_id
	offset 5 rows
	fetch first 5 rows only;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select unit_id,
		   1 as sla_code,
		   20 as season_id,
		   '2020-08-09' as effective_start,
		   'Testing inserting new records.' as change_request_justification
	from sladb.dbo.vw_unit_sla_season_unassigned
	order by unit_id
	offset 5 rows
	fetch first 5 rows only;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;


declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select unit_id,
		   2 as sla_code,
		   21 as season_id,
		   '2020-08-09' as effective_start,
		   'Testing inserting new records.' as change_request_justification
	from sladb.dbo.vw_unit_sla_season_unassigned
	order by unit_id
	offset 10 rows
	fetch first 5 rows only;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;
/*Enable the check constraint without checking records that were inserted since it was disabled.*/
alter table sladb.dbo.tbl_change_request
	check constraint ck_change_request_effective_start;

/*Change the SLA/Season of 4 existing units with seasonal slas for year round seasons, issue #129*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   6 as season_id,
		   '2020-08-23' as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.tbl_unit_sla_season
	where effective = 1;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;


/*Change the SLA/Season of 4 existing units with seasonal slas for year round seasons, issue #129*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   6 as season_id,
		   '2020-08-24' as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.tbl_unit_sla_season
	where effective = 1;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Insert records for periodic slas*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   6 as season_id,
		   '2020-08-24' as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.tbl_unit_sla_season
	where effective = 1;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Test the workflow for a change request in which the unit will be decommissioned.*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	values('Q135-01', 1, 6, '2020-11-01', 'Test inserting change requests that will be invalidated when units are decommissioned.'),
		  ('RZ243', 1, 6, '2020-11-01', 'Test inserting change requests that will be invalidated when units are decommissioned.'),
		  ('X002-10', 1, 6, '2020-11-01', 'Test inserting change requests that will be invalidated when units are decommissioned.')

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;