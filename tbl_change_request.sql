/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/06/2019																							   
 Modified Date: 02/27/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_change_request(change_request_id int identity(1,1) primary key,
										  unit_id nvarchar(30) not null foreign key references sladb.dbo.tbl_ref_unit(unit_id),
										  sla_code int not null foreign key references sladb.dbo.tbl_ref_sla_code(sla_code),
										  season_id int not null foreign key references sladb.dbo.tbl_sla_season(season_id),
										  /*Make sure that the effective start date is greater than or equal to today's date.*/
										  effective_start date not null,
										  effective_start_adj date null,
										  change_request_justification nvarchar(2000) not null,
										  change_request_comments nvarchar(2000) null,
										  /*Add the a status column with a default value of 1 (submitted)*/
										  sla_change_status int not null foreign key references sladb.dbo.tbl_ref_sla_change_status(sla_change_status) default 1,
										  constraint ck_change_request_effective_start check (effective_start >= cast(getdate() as date)),
										  constraint unq_change_request unique(unit_id, effective_start_adj, sla_change_status));
