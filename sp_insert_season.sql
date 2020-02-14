/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management  																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: 10/24/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_sla_season																							   
 			  sladb.dbo.tbl_ref_sla_season_definition																								   			
			  																				   
 Description: Create a procedure that performs an insert into two the tbl_sla_season table and the tbl_ref_sla_season_defintion
	          table and carries through the identity value (season_id) from the tbl_sla_season table.
																													   												
***********************************************************************************************************************/
use sladb
go
create or alter procedure dbo.sp_insert_season(@season_desc nvarchar(128),
											   @year_round bit,
											   @effective bit,
											   @date_ref_fixed bit,
											   @month_name_desc nvarchar(9) null,
											   @date_ref_day_number int null,
											   @day_name_desc nvarchar(9) null,
											   @day_rank_id nvarchar(5) null,
											   @date_type_id int null) as

/*alter procedure dbo.sp_insert_season(@season_desc nvarchar(128),
									  @year_round bit,
									  @effective bit,
									  @date_ref_fixed bit,
									  @month_name_desc nvarchar(9) = null,
									  @date_ref_day_number int = null,
									  @day_name_desc nvarchar(9) = null,
									  @day_rank_id nvarchar(5) = null,
									  @date_type_id int = null) as*/
begin
	begin transaction;
		declare @season_id int;

		/*Insert the values into the Season table*/
		insert into sladb.dbo.tbl_sla_season(season_desc,
											 year_round,
											 effective)
			values (@season_desc, @year_round, @effective);
		
		/*Set the value of the season_id parameter equal to the last identity value inserted*/
		set @season_id = @@identity;

		if @date_ref_fixed = 0
		
		/*Insert values into the season defintion table.*/
		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, 
															date_ref_fixed, 
															month_name_desc, 
															date_ref_day_number, 
															day_name_desc, 
															day_rank_id,
															date_type_id)

			values(@season_id, @date_ref_fixed, @month_name_desc, @date_ref_day_number, @day_name_desc, @day_rank_id, @date_type_id);
	commit;
end;