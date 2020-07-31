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
/*use msdb ;  
go  
exec dbo.sp_add_schedule  
    @schedule_name = N'Once_Daily_0001',  
    @freq_type = 4,  
	@freq_interval = 1,
    @active_start_time = 000100 ;  
go*/

use msdb ;  
go  

declare @job_id uniqueidentifier;

/*Create the job*/
exec dbo.sp_add_job @job_name = N'job_sladb', 
					@enabled = 1,
					@description = N'Execute stored procedures for SLADB',
					@owner_login_name = 'NYCDPR\py_services',
					@job_id = @job_id output;

exec dbo.sp_add_jobserver  
   @job_id = @job_id,  
   @server_name = N'(LOCAL)';  

/*Insert the new records into the calendar reference table*/
exec dbo.sp_add_jobstep  
    @job_id = @job_id,  
    @step_name = N'sp_i_tbl_ref_calendar',  
    @subsystem = N'TSQL',  
    @command = N'exec sladb.dbo.sp_i_tbl_ref_calendar',
	@on_success_action = 1,
	@on_fail_action = 3;

/*Do the merge with the units reference table*/
exec dbo.sp_add_jobstep  
	@job_id = @job_id,  
	@step_name = N'sp_m_tbl_ref_unit',  
	@subsystem = N'TSQL',  
	@command = N'exec sladb.dbo.sp_m_tbl_ref_unit',
	@on_success_action = 1,
	@on_fail_action = 3;

/*Update the season table based on any changes in the season change table*/
exec dbo.sp_add_jobstep  
	@job_id = @job_id,  
	@step_name = N'sp_i_tbl_sla_season_change',  
	@subsystem = N'TSQL',  
	@command = N'exec sladb.dbo.sp_i_tbl_sla_season_change',
	@on_success_action = 1,
	@on_fail_action = 3;

/*Update the season table to set seasons to effective or ineffective*/
exec dbo.sp_add_jobstep  
	@job_id = @job_id,  
	@step_name = N'sp_u_tbl_sla_season',  
	@subsystem = N'TSQL',  
	@command = N'exec sladb.dbo.sp_u_tbl_sla_season',
	@on_success_action = 1,
	@on_fail_action = 3;

/*Do the merge into the season dates table*/
exec dbo.sp_add_jobstep  
	@job_id = @job_id,  
	@step_name = N'sp_m_tbl_sla_season_date',  
	@subsystem = N'TSQL',  
	@command = N'exec sladb.dbo.sp_m_tbl_sla_season_date',
	@on_success_action = 1,
	@on_fail_action = 3;
	
/*Insert any new records into the unit, sla, season table that have been in holding*/
exec dbo.sp_add_jobstep  
	@job_id = @job_id,  
	@step_name = N'sp_i_tbl_unit_sla_season',  
	@subsystem = N'TSQL',  
	@command = N'exec sladb.dbo.sp_i_tbl_unit_sla_season',
	@on_success_action = 1,
	@on_fail_action = 3;

exec dbo.sp_attach_schedule  
   @job_id = @job_id,  
   @schedule_name = N'Once_Daily_0001';  
