/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_sla_season																							   
 			  sladb.dbo.tbl_ref_sla_season_definition																								   			
			  																				   
 Description: Create a procedure that performs an insert into two the tbl_sla_season table and the tbl_ref_sla_season_defintion
	          table and carries through the identity value (season_id) from the tbl_sla_season table.
																													   												
***********************************************************************************************************************/
use sladb
go
create procedure dbo.sp_insert_season(@season_desc nvarchar(128),
									  @year_round bit,
									  @effective bit,
									  @season_date_ref_fixed bit,
									  @season_date_month_name_desc nvarchar(9),
									  @season_date_ref_day_number int,
									  @season_date_day_name_desc nvarchar(9),
									  @season_day_rank_id nvarchar(5),
									  @season_date_type_id int,
									  @season_id int) as
begin
	begin transaction;
		/*Insert the values into the Season table*/
		insert into sladb.dbo.tbl_sla_season(season_desc,
											 year_round,
											 effective)
			values (@season_desc, @year_round, @effective);
		
		/*Set the value of the season_id parameter equal to the last identity value inserted*/
		set @season_id = @@identity;

		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, 
															season_date_ref_fixed, 
															season_date_month_name_desc, 
															season_date_ref_day_number, 
															season_date_day_name_desc, 
															season_day_rank_id,
															season_date_type_id)

			values(@season_id, @season_date_ref_fixed, @season_date_month_name_desc, @season_date_ref_day_number, @season_date_day_name_desc, @season_day_rank_id, @season_date_type_id);
	commit;
end;