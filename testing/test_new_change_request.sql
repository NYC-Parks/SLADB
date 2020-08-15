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
/*Insert 4 records with new SLAs and seasons*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   1 as sla_code,
		   6 as season_id,
		   cast(getdate() as date) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.vw_unit_sla_season_unassigned;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;

/*Insert 4 records for where the effective_start date is after the effective_end date of the season they are assigned*/
declare @new_change_request as insert_change_request;

insert into @new_change_request(unit_id,
								sla_code,
								season_id,
								/*Make sure that the effective start date is greater than or equal to today's date.*/
								effective_start,
								change_request_justification)
	select top 4 unit_id,
		   2 as sla_code,
		   12 as season_id,
		   dateadd(day, 2, cast(getdate() as date)) as effective_start,
		   'Testing inserting new records.' 
	from sladb.dbo.vw_unit_sla_season_unassigned;

exec sladb.dbo.sp_insert_change_request @new_change_request = @new_change_request, @auto_approve = 1;