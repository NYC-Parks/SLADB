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
create table sladb.dbo.tbl_ref_sla_season_month_name(season_month_name_num int not null unique,
													 season_month_name_desc nvarchar(9) primary key);

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_month_name(season_month_name_num, season_month_name_desc)
		values(1, 'January'),
			  (2, 'February'),
			  (3, 'March'),
			  (4, 'April'),
			  (5, 'May'),
			  (6, 'June'),
			  (7, 'July'),
			  (8, 'August'),
			  (9, 'September'),
			  (10, 'October'),
			  (11, 'November'),
			  (12, 'December')
commit;