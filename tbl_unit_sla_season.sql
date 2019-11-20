/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  09/26/2019																							   
 Modified Date: 11/20/2019																							   
											       																	   
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
										   unit_id nvarchar(30) foreign key references sladb.dbo.tbl_ref_unit(unit_id),
										   sla_code int foreign key references sladb.dbo.tbl_ref_sla_code(sla_code),
										   season_id int foreign key references sladb.dbo.tbl_sla_season(season_id),
										   effective bit not null,
										   effective_from date not null,
										   effective_to date
										   /*Create a unique constraint to prevent duplicate entries for the same unit, sla, season and effective from date this table*/
										   constraint unq_unitslaseason unique(unit_id, sla_code, season_id, effective_from));

