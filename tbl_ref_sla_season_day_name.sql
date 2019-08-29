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
create table sladb.dbo.tbl_ref_sla_season_day_name(season_day_name_num int not null unique,
												   season_day_name_desc nvarchar(9) primary key,
												   season_day_name_ndays int not null);

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_day_name(season_day_name_num, season_day_name_desc, season_day_name_ndays)
		values(1, 'Sunday', 0),
			  (2, 'Monday', 6),
			  (3, 'Tuesday', 5),
			  (4, 'Wednesday', 4),
			  (5, 'Thursday', 3),
			  (6, 'Friday', 2),
			  (7, 'Saturday', 1)
commit;