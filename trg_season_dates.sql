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

create procedure dbo.sp_season_dates as
begin

	/*Initialize the variables that are being used to create the output table*/
	declare @year int = year(getdate()),
			@i int,
			@n int,
			@fixed bit,
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
							season_date_type_id int);
	
	/*Create a table variable that holds the actual holiday date and the observed date*/
	declare @dates_ref table (season_id int,
							  actual_date date,
							  adjusted_date date,
							  season_date_type_id int);

	insert into @alldates(season_date_ref_id, season_id, season_date_ref_fixed, 
						  start_date_month_name_desc, start_date_ref_day_number, start_date_day_name_desc, start_day_rank_id,
						  end_date_month_name_desc, end_date_ref_day_number, end_date_day_name_desc, end_day_rank_id)
		select l.season_date_ref_id, 
			   l.season_id, 
			   l.season_date_ref_fixed, 
			   l.start_date_month_name_desc, 
			   l.start_date_ref_day_number, 
			   l.start_date_day_name_desc, 
			   l.start_day_rank_id,
			   l.end_date_month_name_desc, 
			   l.end_date_ref_day_number, 
			   l.end_date_day_name_desc, 
			   l.end_day_rank_id,
			   r.season_year_round
		 from sladb.dbo.tbl_ref_sla_season_definition as l
		 inner join
			  sladb.dbo.tbl_sla_season as r
		 on l.season_id = r.season_id
		 /*Exclude Seasons that are no longer active.*/
		 where r.season_active = 1;

	/*Set the inner loop value to start at 1*/
	set @i = 1;	
	/*Set the number of iterations to the number of SLA seasons*/
	set @n = (select count(*) from @alldates);

			/*Iterate through the dates where i is less than or equal to the number of dates*/
			while @i <= @n
			begin/*Start the i loop*/
				/*Select the fixed value from table variable where the id is equal to i*/
				set @fixed = (select season_date_ref_fixed as fixed from @alldates where row_id = @i);

				/*If the SLA season is year round fixed then insert the following records*/
				if @fixed = 1
					begin
						/*Insert the holiday date values into the dates reference table*/
						insert into @dates_ref
							/**/
							select l.season_id,
								   r.ref_date as actual_date,
								   dateadd(day, season_day_name_ndays, r.ref_date) as adjusted_date,
								   l.season_date_type_id
							from (select *
								  from @alldates
								  where row_id = @i) as l
							inner join
								(select *
								 from sladb.dbo.tbl_ref_calendar) as r
							/*Join the tables on the month name, the day name and when the day_ranks are equal.*/
							on l.season_date_month_name_desc = r.month_name and
							   l.season_date_day_name_desc = r.day_name and
							   l.season_day_rank_id = r.day_rank
							inner join
								 sladb.dbo.tbl_ref_sla_season_day_name as r2
							on l.season_date_day_name_desc = r.day_name;

						begin transaction 
							insert into sladb.dbo.tbl_sla_season_date(season_id, date_start, date_start_adj, date_end, date_end_adj, season_type_id)
								
						
						commit;

						/*Update the values in the holidays table with the actual and observed dates for a given holiday based on i being equal to the id*/
						update @holidays
							set actual_date = @actual_date,
								adjusted_date = @adjusted_date
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
end;