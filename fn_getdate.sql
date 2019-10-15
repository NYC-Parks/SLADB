/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																					   			          
 Created Date:  10/11/2019																							   
 Modified Date: 10/15/2019																								   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: sladb.dbo.tbl_ref_calendar																						   
 			  sladb.dbo.tbl_ref_sla_season_day_name																							   		
			  																				   
 Description: Create a function that chooses the next Saturday (End) or Sunday (Start) from a user input date. This is intended
			  to allow the database to insert r
																													   												
***********************************************************************************************************************/
use sladb
go
create function dbo.fn_getdate(@date date, @start bit)
	returns date
	/*Use execute permissions to call the function*/
	with execute as caller
	begin
	declare @adj_date date;
	if @start = 1
		set @adj_date = (select dateadd(day, ndays_sunday, ref_date)
					     from sladb.dbo.tbl_ref_calendar as l
					     left join
					   		  sladb.dbo.tbl_ref_sla_season_day_name as r
					     on l.day_name = r.season_day_name_desc
					     where ref_date = @date);

	if @start = 0
		set @adj_date = (select dateadd(day, ndays_saturday, ref_date)
					     from sladb.dbo.tbl_ref_calendar as l
					     left join
					   		  sladb.dbo.tbl_ref_sla_season_day_name as r
					     on l.day_name = r.season_day_name_desc
					     where ref_date = @date);
	return @adj_date;
	end;