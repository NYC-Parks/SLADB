/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  08/19/2019																							   
 Modified Date: 02/25/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla																							   			
			  																				   
 Description: Create a translation table for SLAs that includes the in season and out of season SLAs. 									   
																													   												
***********************************************************************************************************************/
set ansi_nulls on;
go

set quoted_identifier on;
go

create table sladb.dbo.tbl_ref_sla_translation(sla_trans_id int identity(1,1) primary key,				   
											   sla_id nvarchar(1) not null foreign key references sladb.dbo.tbl_ref_sla(sla_id),
											   date_category_id int not null foreign key references sladb.dbo.tbl_ref_sla_season_category(date_category_id),
											   --sla_code as ceiling(sla_trans_id/2) persisted--,
											   sla_code int not null foreign key references sladb.dbo.tbl_ref_sla_code(sla_code),
											   /*Create a unique constraint to make sure that each sla and season only appear once per combination.*/
											   constraint unq_sla_code unique (sla_id, date_category_id, sla_code));
--truncate table sladb.dbo.tbl_ref_sla_translation