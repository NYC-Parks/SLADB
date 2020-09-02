/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  10/23/2019																							   
 Modified Date: 02/27/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Insert the initial historic SLAs to start SLADB.  									   
																													   												
***********************************************************************************************************************/
declare @i int, @n int, @j int, @m int, @k int;

declare @tbl_sla_season table(season_id int identity(1,1) primary key,
							  season_desc nvarchar(128),
							  year_round bit not null,
							  effective bit not null,
							  effective_start date not null);

declare @tbl_ref_sla_season_definition table(season_date_ref_id int identity(1,1),
											 date_ref_fixed bit not null,
											 month_name_desc nvarchar(9) not null,
											 date_ref_day_number int null,
											 day_name_desc nvarchar(9) null,
											 day_rank_id nvarchar(5) null,
											 date_type_id int not null);

	/*Insert the seasons into a table variable*/
	insert into @tbl_sla_season(season_desc, year_round, effective, effective_start)
		values('Year-round, not seasonal', 1, 1, '2014-01-01'),
			  ('Beaches, etc.', 0, 1, '2019-07-01'),
			  ('Ballfields, etc.', 0, 1, '2019-07-01');		
	
	/*Insert the season definitions into a table variable*/
	insert into @tbl_ref_sla_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
		values(1, 'January', 1, 1),
			  (1, 'December', 31, 2),
			  (1, 'May', 1, 1),
			  (1, 'October', 1, 2),
			  (1, 'March', 1, 1),
			  (1, 'October', 31, 2);
	
	set @i = 1;
	set @j = 1;
	/*Set this value to the highest identity value in the season_id column*/
	set @n = (select max(season_id) from @tbl_sla_season);
	/*Set this value to the highest identity value in the season_date_ref_id column*/
	set @m = (select max(season_date_ref_id) from @tbl_ref_sla_season_definition);

	while @i <= @n
		begin
			/*Get the current identity value in the tbl_sla_season to set for the season definitions*/
			set @k = (select ident_current('sladb.dbo.tbl_sla_season') + 1);

			begin transaction
				insert into sladb.dbo.tbl_sla_season(season_desc, year_round, effective, effective_start)
					select season_desc, 
							year_round, 
							effective, 
							effective_start
					from @tbl_sla_season
					where season_id = @i;
			commit;

			/*Only work through seasons that aren't year round because year round seasons are taken care of a with a trigger*/
			if (select year_round from @tbl_sla_season where season_id = @i) = 0 and 
			   @j <= @m
				begin			
					begin transaction
						insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
							select @k as season_id,
									date_ref_fixed,
									month_name_desc, 
									date_ref_day_number, 
									date_type_id
							from @tbl_ref_sla_season_definition
							where season_date_ref_id between @j and @j + 1;
					commit;
				end;
					
			set @i = @i + 1
			set @j = @j + 2

		end;