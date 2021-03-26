/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																					   			          
 Created Date:  09/27/2019																							   
 Modified Date: 01/29/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_change_request																							   
 			  sladb.dbo.tbl_change_request_status																								   
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

create or alter trigger dbo.trg_ii_tbl_change_request
on sladb.dbo.tbl_change_request
instead of insert as 
	begin
		
		if object_id('tempdb..#inserts') is not null
			drop table #inserts;
		
		/*Join the inserted change requests with the existing change requests and determine if the unit_id referenced
		  by the new change requests already have existing change requests with a status of 1 or submitted. Ideally
		  any existing change must be dealt with first.*/
		select distinct l.*,
							/*If a change request with status 1:submitted exists, then flag it*/
						case when r.sla_change_status = 1 then 1
							/*If a change request with status 2:approved exists and it has the same effective_start_adj date then flag it*/
							 when r.sla_change_status = 2 and r.effective_start_adj = l.effective_start_adj then 1
							 /*Otherwise don't flag the record*/
							 else 0
						end as submitted_exist
		into #inserts
		from inserted as l
		left join
			 sladb.dbo.tbl_change_request as r
		on l.unit_id = r.unit_id;

		/*If records exist with flag, then generate an error*/
		if exists(select * from #inserts where submitted_exist = 1)
			raiserror('Warning, an existing change request has already been submitted for this unit and has not yet been approved.', 14, 1)
		
		/*If there is no error, then complete the insert*/
		if @@error = 0
			begin
				begin transaction
					insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start,
															 change_request_justification, effective_start_adj, sla_change_status, edited_user)
					select unit_id,
						   sla_code,
						   season_id,
						   effective_start,
						   change_request_justification,
						   dbo.fn_getdate(effective_start, 1) as effective_start_adj,
						   sla_change_status,
						   edited_user
					from #inserts
					/*Exclude any records that already have a change request submitted*/
					where submitted_exist = 0;
				commit;
			end;

	end;


	 