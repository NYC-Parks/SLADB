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
--drop table sladb.dbo.tbl_ref_sla_season_definition
create table sladb.dbo.tbl_ref_sla_season_definition(season_date_ref_id int identity(1,1) primary key,
													 season_id int foreign key references sladb.dbo.tbl_sla_season(season_id),
													 season_date_ref_fixed bit not null,
													 season_date_month_name_desc nvarchar(9) not null foreign key references sladb.dbo.tbl_ref_sla_season_month_name(season_month_name_desc),
													 season_date_ref_day_number int null,
													 season_date_day_name_desc nvarchar(9) null foreign key references sladb.dbo.tbl_ref_sla_season_day_name(season_day_name_desc),
													 season_day_rank_id nvarchar(5) null foreign key references sladb.dbo.tbl_ref_sla_season_day_rank(season_day_rank_id),
													 season_date_type_id int foreign key references sladb.dbo.tbl_ref_sla_season_date_type(season_date_type_id));


insert into sladb.dbo.tbl_ref_sla_season(season_desc, season_fixed, season_month_name, season_day_number, season_active)
	values('Field and Court Season', 1, 'April', 15, 1),
		  ('Playgrounds and Pools'),
		  ('Year Round');

insert into sladb.dbo.tbl_ref_sla_season(season_desc, season_fixed, season_month_name, season_day_name, season_day_rank, season_active)
	values('Beach Season', 0, 'May', 'Sunday', '2', 1)

