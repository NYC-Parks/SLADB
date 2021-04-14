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

/*If the user-defined table types don't exist then create them. These user-defined table types
  are used as inputs into the sp_insert_season stored procedure.*/
if type_id('insert_new_season') is null
	create type insert_new_season
		as table(season_desc nvarchar(128),
				 year_round bit not null,
				 effective_start date not null);

if type_id('insert_new_season_definition') is null
	create type insert_new_season_definition
		as table(date_ref_fixed bit not null,
				 month_name_desc nvarchar(9) not null,
				 date_ref_day_number int null,
				 day_name_desc nvarchar(9) null,
				 day_rank_id nvarchar(5) null,
				 date_type_id int not null);

go 

create or alter procedure dbo.usp_insert_season @new_season insert_new_season readonly, 
											   @new_season_definition insert_new_season_definition readonly as
begin
	begin transaction;
		declare @season_id int;

		/*Insert the values into the Season table*/
		insert into sladb.dbo.tbl_sla_season(season_desc,
											 year_round,
											 effective_start)
			select * from @new_season;
	
		/*Set the value of the season_id parameter equal to the last identity value inserted*/
		set @season_id = (select ident_current('sladb.dbo.tbl_sla_season'));
		
		/*Insert values into the season defintion table.*/
		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, 
															date_ref_fixed, 
															month_name_desc, 
															date_ref_day_number, 
															day_name_desc, 
															day_rank_id,
															date_type_id)

			select @season_id, 
				   date_ref_fixed, 
				   month_name_desc, 
				   date_ref_day_number, 
				   day_name_desc, 
				   day_rank_id,
				   date_type_id
			from @new_season_definition;
	
	/*If the previous statement encountered an error, the value of @error will be greater than 0 and the 
	  transaction should be rolled back.*/
	if @@error > 0
	begin
	rollback transaction
	end;

	/*If no error is encountered then commit the transaction.*/
	else
	begin
	commit;
	end;
end;