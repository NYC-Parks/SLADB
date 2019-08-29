/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  08/28/2019																							   
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

create procedure dbo.sp_insert_tbl_ref_calendar as
set nocount on;
begin
	declare @calendar table(ref_date date not null);
	declare @dates_interim table(ref_date date,
								 month_name nvarchar(9),
								 day_name nvarchar(9),
								 day_rank nvarchar(5));
	declare @start_date date = datefromparts(year(getdate()), 01, 01);
	declare @end_date date = datefromparts(year(getdate()), 12, 31);
	declare @i int, @n int, @date date;

	set @i = 0;
	set @n = datediff(day, @start_date, @end_date);

	while @i <= @n
		begin
			/*With each iteration add the iteration number to start date.*/
			set @date = dateadd(day, @i, @start_date);
			insert into @calendar(ref_date)
				values(@date)
		set @i = @i + 1;
		end;
		
		insert into @dates_interim(ref_date, month_name, day_name, day_rank)
			select ref_date,
				   month_name,
				   day_name,
				   /*Calculate the rank of day names by months*/
				   dense_rank() over (partition by month_name, day_name order by ref_date, month_name, day_name) as day_rank2
			from (select ref_date, 
						/*Weekday name of reference date*/
						datename(weekday, ref_date) as day_name, 
						/*Month name of reference date*/
						datename(month, ref_date) month_name 
				  from @calendar) as t
				  order by ref_date;

	if object_id('sladb.dbo.tbl_ref_calendar') is not null
	/*The start date equals January 1 of the start_year*/
	begin transaction
		insert into sladb.dbo.tbl_ref_calendar(ref_date, month_name, day_name, day_rank)
			select ref_date,
				   month_name,
				   day_name,
				   /*Calculate the rank of day names by months*/
				   case when last_value(day_rank2) over (partition by month_name, day_name order by month_name, day_name) = day_rank2 then 'last'
						/*Otherwise cast the rank as its value*/
						else cast(day_rank2 as nvarchar(5)) 
				   end as day_rank
			from (select ref_date, 
						 /*Weekday name of reference date*/
						 datename(weekday, ref_date) as day_name, 
						 /*Month name of reference date*/
						 datename(month, ref_date) month_name 
				  from @calendar) as t
				  order by ref_date;
	commit;
end;

/*Take the highest value for the rank of the day names in each month and assign it a value of max*/
