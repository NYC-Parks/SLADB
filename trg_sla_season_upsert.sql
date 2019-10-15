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
--drop trigger dbo.trg_sla_season_upsert
create trigger dbo.trg_sla_season_upsert
on sladb.dbo.tbl_change_request_status 
after insert as

	begin transaction;
		with inserts as(
		select unit_id, sla_code, season_id, status_date 
		from inserted as l
		left join
			 sladb.dbo.tbl_change_request as r
		on l.change_request_id = r.change_request_id
		where l.sla_change_status = 2)
	

		merge sladb.dbo.tbl_unit_sla_season as tgt using inserts as src
			on (tgt.unit_id = src.unit_id)
			when matched and effective = 1 and effective_to is null
				then update set tgt.effective = 0,
						        tgt.effective_to = (select sladb.dbo.fn_getdate(cast(getdate() as date), 0))
			when not matched by target
				then insert(unit_id, sla_code, season_id, effective, effective_from)
						values(unit_id, sla_code, season_id, 1, sladb.dbo.fn_getdate(status_date, 1)); 
	commit;