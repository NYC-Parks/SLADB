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
use sladb
go

delete from sladb.dbo.tbl_sla_season
DBCC CHECKIDENT('tbl_ref_sla_season_definition', RESEED, 1)  
go

truncate table sladb.dbo.tbl_ref_sla_season_definition

DBCC CHECKIDENT('dbo.tbl_sla_season', RESEED, 1)  
go

/*
DBCC CHECKIDENT('dbo.tbl_sla_season')  
go*/

insert into sladb.dbo.tbl_sla_season(season_desc, season_active, season_year_round)
	values('Year Round Test', 1, 1),
		  ('Another Year Round Test', 1, 1)

select *
from sladb.dbo.tbl_sla_season

select *
from sladb.dbo.tbl_ref_sla_season_definition