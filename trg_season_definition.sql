/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  09/04/2019																							   
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
use sladb
go

create trigger dbo.trg_season_definition
on sladb.dbo.tbl_sla_season
after insert as 
	begin
		declare @i int = 1, @n int, @year_round bit, @season_id int;

		declare @inserted table(row_id int identity(1,1),
								season_id int,
								season_year_round bit);

		declare @current table(row_id int identity(1,1),
							   season_id int,
							   season_year_round bit);


		insert into @inserted(season_id, season_year_round)
			select season_id,
				   season_year_round 
			from inserted;

		set @n = (select count(*) from @inserted);

		while @i <= @n
			begin
				set @year_round = (select season_year_round from @inserted where row_id = @i);
				set @season_id = (select season_id from @inserted where row_id = @i);

				/*If it is a year round season then insert values for January 1 and December 1*/
				if @year_round = 1
					begin
						begin transaction
							insert into tbl_ref_sla_season_definition(season_id, season_date_ref_fixed, start_date_month_name_desc, start_date_ref_day_number, end_date_month_name_desc, end_date_ref_day_number)
								values(@season_id, cast(1 as bit), 'December', cast(31 as int), cast(1 as int), 'January', cast(1 as int), cast(2 as int));
						commit;
					end;

				set @i = @i + 1;
			end;
		/*begin transaction
			insert into tbl_ref_sla_season_definition(season_id, season_date_ref_fixed, season_date_month_name_desc, season_date_ref_day_number, season_date_type)
				select season_id,
					   cast(1 as bit) as season_date_ref_fixed,
					   'January' as season_date_month_name_desc,
					   cast(1 as int) as season_date_ref_day_number,
					   cast(1 as int) as season_date_type
				from inserted 
				where season_year_round = 1;
		commit;

		begin transaction
			insert into tbl_ref_sla_season_definition(season_id, season_date_ref_fixed, season_date_month_name_desc, season_date_ref_day_number, season_date_type)
				select season_id,
					   cast(1 as bit) as season_date_ref_fixed,
					   'December' as season_date_month_name_desc,
					   cast(31 as int) as season_date_ref_day_number,
					   cast(2 as int) as season_date_type
				from inserted 
				where season_year_round = 1;
		commit;*/


	end;