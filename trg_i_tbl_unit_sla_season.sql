/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  01/29/2020																							   
 Modified Date: 03/03/2020																							   
											       																	   
 Project: SLADB	
 																							   
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

create or alter trigger dbo.trg_i_tbl_unit_sla_season
on sladb.dbo.tbl_unit_sla_season
after insert as
	begin
		/*Since the new record already would have been inserted by the insert on the tbl_change_request status table, find existing effective record for that unit
			and set the effective value to 0 and the effective_date to today.*/
		begin transaction;
			update r
			set effective = 0,
				effective_end = cast(getdate() as date)
			from inserted as l
			inner join
					sladb.dbo.tbl_unit_sla_season as r
			on l.unit_id = r.unit_id
			inner join
					sladb.dbo.vw_tbl_unit_sla_season_last_id as r2
			on r.unit_id = r2.unit_id and
				r.sla_season_id = r2.sla_season_id
			where r2.row_rank = r2.n and
					r2.n > 1;
		commit;

	end;