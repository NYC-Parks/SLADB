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

/*create procedure dbo.sp_season_dates as
begin*/

	/*Initialize the variables that are being used to create the output table*/
	declare @year int = year(getdate()),
			@i int = 1,
			@n int,
			@fixed bit, @year_round bit, @season_id int,
			@start_actual date, @start_adjusted date,
			@end_actual date, @end_adjusted date;

	declare @alldates table(row_id int identity(1,1),
							season_date_ref_id int,
							season_id int,
							season_date_ref_fixed bit,
							season_date_month_name_desc nvarchar(9),
							season_date_ref_day_number int,
							season_date_day_name_desc nvarchar(9),
							season_day_rank_id nvarchar(5),
							season_date_type_id int,
							season_year_round bit,
							season_date_category_id int);

	declare @seasonids table(season_id int,
							 row_id int identity(1,1));
	
	/*Create a table variable that holds the actual holiday date and the observed date*/
	declare @dates_ref table (season_id int,
							  actual_date date,
							  adjusted_date date,
							  date_row int,
							  season_date_type_id int,
							  season_date_category_id int);

	insert into @alldates(season_date_ref_id, season_id, season_date_ref_fixed, season_date_month_name_desc, season_date_ref_day_number, 
						  season_date_day_name_desc, season_day_rank_id, season_date_type_id, season_year_round, season_date_category_id)

		select l.season_date_ref_id, 
			   l.season_id, 
			   l.season_date_ref_fixed, 
			   l.season_date_month_name_desc, 
			   l.season_date_ref_day_number, 
			   l.season_date_day_name_desc, 
			   l.season_day_rank_id,
			   l.season_date_type_id,
			   r.season_year_round,
			   r2.season_date_category_id
		 from sladb.dbo.tbl_ref_sla_season_definition as l
		 inner join
			  sladb.dbo.tbl_sla_season as r
		 on l.season_id = r.season_id
		 left join
			  sladb.dbo.tbl_ref_sla_season_date_type as r2
		 on l.season_date_type_id = r2.season_date_type_id
		 /*Exclude Seasons that are no longer active.*/
		 where r.season_active = 1;

	insert into @seasonids(season_id)
		select distinct season_id
		from @alldates;

	/*Set the inner loop value to start at 1*/
	set @i = 1;	

	/*Set the number of iterations to the number of SLA seasons*/
	set @n = (select count(*) from @seasonids);

	--set @season_id = (select row_id from @seasonids);
	set @season_id = (select season_id from @seasonids where row_id = @i);

		/*Iterate through the dates where i is less than or equal to the number of dates*/
		while @i <= @n
		begin/*Start the i loop*/
			/*Select the fixed value from table variable where the id is equal to i*/
			set @fixed = (select season_date_ref_fixed from @alldates where row_id = @i);
			set @year_round = (select season_year_round from @alldates where row_id = @i);

			/*Delete all records from the date reference table at the start of each iteration.*/
			delete 
			from @dates_ref;

			/*If the SLA season is year round fixed then insert the following records*/
			if @fixed = 1 and @year_round = 1
				begin
					/*Insert the holiday date values into the dates reference table*/
					insert into @dates_ref(season_id,
											actual_date,
											adjusted_date,
											date_row,
											season_date_type_id,
											season_date_category_id)
						select l.season_id,
								r.ref_date as actual_date,
								dateadd(day, season_day_name_ndays, r.ref_date) as adjusted_date,
								row_number() over(partition by season_id, season_date_type_id order by season_id, season_date_type_id) as n,
								l.season_date_type_id,
								l.season_date_category_id
						from (select *
								from @alldates
								where season_id = @season_id) as l
						left join
							(select *
								from sladb.dbo.tbl_ref_calendar
								where year(ref_date) = @year) as r
						/*Join the tables on the month name, the day name and when the day_ranks are equal.*/
						on l.season_date_month_name_desc = r.month_name and
							--l.season_date_day_name_desc = r.day_name and
							l.season_date_ref_day_number = datepart(day, ref_date)
							--l.season_day_rank_id = r.day_rank
						left join
								sladb.dbo.tbl_ref_sla_season_day_name as r2
						on r2.season_day_name_desc = r.day_name;

					/*Insert the date values into the season date table.*/
					--begin transaction 
						--insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_category_id)
							select l.season_id,
								l.actual_date as date_start,
								l.adjusted_date as date_start_adj,
								r.actual_date as date_end,
								r.adjusted_date as date_end_adj,
								l.season_date_category_id
							from (select * 
									from @dates_ref
									where season_date_type_id = 1) as l
							full outer join
									(select * 
									from @dates_ref
									where season_date_type_id = 2) as r
							on l.season_id = r.season_id and
								l.date_row = r.date_row;	
					--commit;
					set @i = @i + 1;
				end;

			/*If the SLA season is year round fixed then insert the following records*/
			if @fixed = 1 and @year_round = 0
				begin
				/*Insert the holiday date values into the dates reference table*/
				insert into @dates_ref(season_id,
										actual_date,
										adjusted_date,
										date_row,
										season_date_type_id,
										season_date_category_id)
					select l.season_id,
							r.ref_date as actual_date,
							dateadd(day, season_day_name_ndays, r.ref_date) as adjusted_date,
							row_number() over(partition by season_id, season_date_type_id order by season_id, season_date_type_id) as n,
							l.season_date_type_id,
							l.season_date_category_id
					from (select *
							from @alldates
							where season_id = @season_id) as l
					left join
						(select *
							from sladb.dbo.tbl_ref_calendar
							where year(ref_date) = @year) as r
					/*Join the tables on the month name, the day name and when the day_ranks are equal.*/
					on l.season_date_month_name_desc = r.month_name and
						--l.season_date_day_name_desc = r.day_name and
						l.season_date_ref_day_number = datepart(day, ref_date)
						--l.season_day_rank_id = r.day_rank
					left join
							sladb.dbo.tbl_ref_sla_season_day_name as r2
					on r2.season_day_name_desc = r.day_name;

										/*Insert the date values into the season date table.*/
					--begin transaction 
						--insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_category_id)
							select l.season_id,
								l.actual_date as date_start,
								l.adjusted_date as date_start_adj,
								r.actual_date as date_end,
								r.adjusted_date as date_end_adj,
								l.season_date_category_id
							from (select * 
									from @dates_ref
									where season_date_type_id = 1) as l
							full outer join
									(select * 
									from @dates_ref
									where season_date_type_id = 2) as r
							on l.season_id = r.season_id and
								l.date_row = r.date_row;	
					--commit;

				end;

			/*If the SLA season is year round fixed then insert the following records*/
			if @fixed = 1 and @year_round = 0
				begin
								/*Insert the holiday date values into the dates reference table*/
				insert into @dates_ref(season_id,
										actual_date,
										adjusted_date,
										date_row,
										season_date_type_id,
										season_date_category_id)
					select l.season_id,
							r.ref_date as actual_date,
							dateadd(day, season_day_name_ndays, r.ref_date) as adjusted_date,
							row_number() over(partition by season_id, season_date_type_id order by season_id, season_date_type_id) as n,
							l.season_date_type_id,
							l.season_date_category_id
					from (select *
							from @alldates
							where season_id = @season_id) as l
					left join
						(select *
							from sladb.dbo.tbl_ref_calendar
							where year(ref_date) = @year) as r
					/*Join the tables on the month name, the day name and when the day_ranks are equal.*/
					on l.season_date_month_name_desc = r.month_name and
						--l.season_date_day_name_desc = r.day_name and
						l.season_date_ref_day_number = datepart(day, ref_date)
						--l.season_day_rank_id = r.day_rank
					left join
							sladb.dbo.tbl_ref_sla_season_day_name as r2
					on r2.season_day_name_desc = r.day_name;

				end;
				set @i = @i + 1;
			end;

				/*If the holiday is fixed (ex: July 4) then insert the following records*/
				else
					begin
						/*Insert the holiday date values into the dates reference table*/
						insert into @dates_ref
							/*The actual and observed dates of fixed holidays may vary depending on the day of the week on which the holiday falls*/
							select r.year_date as actual_date,
									/*When a holiday falls on Saturday then the observed date is Friday, when it falls on a Sunday the observered date
										is Monday, otherwise the actual and observed dates are equal. This logic is built from the link in the doc block.*/
									case when r.day_name = 'Saturday' then cast(dateadd(day, -1, r.year_date) as date)
										when r.day_name = 'Sunday' then cast(dateadd(day, 1, r.year_date) as date)
										else r.year_date
									end as observed_date
							from @holidays as l
							inner join
									@dates as r
							/*Join the tables based the month name and the day number being equal*/
							on l.month_name = r.month_name and
								l.day_number = datepart(day, r.year_date)
							where id = @i;

							/*Set the actual holiday date from the dates reference table*/
							set @actual_date = (select actual_date from @dates_ref);
							/*Set the observed holiday date from the dates reference table*/
							set @observed_date = (select observed_date from @dates_ref);
						
						/*Delete the records in the dates_ref table*/
						delete from @dates_ref;

						/*Update the values in the holidays table with the actual and observed dates for a given holiday based on i being equal to the id*/
						update @holidays
							set actual_date = @actual_date,
								observed_date = @observed_date
							where id = @i;
					end;
				/*Set the iteration to the next step*/
				set @i = @i + 1;
			end;/*End the i loop*/

				/*Insert the values from the holiday reference table variable into the permanent table*/
				begin transaction
				insert into dwh.dbo.tbl_ref_holiday(name, actual_date, observed_date, floating)
					select name, 
						   actual_date, 
						   observed_date, 
						   floating 
					from @holidays
				commit transaction
				/*Set the iteration to the next step*/
				set @year = @year + 1;
			end;/*End the year loop*/
end;