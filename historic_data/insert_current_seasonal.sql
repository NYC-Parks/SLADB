/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  10/30/2019																							   
 Modified Date: 12/27/2019																						   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Insert the current season and sla values for units that have seasonal slas. Also insert the justifications
			  and the statuses.
																													   												
***********************************************************************************************************************/
/*Declare the variables used for iterating.*/
declare @i int, @n int;

/*Declare the variables used for inserting the records.*/
declare @unit_id nvarchar(30),
	    @sla_code int,
		@season_id int,
		@change_request_justification nvarchar(2000);
	
/*Check if the temporary table exists, if it does then drop it.*/
if object_id('tempdb..#seasons_final') is not null
	drop table #seasons_final;

/*Create the table for holding the values required for table inserts*/
create table #seasons_final(row_id int identity(1,1),
							unit_id nvarchar(30),
							season_id int,
							sla_code int,
							change_request_justification nvarchar(2000));

/*Join the SLA export with R5Objects to ensure the obj_code is valid*/
with seasonal as(
select unit_id,
		in_sla,
		off_sla,
		case when season = 'Beach' then 'Beaches, etc.'
			else 'Ballfields, etc.'
		end as season_desc,
		justification
from ipmdb.dbo.tbl_sla_seasonal_export as l
left join
	 [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects as r
on l.unit_id = r.obj_code collate SQL_Latin1_General_CP1_CI_AS)

/*Create a reference table for the in and off season SLAs and the corresponding SLA Codes*/
,slas as(
select l.sla_code,
		l.sla_id as in_sla,
		r.sla_id as off_sla
from (select sla_id,
				sla_code
		from sladb.dbo.tbl_ref_sla_translation
		where date_category_id = 1) as l
left join
		(select sla_id,
				sla_code
		from sladb.dbo.tbl_ref_sla_translation
		where date_category_id = 2) as r
on l.sla_code = r.sla_code)

/*Join the season with the seasonal SLA table so that the season_id can be extracted.*/
,seasons as(
select l.*, r.season_id
from seasonal as l
left join
		sladb.dbo.tbl_sla_season as r
on l.season_desc = r.season_desc)

/*Join the previous results set with the SLA reference table to assign the corrrect sla_id.*/
,seasons_final as(
select l.*, 
	   r.sla_code
from seasons as l
left join
		slas as r
on l.in_sla = r.in_sla and
   l.off_sla = r.off_sla)
	
insert into #seasons_final(unit_id,
							season_id,
							sla_code,
							change_request_justification)
	select unit_id,
			season_id,
			sla_code,
			justification
	from seasons_final
	/*Set the starting value of the iterator equal to 1 as to begin with the first row of data.*/
	set @i = 1;
	/*Set the ending value of the iterator equal to the total number of rows of data.*/
	set @n = (select count(*) from #seasons_final);


	while @i <= @n
		begin
			/*Set the insert values equal to the values of the corresponding row (i).*/
			set @unit_id = (select unit_id from #seasons_final where row_id = @i);
			set @sla_code = (select sla_code from #seasons_final where row_id = @i);
			set @season_id = (select season_id from #seasons_final where row_id = @i);
			set @change_request_justification = (select change_request_justification from #seasons_final where row_id = @i);

			/*Insert the change request justifications.*/
			exec sladb.dbo.sp_insert_change_request @unit_id = @unit_id,
													@sla_code = @sla_code,
													@season_id = @season_id,
													@change_request_justification = @change_request_justification;
			/*Add one to set the iterator equal to the next value.*/
			set @i = @i + 1;
		end;

begin transaction
	insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_date, status_user)
	select change_request_id,
		   2 as sla_change_status,
		   '2019-10-28' as status_date,
		   '1549482' status_user
	from sladb.dbo.tbl_change_request_status;
commit;

