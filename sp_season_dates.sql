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
use sladb
go

/*create procedure dbo.sp_season_dates @year int = year(getdate()) as
begin*/

	/*Initialize the variables that are being used to create the output table*/
	declare @year int = year(getdate()),
			@i int = 1,
			@n int, @t int,
			@fixed bit, @year_round bit, @season_id int,
			@year_start date, @year_end date,
			@seas_start date, @seas_end date,
			@offs_start1 date, @offs_end1 date,
			@offs_start2 date, @offs_end2 date;
	
	declare @tbl_season_dates table(season_date_id int identity(1,1),
									season_id int,
									date_start date,
									date_start_adj date,
									date_end date,
									date_end_adj date,
									season_category_id int);

	declare @off_dates_ref table (season_id int,
							      actual_date date,
							      adjusted_date date,
							      date_row int,
							      season_date_type_id int,
							      season_date_category_id int);

	declare @seasonids table(season_id int,
							 row_id int identity(1,1));
	
	/*Create a table variable that will hold the transformed date values.*/
	declare @dates_ref table (season_id int,
							  actual_date date,
							  adjusted_date date,
							  date_row int,
							  season_date_type_id int,
							  season_date_category_id int);
	
	declare @offseason table(season_id int,
							 ref_date date,
							 season_date_type_id int,
							 season_date_category_id int,
							 date_row int);

	insert into @seasonids(season_id)
		select distinct season_id
		from sladb.dbo.vw_ref_sla_season_definition;

	/*Set the inner loop value to start at 1*/
	set @i = 1;	

	/*Set the number of iterations to the number of SLA seasons*/
	set @n = (select count(*) from @seasonids);

	--set @season_id = (select row_id from @seasonids);
		/*Iterate through the dates where i is less than or equal to the number of dates*/
		while @i <= @n
		begin/*Start the i loop*/

			set @season_id = (select season_id from @seasonids where row_id = @i);

			/*Select the fixed value from table variable where the id is equal to i*/
			set @fixed = (select distinct(season_date_ref_fixed) from sladb.dbo.vw_ref_sla_season_definition where season_id = @season_id);
			set @year_round = (select distinct(season_year_round) from sladb.dbo.vw_ref_sla_season_definition where season_id = @season_id);

			/*Delete all records from the holding table variable.*/
			delete from @tbl_season_dates;
			delete from @offseason;

			/*If the SLA season is year round fixed then insert the following records*/
			if @fixed = 1
				goto fixed;
			
			else
				goto notfixed;
			
			/*This section calculates the dates when seasons are composed of fixed dates (example: April 1st).*/
			fixed:
			begin
				insert into @tbl_season_dates
					select l.season_id,
						   l.actual_date as date_start,
						   l.adjusted_date as date_start_adj,
						   r.actual_date as date_end,
						   r.adjusted_date as date_end_adj,
						   l.season_date_category_id
					from (select * 
						  from sladb.dbo.vw_date_ref_fixed
						  where season_id = @season_id and
								season_date_type_id = 1 and
								year(actual_date) = @year) as l
					full outer join
							(select * 
							 from sladb.dbo.vw_date_ref_fixed
							 where season_id = @season_id and
								   season_date_type_id = 2 and
								   year(actual_date) = @year) as r
					on l.season_id = r.season_id and
					   l.date_row = r.date_row;	
					
					/*If the season is year round, that is from 1/1 to 12/31 then insert the records into the season date table.*/
					if @year_round = 1
						begin;

						/*Insert the date values into the season date table.*/
						--begin transaction 
							--insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_category_id)
								select *
								from @tbl_season_dates
						--commit;
						end;

					if @year_round = 0
						goto notyearround;
			end;
			/*This sections calculates the dates when seasons are composed of non-fixed dates (example Last Tuesday of February).*/
			notfixed:

				insert into @tbl_season_dates
					select l.season_id,
							l.actual_date as date_start,
							l.adjusted_date as date_start_adj,
							r.actual_date as date_end,
							r.adjusted_date as date_end_adj,
							l.season_date_category_id
					from (select * 
						  from sladb.dbo.vw_date_ref_notfixed
						  where season_id = @season_id and
								season_date_type_id = 1 and
								year(actual_date) = @year) as l
					full outer join
							(select * 
							 from sladb.dbo.vw_date_ref_notfixed
							 where season_id = @season_id and
								   season_date_type_id = 2 and
								   year(actual_date) = @year) as r
					on l.season_id = r.season_id and
						l.date_row = r.date_row;
					
					/*If the season is year round, that is from 1/1 to 12/31 then insert the records into the season date table.*/
					if @year_round = 1
						begin;

						/*Insert the date values into the season date table.*/
						--begin transaction 
							--insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_category_id)
								select *
								from @tbl_season_dates
						--commit;
						end;

					if @year_round = 0
						goto notyearround;		

			/*The labeled section for dates that are not year round*/
			notyearround:

				set @year_start = datefromparts(@year, 1, 1);
				set @year_end = datefromparts(@year, 12, 31);
				set @seas_start = (select date_start from @tbl_season_dates);
				set @seas_end = (select date_end from @tbl_season_dates);
								
				/*Set the values for the start and end of the season*/
				set @seas_start = (select actual_date from @dates_ref where season_date_type_id = 1);
				set @seas_end = (select actual_date from @dates_ref where season_date_type_id = 2);

				/*If the start of season is equal to the start of the year or the end of a season
					is equal to the end of the year then set the number of time periods equal to 2.*/
				if @seas_start = @year_start or @seas_end = @year_end
					set @t = 2;
				else
					set @t = 3;
						
				/*If the the number time periods is 3 then set the following date values.*/
				if @t = 3
					begin
						set @offs_start1 = @year_start;
						set @offs_end1 = dateadd(day, -1, @seas_start);

						set @offs_start2 = dateadd(day, 1, @seas_end);
						set @offs_end2 = @year_end;

						goto offseason;
					end;
						
				/*If the the number time periods is 2 then set the following date values.*/
				if @t = 2 

					if @seas_start = @year_start
						begin
							set @offs_start1 = dateadd(day, 1, @seas_start);
							set @offs_end1 = @year_end;

							goto offseason;
						end;
								
					if @seas_end = @year_end
						begin
							set @offs_start1 = @year_start;
							set @offs_end1 = dateadd(day, -1, @seas_end);

							goto offseason;
						end;

				offseason:
					if @t = 3
						begin;
							insert into @offseason(season_id,
												   ref_date,
												   season_date_type_id,
												   season_date_category_id,
												   date_row)
								values(@season_id, @offs_start1, 3, 2, 1),
									  (@season_id, @offs_start1, 4, 2, 1),
									  (@season_id, @offs_start2, 3, 2, 2),
									  (@season_id, @offs_start2, 4, 2, 2)
						end;

					if @t = 2
							insert into @offseason(season_id,
											       ref_date,
											       season_date_type_id,
											       season_date_category_id,
											       date_row)
								values(@season_id, @offs_start1, 3, 2, 1),
									  (@season_id, @offs_start1, 4, 2, 1)

					
					insert into @off_dates_ref(season_id,
											   actual_date,
											   adjusted_date,
											   date_row,
											   season_date_type_id,
											   season_date_category_id)
						select l.season_id,
								l.ref_date as actual_date,
								r.adjusted_date as adjusted_date,
								l.date_row,
								l.season_date_type_id,
								l.season_date_category_id
						from @offseason as l
						left join
								sladb.dbo.vw_season_dates_adjusted as r
						on l.ref_date = r.actual_date

					insert into @tbl_season_dates
						select l.season_id,
								l.actual_date as date_start,
								l.adjusted_date as date_start_adj,
								r.actual_date as date_end,
								r.adjusted_date as date_end_adj,
								l.season_date_category_id
						from (select * 
							  from @off_dates_ref
							  where season_id = @season_id and
									season_date_type_id = 3 and
									year(actual_date) = @year) as l
						full outer join
								(select * 
								 from @off_dates_ref
								 where season_id = @season_id and
									   season_date_type_id = 4 and
									   year(actual_date) = @year) as r
						on l.season_id = r.season_id and
						   l.date_row = r.date_row;

					/*Insert the date values into the season date table.*/
					--begin transaction 
						--insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_category_id)
							select *
							from @tbl_season_dates
						--commit;

			set @i = @i + 1;
		end;
