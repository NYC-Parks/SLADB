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
with dev as(
SELECT [sla_season_id]
      ,[unit_id]
      ,[sla_code]
      ,[season_id]
      ,[effective]
      ,[effective_start_adj]
      ,[effective_end_adj]
      ,[change_request_id]
      ,[created_date_utc]
      ,[updated_date_utc]
	  ,hashbytes('SHA2_256', concat([unit_id],[sla_code],[season_id],[effective],[effective_start_adj],[effective_end_adj],[change_request_id])) as row_hash
  FROM [sladb].[dbo].[tbl_unit_sla_season])


select *
from (select [sla_season_id]
      ,[unit_id]
      ,[sla_code]
      ,[season_id]
      ,[effective]
      ,[effective_start_adj]
      ,[effective_end_adj]
      ,[change_request_id]
      ,[created_date_utc]
      ,[updated_date_utc]
	  ,hashbytes('SHA2_256', concat([unit_id],[sla_code],[season_id],[effective],[effective_start_adj],[effective_end_adj],[change_request_id])) as row_hash
	  from [dpr-vpipm001].sladb.dbo.tbl_unit_sla_season) as l
full outer join
	 dev as r
on l.unit_id = r.unit_id and
   l.effective_start_adj = r.effective_start_adj
where l.row_hash != r.row_hash