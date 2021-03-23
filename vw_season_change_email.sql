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

create or alter view dbo.vw_season_change_email as
		select l.date_category_id, 
			   r.season_desc, 
			   l.effective_start_adj, 
			   r2.unit_id, 
			   r3.unit_desc, 
			   r3.unit_mrc as district,
			   r6.sector,
			   r4.sla_id as current_sla,
			   r5.sla_id as upcoming_sla
		from sladb.dbo.tbl_sla_season_date as l
		left join
			 sladb.dbo.tbl_sla_season as r
		on l.season_id = r.season_id
		left join
			 sladb.dbo.tbl_unit_sla_season as r2
		on l.season_id = r2.season_id
		left join
			 sladb.dbo.tbl_ref_unit as r3
		on r2.unit_id = r3.unit_id
		left join
			sladb.dbo.tbl_ref_sla_translation as r4
		on r2.sla_code = r4.sla_code and
		   l.date_category_id != r4.date_category_id
		left join
			sladb.dbo.tbl_ref_sla_translation as r5
		on r2.sla_code = r5.sla_code and
		   l.date_category_id = r5.date_category_id
		left join
			(select *
			 from [appdb].dailytasks_dev.dbo.ref_sector_districts
			 where active = 1 and 
				   lower(sector) not like '%all' and
				   /*Exclude these two sectors to prevent duplication*/
				   lower(sector) not in('q-swfd', 'r-sob')) as r6
		on r3.unit_mrc = r6.district
		where --datediff(day, cast(getdate() as date), l.effective_start_adj) = 14 and
			  datediff(week, cast(getdate() as date), l.effective_start_adj) = 6 and
			  r2.effective = 1;