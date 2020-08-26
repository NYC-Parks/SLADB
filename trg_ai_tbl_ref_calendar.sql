/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  02/14/2020																							   
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
use sladb;
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter trigger dbo.trg_ai_tbl_ref_calendar
	on sladb.dbo.tbl_ref_calendar
	after insert as
	begin
		/*The start date equals January 1 of the start_year*/
		begin transaction
			update u
				/*Set the day rank of the given day name within the month and year. Example: The last Monday of May.*/
				set u.day_rank_id = s.day_rank_id
							/*The last value function returns the day rank (day_rank_id) for the last year (ref_year), month (month_name_desc) and day name 
							 (day_name_desc). In other words it returns the maximum rank of the day within the current month and year. If this value is 
							 equivalent to the rank of the day name within each partition based on year (ref_year), month (month_name_desc) and 
						     day name (day_name_desc) then set the value equal to "last". In other words the value is set to represent the last Xday 
							 of the month and year. Otherwise, retain the current integer rank and convert the data type to nvarchar.*/
				from(select case when last_value(t.day_rank_id) over (partition by t.ref_year, t.month_name_desc, t.day_name_desc order by t.ref_year, t.month_name_desc, t.day_name_desc) = t.day_rank_id then 'last'
									/*Otherwise cast the rank as its value*/
									else cast(t.day_rank_id as nvarchar(5))
							end as day_rank_id,
							ref_date
					 from (select ref_date,
								  ref_year,
								  month_name_desc,
								  day_name_desc,
								  /*Calculate the rank of the day name within each partition based on year (ref_year), month (month_name_desc) and 
								    day name (day_name_desc).*/
								  dense_rank() over (partition by ref_year, month_name_desc, day_name_desc order by ref_date, ref_year, month_name_desc, day_name_desc) as day_rank_id
						   from inserted) as t) as s
				inner join
					 sladb.dbo.tbl_ref_calendar u
				/*Perform the join based on the reference date.*/
				on s.ref_date = u.ref_date
		commit;
	end;