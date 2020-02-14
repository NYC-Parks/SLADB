/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  01/29/2020																							   
 Modified Date: 02/12/2020																							   
											       																	   
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

create or alter trigger dbo.trg_i_tbl_unit_sla_season
on sladb.dbo.tbl_unit_sla_season
for insert as
	begin
		/*Try the insert*/
		begin try
			/*Since the new record already would have been inserted by the insert on the tbl_change_request status table, find existing effective record for that unit
			  and set the effective value to 0 and the effective_date to today.*/
			begin transaction;
				update sladb.dbo.tbl_unit_sla_season
				set effective = 0,
					effective_end = cast(getdate() as date)
				from inserted as l
				inner join
					 (select unit_id, 
							 sla_season_id,
							 /*Rank the effective records for the inserted unit(s)*/
							 dense_rank() over(partition by unit_id order by unit_id, effective_start desc) as nrank
					  from sladb.dbo.tbl_unit_sla_season
					  where effective = 1) as r
				on l.unit_id = r.unit_id
				where sladb.dbo.tbl_unit_sla_season.sla_season_id = r.sla_season_id and 
					  nrank = 2;
			commit;
		end try

		/*Catch any errors and if applicable, rollback the above transaction.*/
		begin catch
			rollback transaction;
		end catch
	end;