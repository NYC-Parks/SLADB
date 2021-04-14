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
			left join
				sladb.dbo.tbl_sla_season as r
			on u.season_id = r.season_id
			left join
				sladb.dbo.vw_sla_code_pivot as r2
			on u.sla_code = r2.sla_code
			left join
				sladb.dbo.tbl_ref_unit as r3
			on u.unit_id = r3.unit_id
				  /*Invalidate seasons/slas with mismatches in year round status.*/
			where u.effective_start_adj > = cast(getdate() as date) and 
				  (r.year_round != r2.year_round or
				   /*Invalidate records for seasons where the season is no longer effective*/
				   (r.effective = 0 and r.effective_end is not null) or
				   (r.effective = 0) or
				   /*Invalidate records where the effective_start_adj of the change request is greater than or equal to the effective_end_adj 
				   of the season.*/
				   (u.effective_start_adj >= r.effective_end_adj))
		commit;
	end;