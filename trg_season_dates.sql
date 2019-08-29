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
create trigger sladb.dbo.trg_season_dates 
on sladb.dbo.tbl_ref_sla_season_date
after insert, update as


/*Initialize the variables that are being used to create the output table*/
declare @year int = year(getdate()),
		@i int,
		@n int,
		@fixed bit,
		@actual_date date, @observed_date date;


	/*Create the table variable that holds the values from the calendar reference table that are needed to assign holiday dates.*/
	declare @dates table(year_date date not null,
						 month_name nvarchar(9) not null,
						 day_name nvarchar(9) not null,
						 day_rank nvarchar(3) not null);

	/*Set the inner loop value to start at 1*/
	set @i = 1;	
	/*Set the number of iterations to the number of SLA seasons*/
	set @n = (select count(*) from sladb.dbo.tbl_ref_sla_season_date);

	/*Create a table variable that holds the actual holiday date and the observed date*/
	declare @dates_ref table (actual_date date,
							  observed_date date);

	/*Delete all records from the dates table variable*/		
	delete from @dates;

		/*Insert the values into the dates table variable from the calendar reference table*/
		insert into @dates
			select ref_date as year_date,
					month_name,
					day_name,
					/*Calculate the rank of day names by months*/
					dense_rank() over (partition by month_name, day_name order by ref_date, month_name, day_name) as day_rank
			from (select ref_date, 
						 /*Weekday name of reference date*/
						 datename(weekday, ref_date) as day_name, 
						 /*Month name of reference date*/
						 datename(month, ref_date) month_name 
					from sladb.dbo.tbl_ref_calendar
					/*Subset to the year of the current iteration*/
					where year(ref_date) = @year) as t
					order by ref_date;

			/*Iterate through the holidays where i is less than or equal to the number of holidays*/
			while @i <= @n
			begin/*Start the i loop*/
				/*Select the fixed value from holidays table variable where the id is equal to i*/
				set @fixed = (select season_date_ref_fixed as fixed from sladb.dbo.tbl_ref_sla_season_date where season_date_ref_id = @i);

				/*If the holiday is not fixed (ex: 2nd Monday of Month) then insert the following records*/
				if @fixed = 0
					begin
						/*Insert the holiday date values into the dates reference table*/
						insert into @dates_ref
							/*Luckily the actual and observed dates will always be equal for these holidays because they always occur on weekdays.*/
							select r.year_date as actual_date,
								   r.year_date as observed_date
							from sladb.dbo.tbl_ref_sla_season_date as l
							inner join
								(select *,
										/*Take the highest value for the rank of the day names in each month and assign it a value of max*/
										case when last_value(day_rank) over (partition by month_name, day_name order by month_name, day_name) = day_rank then 'max'
										/*Otherwise cast the rank as its value*/
												else cast(day_rank as nvarchar(3)) 
										end as day_rank2
								 from @dates) as r
							/*Join the tables on the month name, the day name and when the day_ranks are equal.*/
							on l.season_date_month_name_desc = r.month_name and
							   l.season_date_day_name_desc = r.day_name and
							  (l.season_day_rank_id = r.day_rank2 or 
							   l.season_day_rank_id = r.day_rank)
							where season_date_ref_id = @i;

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
/*end;*/