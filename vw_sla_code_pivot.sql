/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  02/26/2020																							   
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
create or alter view dbo.vw_sla_code_pivot as

	select l.sla_code,
			l.sla_id as in_season_sla,
			r.sla_id as off_season_sla
	from (select sla_id,
					sla_code
			from sladb.dbo.tbl_ref_sla_translation
			where date_category_id = 1) as l
	left join
			(select sla_id,
					sla_code
			from sladb.dbo.tbl_ref_sla_translation
			where date_category_id = 2) as r
	on l.sla_code = r.sla_code;