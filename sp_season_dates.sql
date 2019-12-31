/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																					   			          
 Created Date:  08/30/2019																							   
 Modified Date: 12/31/2019																							   
											       																	   
 Project: SLADB	
 																							   
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

create or alter procedure dbo.sp_season_dates @year int = null as
--alter procedure dbo.sp_season_dates @year int = null as
begin

	/*Initialize the variables that are being used to create the output table*/
	declare @year1 int = isnull(@year, year(getdate())),
			@i int = 1,
			@n int, @t int,
			@fixed bit, @year1_round bit, @season_id int,
			@year1_start date, @year1_end date,
			@seas_start date, @seas_end date,
			@offs_start1 date, @offs_end1 date,
			@offs_start2 date, @offs_end2 date;
	
	declare @tbl_season_dates table(season_date_id int identity(1,1),
									season_id int,
									effective_from date,
									effective_from_adj date,
									effective_to date,
									effective_to_adj date,
									date_category_id int);

	declare @off_dates_ref table (season_id int,
							      ref_date date,
							      saturday_ref_date date,
							      sunday_ref_date date,
							      date_row int,
							      date_type_id int,
							      date_category_id int);

	declare @seasonids table(season_id int,
							 row_id int identity(1,1));
	
	/*Create a table variable that will hold the transformed date values.*/
	declare @dates_ref table (season_id int,
							  ref_date date,
							  saturday_ref_date date,
							  sunday_ref_date date,
							  date_row int,
							  date_type_id int,
							  date_category_id int);
	
	declare @offseason table(season_id int,
							 ref_date date,
							 date_type_id int,
							 date_category_id int,
							 date_row int);

	insert into @seasonids(season_id)
		select distinct season_id
		from sladb.dbo.vw_ref_sla_season_definition;

	/*Set the inner loop value to start at 1*/
	set @i = 1;	

	/*Set the number of iterations to the number of SLA seasons*/
	set @n = (select count(*) from @seasonids);

		/*Iterate through the dates where i is less than or equal to the number of dates*/
		while @i <= @n
		begin/*Start the i loop*/
			set @season_id = (select season_id from @seasonids where row_id = @i);

			/*Select the fixed value from table variable where the id is equal to i*/
			set @fixed = (select distinct(date_ref_fixed) from sladb.dbo.vw_ref_sla_season_definition where season_id = @season_id);
			set @year1_round = (select distinct(year_round) from sladb.dbo.vw_ref_sla_season_definition where season_id = @season_id);
			print @fixed
			print @year1_round
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
				print 'Fixed SLA section';
				insert into @tbl_season_dates(season_id,
											  effective_from,
											  effective_from_adj,
											  effective_to,
											  effective_to_adj,
											  date_category_id)
					select l.season_id,
						   l.ref_date as effective_from,
						   l.sunday_ref_date as effective_from_adj,
						   r.ref_date as effective_to,
						   r.saturday_ref_date as effective_from_adj,
						   l.date_category_id
					from (select * 
						  from sladb.dbo.vw_date_ref_fixed
						  where season_id = @season_id and
								date_type_id = 1 and
								year(ref_date) = @year1) as l
					full outer join
							(select * 
							 from sladb.dbo.vw_date_ref_fixed
							 where season_id = @season_id and
								   date_type_id = 2 and
								   year(ref_date) = @year1) as r
					on l.season_id = r.season_id and
					   l.date_row = r.date_row;	
					
					/*If the season is year round, that is from 1/1 to 12/31 then insert the records into the season date table.*/
					if @year1_round = 1
						goto tableupdate;

					if @year1_round = 0
						goto notyearround;

			/*This sections calculates the dates when seasons are composed of non-fixed dates (example Last Tuesday of February).*/
			notfixed:
				print 'Not fixed SLA section';
				insert into @tbl_season_dates(season_id,
											  effective_from,
											  effective_from_adj,
											  effective_to,
											  effective_to_adj,
											  date_category_id)
					select l.season_id,
							l.ref_date as effective_from,
							l.sunday_ref_date as effective_from_adj,
							r.ref_date as effective_to,
							r.saturday_ref_date as effective_from_adj,
							l.date_category_id
					from (select * 
						  from sladb.dbo.vw_date_ref_notfixed
						  where season_id = @season_id and
								date_type_id = 1 and
								year(ref_date) = @year1) as l
					full outer join
							(select * 
							 from sladb.dbo.vw_date_ref_notfixed
							 where season_id = @season_id and
								   date_type_id = 2 and
								   year(ref_date) = @year1) as r
					on l.season_id = r.season_id and
						l.date_row = r.date_row;
					
					/*If the season is year round, that is from 1/1 to 12/31 then insert the records into the season date table.*/
					if @year1_round = 1
						--goto tableinsert;
						goto tableupdate;

					if @year1_round = 0
						goto notyearround;		

			/*The labeled section for dates that are not year round*/
			notyearround:
				print 'The not year round labelled section.';
				set @year1_start = datefromparts(@year1, 1, 1);
				set @year1_end = datefromparts(@year1, 12, 31);
				set @seas_start = (select effective_from from @tbl_season_dates);
				print @seas_start
				set @seas_end = (select effective_to from @tbl_season_dates);

				/*If the start of season is equal to the start of the year or the end of a season
					is equal to the end of the year then set the number of time periods equal to 2.*/
				if @seas_start = @year1_start or @seas_end = @year1_end
					set @t = 2;
				else
					set @t = 3;
						
				/*If the the number time periods is 3 then set the following date values.*/
				if @t = 3
					begin
						print 'Two offseason time period.';
						set @offs_start1 = @year1_start;
						set @offs_end1 = dateadd(day, -1, @seas_start);

						set @offs_start2 = dateadd(day, 1, @seas_end);
						set @offs_end2 = @year1_end;

						goto offseason;
					end;
						
				/*If the the number time periods is 2 then set the following date values.*/
				if @t = 2 
					begin;
					print 'One offseason time period.';
					if @seas_start = @year1_start
						begin
							set @offs_start1 = dateadd(day, 1, @seas_start);
							set @offs_end1 = @year1_end;

							goto offseason;
						end;
								
					if @seas_end = @year1_end
						begin
							set @offs_start1 = @year1_start;
							set @offs_end1 = dateadd(day, -1, @seas_start);

							goto offseason;
						end;
					end;
				
				/*This labelled section will calculate the dates for the offseason.*/
				offseason:
				print 'The offseason labelled section.';
					if @t = 3
						begin;
							insert into @offseason(season_id,
												   ref_date,
												   date_type_id,
												   date_category_id,
												   date_row)
								values(@season_id, @offs_start1, 3, 2, 1),
									  (@season_id, @offs_end1, 4, 2, 1),
									  (@season_id, @offs_start2, 3, 2, 2),
									  (@season_id, @offs_end2, 4, 2, 2)
								--select * from @offseason
								goto offseasondates;
						end;

					if @t = 2
						begin
							insert into @offseason(season_id,
											       ref_date,
											       date_type_id,
											       date_category_id,
											       date_row)
								values(@season_id, @offs_start1, 3, 2, 1),
									  (@season_id, @offs_end1, 4, 2, 1);

							goto offseasondates;

						end; 

				offseasondates:	
					print 'Offseason dates labelled section';
					insert into @off_dates_ref(season_id,
											   ref_date,
											   saturday_ref_date,
											   sunday_ref_date,
											   date_row,
											   date_type_id,
											   date_category_id)
						select l.season_id,
								l.ref_date as ref_date,
								r.saturday_ref_date,
								r.sunday_ref_date,
								l.date_row,
								l.date_type_id,
								l.date_category_id
						from @offseason as l
						left join
								sladb.dbo.vw_season_dates_adjusted as r
						on l.ref_date = r.ref_date

					insert into @tbl_season_dates
						select l.season_id,
								l.ref_date as effective_from,
								l.sunday_ref_date as effective_from_adj,
								r.ref_date as effective_to,
								r.saturday_ref_date as effective_from_adj,
								l.date_category_id
						from (select * 
							  from @off_dates_ref
							  where season_id = @season_id and
									date_type_id = 3 and
									year(ref_date) = @year1) as l
						full outer join
								(select * 
								 from @off_dates_ref
								 where season_id = @season_id and
									   date_type_id = 4 and
									   year(ref_date) = @year1) as r
						on l.season_id = r.season_id and
						   l.date_row = r.date_row;
						
						goto tableinsert;

			tableupdate:
				print 'Doing table update'
				print @year1_round 
				print @fixed
				/*Insert the date values into the season date table.*/
				begin transaction 
					update sladb.dbo.tbl_sla_season_date
						set effective_to = u.effective_to, 
							effective_to_adj = u.effective_to_adj
						from @tbl_season_dates as u
						where sladb.dbo.tbl_sla_season_date.season_id = u.season_id;
						/*Add a filter to only insert dates where the starting date is 1 day less than today.
						where effective_from = dateadd(d, -1, cast(getdate() as date))*/
				commit;
				goto next_iter
			
			tableinsert:
				print 'Doing table insert'
				print @year1_round 
				print @fixed
				/*Insert the date values into the season date table.*/
				begin transaction 
					insert into sladb.dbo.tbl_sla_season_date(season_id, effective_from, effective_from_adj, effective_to, effective_to_adj, date_category_id)
						select season_id, 
							   effective_from, 
							   effective_from_adj, 
							   effective_to, 
							   effective_to_adj, 
							   date_category_id
						from @tbl_season_dates;
						/*Add a filter to only insert dates where the starting date is 1 day less than today.
						where effective_from = dateadd(d, -1, cast(getdate() as date))*/
				commit;
				goto next_iter

			next_iter:
			set @i = @i + 1;
		end;
end;
