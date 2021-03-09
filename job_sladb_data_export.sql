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
use msdb ;  
go  

/*If the job already exists, delete it.*/
if exists(select * from msdb.dbo.sysjobs where name = 'job_sladb_data_export')
	begin	
		exec sp_delete_job @job_name = N'job_sladb_data_export';  
	end;
go


/*If the schedule doesn't exist, create it.*/
if not exists(select * from msdb.dbo.sysschedules where name = 'Once_Daily_0012')
	begin	
		exec dbo.sp_add_schedule  
			@schedule_name = N'Once_Daily_0012',  
			@freq_type = 4,  
			@freq_interval = 1,
			@active_start_time = 001200 ;  
	end;
go

/*Create a parameter to store the job_id*/
declare @job_id uniqueidentifier;
declare @owner sysname;
exec master.dbo.sp_sql_owner @file_path = 'D:\Projects', @result = @owner output;

/*Create the job*/
exec dbo.sp_add_job @job_name = N'job_sladb_data_export', 
					@enabled = 1,
					@description = N'Execute batch scripts to export data from SLADB',
					@owner_login_name = @owner,
					@job_id = @job_id output;

exec dbo.sp_add_jobserver  
   @job_id = @job_id,  
   @server_name = N'(LOCAL)';  

/*Call the batch script to export the change request table*/
exec dbo.sp_add_jobstep  
    @job_id = @job_id,  
    @step_name = N'CMD_export_tbl_change_request',  
    @subsystem = N'CmdExec',  
    @command = N'cmd.exe /c "D:\Projects\SLADB_Data\export_vw_change_request_export.bat"',
	@on_success_action = 3,
	@on_fail_action = 3;

/*Call the batch script to export the change request status table*/
exec dbo.sp_add_jobstep  
    @job_id = @job_id,  
    @step_name = N'CMD_export_tbl_change_request_status',  
    @subsystem = N'CmdExec',  
    @command = N'cmd.exe /c "D:\Projects\SLADB_Data\export_vw_change_request_status_export.bat"',
	@on_success_action = 1,
	@on_fail_action = 2;

exec dbo.sp_attach_schedule  
   @job_id = @job_id,  
   @schedule_name = N'Once_Daily_0012';  
