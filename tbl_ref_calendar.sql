/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  09/06/2019																							   
 Modified Date: 10/24/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Create the table that will hold the calendar reference values.  									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_ref_calendar(ref_date date primary key,
										month_name_desc nvarchar(9) foreign key references sladb.dbo.tbl_ref_sla_season_month_name(month_name_desc),
										day_name_desc nvarchar(9) foreign key references sladb.dbo.tbl_ref_sla_season_day_name(day_name_desc),
										day_rank_id nvarchar(5) foreign key references sladb.dbo.tbl_ref_sla_season_day_rank(day_rank_id));

