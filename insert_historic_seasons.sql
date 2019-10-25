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
exec sladb.dbo.sp_insert_tbl_ref_calendar

exec sladb.dbo.sp_insert_season @season_desc = 'Year-round, not seasonal',
								@year_round = 1,
								@effective = 1,
								@date_ref_fixed = 1;

exec sladb.dbo.sp_season_dates @year = 2014
exec sladb.dbo.sp_season_dates @year = 2015
exec sladb.dbo.sp_season_dates @year = 2016
exec sladb.dbo.sp_season_dates @year = 2017
exec sladb.dbo.sp_season_dates @year = 2018
exec sladb.dbo.sp_season_dates @year = 2019

exec sladb.dbo.sp_insert_season @season_desc = 'Beaches, etc.',
								@year_round = 0,
								@effective = 1,
								@date_ref_fixed = 1,
								@month_name_desc = 'May',
								@date_ref_day_number = 1;								;

exec sladb.dbo.sp_insert_season @season_desc = 'Ballfields, etc.',
								@year_round = 1,
								@effective = 1,
								@date_ref_fixed = 1;

truncate table sladb.dbo.tbl_sla_season_date;

exec sladb.dbo.sp_season_dates @year = 2014
exec sladb.dbo.sp_season_dates @year = 2015
exec sladb.dbo.sp_season_dates @year = 2016
exec sladb.dbo.sp_season_dates @year = 2017
exec sladb.dbo.sp_season_dates @year = 2018
exec sladb.dbo.sp_season_dates @year = 2019
