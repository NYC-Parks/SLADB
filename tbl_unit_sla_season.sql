/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  09/26/2019																							   
 Modified Date: 03/02/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_unit_sla_season(sla_season_id int identity(1,1) primary key,
										   unit_id nvarchar(30) foreign key references sladb.dbo.tbl_ref_unit(unit_id) on update cascade not null,
										   /*Require an not null constraint because this should never be null!*/
										   sla_code int foreign key references sladb.dbo.tbl_ref_sla_code(sla_code) not null, 
										   season_id int foreign key references sladb.dbo.tbl_sla_season(season_id) not null,
										   effective bit not null,
										   effective_start_adj date not null,
										   effective_end_adj date,
										   change_request_id int foreign key references sladb.dbo.tbl_change_request(change_request_id) on delete cascade,
										   created_date_utc datetime default getutcdate(),
										   updated_date_utc datetime,
										   /*Create a unique constraint to prevent duplicate entries for the same unit, sla, season and effective from date this table*/
										   constraint unq_unitslaseason unique(unit_id, sla_code, season_id, effective_start_adj),
										   /*Make sure that the effective_end date is always greater than the effective_start date*/
										   constraint ck_unit_effective_dates check (effective_end_adj > effective_start_adj));

