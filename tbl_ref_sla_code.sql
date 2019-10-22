/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  10/22/2019																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla_translation																							   			
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_ref_sla_code(sla_code int primary key)

insert into sladb.dbo.tbl_ref_sla_code(sla_code)
	select distinct sla_code
	from sladb.dbo.tbl_ref_sla_translation
/*select l.sla_code,
	   l.sla_id,
	   r.sla_id
from (select sla_code,
			 sla_id,
			 season_category_id
	  from sladb.dbo.tbl_ref_sla_translation
	  where season_category_id = 1) as l
left join
	 (select sla_code,
			 sla_id,
			 season_category_id
	  from sladb.dbo.tbl_ref_sla_translation
	  where season_category_id = 2) as r
on l.sla_code = r.sla_code*/