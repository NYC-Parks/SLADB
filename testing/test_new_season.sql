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
/*Insert a new periodic season with fixed dates that starts on April 15 and end on November 15*/
declare @new_season as insert_new_season,
	    @new_season_definition as insert_new_season_definition

insert into @new_season(season_desc, year_round, effective_start)
	values('Season test 1', 0, cast(getdate() as date));

insert into @new_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, day_name_desc,
								   day_rank_id, date_type_id)
	values(1, 'April', 15, null, null,  1),
		  (1, 'November', 15, null, null,  2);

exec sladb.dbo.sp_insert_season @new_season = @new_season, @new_season_definition = @new_season_definition

