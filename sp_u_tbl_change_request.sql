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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter procedure dbo.sp_u_tbl_change_request as 
	begin
		begin transaction
			update u
			/*Set the sla_change_status value to 4 = Invalid if certain conditions are met.*/
			set u.sla_change_status = 4
			from (select *
				  from sladb.dbo.tbl_change_request
				  /*Filter out any change requests that have already been invalidated*/
				  where sla_change_status != 4) as u
			inner join
				 (select change_request_id,
						 max(created_date_utc) as max_created_date_utc
				  from sladb.dbo.tbl_change_request_status
				  group by change_request_id) as s
		    on u.change_request_id = s.change_request_id
			left join
				sladb.dbo.tbl_sla_season as s2
			on u.season_id = s2.season_id
			left join
				sladb.dbo.vw_sla_code_pivot as s3
			on u.sla_code = s3.sla_code
			left join
				sladb.dbo.tbl_ref_unit as s4
			on u.unit_id = s4.unit_id
				  /*Invalidate seasons/slas with mismatches in year round status.*/
			where (u.effective_start_adj >= cast(getdate() as date) or
				   /*In certain rare cases, records may be retroactively added and the invalidation script\
				     is still required to run, so use the utc timestamp.*/
			       cast(s.max_created_date_utc as date) = cast(getutcdate() as date)) and 
				  (s2.year_round != s3.year_round or
				   /*Invalidate records for seasons where the season is no longer effective*/
				   (s2.effective = 0) or
				   /*Invalidate records where the effective_start_adj of the change request is greater than or equal to the effective_end_adj 
				   of the season.*/
				   (u.effective_start_adj >= s2.effective_end_adj) or
				   /*Invalidate any record where the unit_status becomes D or decommissioned*/
				   s4.unit_status = 'D') 
		commit;
	end;