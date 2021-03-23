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

create or alter procedure dbo.sp_season_change_email as
	begin
	if (select count(*) from sladb.dbo.vw_season_change_email) >= 1
		begin
			declare @xml nvarchar(max) = cast((select unit_id as 'td', '', unit_desc as 'td', '', unit_mrc as 'td', '', current_sla as 'td', '', upcoming_sla as 'td' 
											   from sladb.dbo.vw_season_change_email
											   for xml path('tr'), elements) as nvarchar(max));


			declare @effective_start_adj nvarchar(10) = (select distinct cast(format(effective_start_adj, 'MM/dd/yyyy') as nvarchar(10)) from sladb.dbo.vw_season_change_email);
			declare @season_desc nvarchar(128) = (select distinct season_desc from sladb.dbo.vw_season_change_email);


			declare @body nvarchar(max) = '<html>
												<body>' +
												'Hello,
												<br>
												Please note that the following properties in [borough x] will an undergo an SLA change for ' + @season_desc + '  starting on' + @effective_start_adj + '.' +
												'<br>
														<table border = 1>
															<tr><th align = "left"> Site </th><th align = "left"> Site Description </th><th align = "left"> District </th><th align = "left"> Current SLA </th><th align = "left"> Upcoming SLA </th></tr>'
															+ @xml +
														'</table>
												<br>
												Thank you,
												<br>
												Daily Task Helpdesk
												</body>
											</html>'

			--declare @body nvarchar(5000);
			exec msdb.dbo.sp_send_dbmail @profile_name = 'SLADB_Email', 
										 @recipients = 'daniel.gallagher@parks.nyc.gov; sara.esquibel@parks.nyc.gov; dennis.rim@parks.nyc.gov; scott.davenport@parks.nyc.gov', 
										 @subject = 'Reminder | SLA Season Changes in 2 Weeks', 
										 @body = @body,
										 @body_format = 'HTML'
		end;
	end;