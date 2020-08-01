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
exec sladb.dbo.sp_i_tbl_unit_sla_season

select *
from sladb.dbo.tbl_unit_sla_season
where season_id = 1

begin transaction
	insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective, effective_start)
		select season_desc, year_round, 1 as effective, effective_start = '2020-07-26'
		from sladb.dbo.tbl_sla_season
		where season_id = 2
commit;

begin transaction
	insert sladb.dbo.tbl_sla_season_change(old_season_id, new_season_id)
		values(2, 10)
commit;


select *
from sladb.dbo.tbl_change_request_status
where sla_change_status = 4

