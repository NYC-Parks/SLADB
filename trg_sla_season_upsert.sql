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
create trigger dbo.trg_sla_season_upsert
on sladb.dbo.tbl_change_request_status after update as


	begin transaction
		--insert into sladb.dbo.tbl_
		with updates(
		select unit_id, sla_code, season_id, status_date 
		from updated as l
		left join
			 sladb.dbo.tbl_change_request as r
		on l.change_request_id = r.change_request_id
		where l.sla_change_status = 2)
		
		merge sladb.dbo.tbl_unit_sla_season as target updates as source
			on target.unit_id = source.unit_id
			when target matched
				update 
			when target not matched
				insert(unit_id, sla_code, season_id, effective, effective_from, status_date)
				values(unit_id, sla_code, season_id, 1, status_date) 
	commit;

	merge 


	select unit_id, sla_code, season_id, status_date 
	from sladb.dbo.tbl_change_request_status as l
	left join
		 sladb.dbo.tbl_change_request as r
	on l.change_request_id = r.change_request_id
	where l.sla_change_status = 2
