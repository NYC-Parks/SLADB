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

create or alter procedure dbo.sp_insert_tbl_ref_calendar as
--alter procedure dbo.sp_insert_tbl_ref_calendar as
set nocount on;
begin
	declare @calendar table(ref_date date not null);

	declare @dates_interim table(ref_date date,
								 ref_year int,
								 month_name_desc nvarchar(9),
								 day_name_desc nvarchar(9),
								 day_rank_id nvarchar(5));

	--declare @start_date date = datefromparts(year(getdate()), 01, 01);
	--declare @end_date date = datefromparts(year(getdate()), 12, 31);
	declare @start_date date = datefromparts(2014, 01, 01);
	declare @end_date date = datefromparts(year(getdate()) + 1, 12, 31);
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
	
	if object_id('sladb.dbo.tbl_ref_calendar') is not null
	/*The start date equals January 1 of the start_year*/
	begin transaction
		insert into sladb.dbo.tbl_ref_calendar(ref_date)
			select ref_date
			from @calendar;
	commit;
end;
