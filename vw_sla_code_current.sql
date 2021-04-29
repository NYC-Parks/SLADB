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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter view dbo.vw_sla_code_current as 
	select l.unit_id,
		   r.season_desc,
		   r2.in_season_sla,
		   r2.off_season_sla,
		   l.effective_start_adj,
		   left(r3.unit_mrc, 1) as borough,
		   r3.unit_mrc as district
	from sladb.dbo.tbl_unit_sla_season as l
	left join
			sladb.dbo.tbl_sla_season as r
	on l.season_id = r.season_id
	left join
			sladb.dbo.vw_sla_code_pivot as r2
	on l.sla_code = r2.sla_code
	left join
			sladb.dbo.tbl_ref_unit as r3
	on l.unit_id = r3.unit_id
	where l.effective = 1