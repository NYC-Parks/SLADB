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
		select l.*,
			   case when r.sla_change_status = 1 then 1
					else 0
			   end as submitted_exist
		into #inserts
		from inserted as l
		left join
			 sladb.dbo.tbl_change_request as r
		on l.unit_id = r.unit_id
		where r.sla_change_status = 1;


		begin transaction
			insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start,
													 change_request_justification, effective_start_adj, sla_change_status)
			select unit_id,
				   sla_code,
				   season_id,
				   effective_start,
				   change_request_justification,
				   dbo.fn_getdate(effective_start, 1) as effective_start_adj,
				   sla_change_status
			from #inserts
			/*Exclude any records that already have a change request submitted*/
			where submitted_exist = 0;
		commit;

		if exists(select * from #inserts where submitted_exist = 1)
			raiserror('Warning, an existing change request has already been submitted for this unit and has not been approved.', 1, 1)
	end;


	 