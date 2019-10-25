/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  08/19/2019																							   
 Modified Date: 10/15/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla																							   			
			  																				   
 Description: Create a translation table for SLAs that includes the in season and out of season SLAs. 									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_ref_sla_translation(sla_trans_id int identity(1,1) primary key,				   
											   sla_id nvarchar(1) foreign key references sladb.dbo.tbl_ref_sla(sla_id),
											   date_category_id int foreign key references sladb.dbo.tbl_ref_sla_season_category(date_category_id),
											   sla_code int not null,
											   /*Create a unique constraint to make sure that each sla and season only appear once per combination.*/
											   constraint unq_sla_code unique (sla_id, date_category_id, sla_code));


declare @sla_tab table(sla_id nvarchar(1),
					   date_category_id int,
					   sla_translation_id int,
					   row_id int identity(1,1));

insert into @sla_tab(sla_id, date_category_id)
	select sla_id, date_category_id
	from sladb.dbo.tbl_ref_sla
	cross join
		 sladb.dbo.tbl_ref_sla_season_category;

with combos as(
select l.*, 
	   r.sla_id as sla_id2,
	   row_number() over(partition by l.date_category_id order by l.date_category_id, l.sla_id) as sla_code
from @sla_tab as l
cross join
	 @sla_tab as r
where l.date_category_id != r.date_category_id)

insert into sladb.dbo.tbl_ref_sla_translation(sla_id,
											  date_category_id,
											  sla_code)
	select case when date_category_id = 1 then sla_id
			else sla_id2
		end as sla_id,
	   date_category_id,
	   sla_code
from combos

--truncate table sladb.dbo.tbl_ref_sla_translation