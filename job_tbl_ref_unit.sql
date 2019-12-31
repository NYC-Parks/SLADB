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
exec dbo.sp_delete_job  
    @job_name = N'job_tbl_ref_sector_district'
	--@job_id = '4D44FECB-7EFB-4B3C-9480-BF7E5CD5EB0D'
go */

/*use msdb ;  
go  
exec dbo.sp_add_schedule  
    @schedule_name = N'Once_Daily_0820',  
    @freq_type = 4,  
	@freq_interval = 1,
    @active_start_time = 082000 ;  
go*/

use msdb ;  
go  

declare @job_id uniqueidentifier;

/*Create the job*/
exec dbo.sp_add_job @job_name = N'job_tbl_ref_unit', 
					@enabled = 1,
					@description = N'Update the reference table for SLADB units.',
					@owner_login_name = 'NYCDPR\py_services',
					@job_id = @job_id output;

exec sp_add_jobserver  
   @job_id = @job_id,  
   @server_name = N'(LOCAL)';  


exec dbo.sp_add_jobstep  
    @job_id = @job_id,  
    @step_name = N'sp_merge_ref_unit',  
    @subsystem = N'TSQL',  
    @command = N'exec sladb.dbo.sp_merge_ref_unit',
	@on_success_action = 1,
	@on_fail_action = 2;/*,   
    @retry_attempts = 5,  
    @retry_interval = 5 ;  */
 
 
exec sp_attach_schedule  
   @job_id = @job_id,  
   @schedule_name = N'Once_Daily_0820';  
