/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  09/06/2019																							   
 Modified Date: 10/24/2019																						   
											       																	   
 Project: SLADB		
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_ref_sla_season_day_rank(day_rank_id nvarchar(5) primary key,
												   day_rank_desc nvarchar(128));

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_day_rank(day_rank_id, day_rank_desc)
		values('1', 'First {X}day of the month.'),
			  ('2', 'Second {X}day of the month.'),
			  ('3', 'Third {X}day of the month.'),
			  ('4', 'Fourth {X}day of the month.'),
			  ('last', 'Last {X}day of the month.')
commit;