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
create table sladb.dbo.tbl_ref_sla_calendar(sla_calndr_id int identity(1,1) primary key,
											sla_season int foreign key references sladb.dbo.tbl_ref_sla_season(sla_season),
											sla_calndr_month int,
											sla_calndr_day int,
										    sla_calndr_start date,
											sla_calndr_end date,
											sla_calndr_start_adj date,
											sla_calndr_end_adj date); 

insert into sladb.dbo.tbl_ref_sla_season(sla_season, sla_calndr_month, sla_calndr_day)
	values(1, '2019-05-15', '2019-10-31'),
		  (2, '2019-03-15', '2019-11-30'),
		  (3, '2019-04-15', '2019-08-15'),
		  (4, '2019-01-01', '2019-12-31');