/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management   																						   			          
 Created Date:  09/04/2019																							   
 Modified Date: 02/27/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
use sladb;
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_i_tbl_sla_season
on sladb.dbo.tbl_sla_season
after insert as 
	begin
	/*Create a table parameter to hold the values required for the insert. For completeness, this table will hold the values
	  for year round seasons that begin on January 1 and end on December 31.*/
	declare @tbl_ref_sla_season_definition table(season_date_ref_id int identity(1,1),
												 date_ref_fixed bit not null,
												 month_name_desc nvarchar(9) not null,
												 date_ref_day_number int null,
												 day_name_desc nvarchar(9) null,
												 day_rank_id nvarchar(5) null,
												 date_type_id int not null);
		
		/*Insert the values of January 1 and December 31 into the table parameter. Both dates are fixed so they are assigned
		  a value date_ref_fixed = 1. January 1 is the start date of the season so it's assigned a value date_type_id = 1 while
		  December 31 is the end date of the season, so it's assigned a value date_type_id = 2.*/
		insert into @tbl_ref_sla_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
			values(cast(1 as bit), 'January', cast(1 as int), cast(1 as int)) /*Start Season value*/,
				  (cast(1 as bit), 'December', cast(31 as int), cast(2 as int));

		begin transaction
		/*Insert the season definition into the tbl_ref_sla_season_definition table for year round season.*/
		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
			select l.season_id,
				   r.date_ref_fixed, 
				   r.month_name_desc, 
				   r.date_ref_day_number, 
				   r.date_type_id
				 /*Filter out the inserted value(s) to only include those that are year round.*/
			from (select season_id
				  from inserted
				  where year_round = 1) as l
			/*Perform a cross join between the season_id of the year round seasons and the @tbl_ref_sla_season_definition table parameter. For each season,
			  the end result is the addition of the season_id column to each of the two rows in @tbl_ref_sla_season_defintion.*/
			cross join
				 @tbl_ref_sla_season_definition as r
			order by season_id, date_type_id;
		commit;
	end;