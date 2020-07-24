/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management 																						   			          
 Created Date:  08/28/2019																							   
 Modified Date: 02/14/2020																							   
											       																	   
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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter procedure dbo.sp_i_tbl_ref_calendar as
set nocount on;
begin
	declare @calendar table(ref_date date not null);

	--declare @start_date date = datefromparts(year(getdate()), 01, 01);
	--declare @end_date date = datefromparts(year(getdate()), 12, 31);
	/*Set start_date equal to the maximum ref_date in tbl_ref_calendar or 01-01-2014 if the table is empty*/
	declare @start_date date = (select coalesce(dateadd(day, 1, max(ref_date)), datefromparts(2014, 01, 01)) from sladb.dbo.tbl_ref_calendar);
	/*Set the end_date equal to the current date plus 1 year.*/
	declare @end_date date = datefromparts(year(getdate()) + 1, 12, 31);
	declare @i int, @n int, @date date;

	set @i = 0;
	/*Calculate the difference in days between the start_date and end_date parameters.*/
	set @n = datediff(day, @start_date, @end_date);

	while @i <= @n
		begin
			/*Iterate through the start_date adding one day each time until reaching the difference between the start_date and
			  the end_date.*/
			set @date = dateadd(day, @i, @start_date);
			/*Insert the date as calculated directly above*/
			insert into @calendar(ref_date)
				values(@date)
		/*Increment parameter i*/
		set @i = @i + 1;
		end;
	
	if object_id('sladb.dbo.tbl_ref_calendar') is not null
	/*Insert the records from the table parameter into tbl_ref_calendar*/
	begin transaction
		insert into sladb.dbo.tbl_ref_calendar(ref_date)
			select ref_date
			from @calendar;
	commit;
end;
