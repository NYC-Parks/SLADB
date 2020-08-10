/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  01/24/2020																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
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

create or alter procedure dbo.sp_u_tbl_sla_season as
	begin
		/*If a season has reached it's effective_end date and effective = 1 then set the value of effective = 0
		  and set the updated_date_utc.*/
		begin transaction
			update sladb.dbo.tbl_sla_season
				/*set the effective value equal to 0 if it's equal to or past the effective_end_adj date,
				  otherwise set the effective value equal to 1.*/
				set effective = case when effective_end_adj <= cast(getdate() as date) then 0
									 else 1
								end,
				    updated_date_utc = getutcdate()
					  /*Find any currently effective seasons (effective = 1) that should be effective = 0 if the 
						effective_end_adj date is less than or equal to today*/
				where (effective = 1 and 
					   effective_end_adj <= cast(getdate() as date)) or 
					  /*Find any currently ineffective seasons (effective = 0) that should be effective = 1 if the 
					    effective_start_adj date is less than or equal to today*/
					  (effective = 0 and 
					   effective_start_adj <= cast(getdate() as date) and 
					   effective_end_adj is null);
		commit;

		begin transaction
			update sladb.dbo.tbl_unit_sla_season
			set effective = 0,
				effective_end = s.effective_end 
				/*Extract the records where the season is not effective*/
			from (select *
			      from sladb.dbo.tbl_sla_season
				  where effective = 0) as s
			/*Perform an inner join based on season to find records that have seasons with a value of effective = 0 and unit records
			  assigned this season with a value effective = 0*/
			inner join
				  sladb.dbo.tbl_unit_sla_season as u
			on s.season_id = u.season_id and 
			   u.effective = 1;
		commit;
	end;
