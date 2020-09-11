/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  03/02/2020																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
set nocount on;

begin transaction
	insert into sladb.dbo.tbl_ref_sla_season_month_name(month_name_num, month_name_desc, month_max_days)
		values(1, 'January', 31),
			  (2, 'February', 28),
			  (3, 'March', 31),
			  (4, 'April', 30),
			  (5, 'May', 31),
			  (6, 'June', 30),
			  (7, 'July', 31),
			  (8, 'August', 31),
			  (9, 'September', 30),
			  (10, 'October', 31),
			  (11, 'November', 30),
			  (12, 'December', 31)
commit;
