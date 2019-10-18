/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management   																						   			          
 Created Date:  09/04/2019																							   
 Modified Date: 09/12/2019																							   
											       																	   
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
--drop trigger dbo.trg_season_definition
create trigger dbo.trg_season_definition
on sladb.dbo.tbl_sla_season
after insert as 
	begin
		declare @i int = 1, @n int, @year_round bit, @season_id int;

		declare @inserted table(row_id int identity(1,1),
								season_id int,
								year_round bit);

		declare @current table(row_id int identity(1,1),
							   season_id int,
							   year_round bit);


		insert into @inserted(season_id, year_round)
			select season_id,
				   year_round 
			from inserted;

		set @n = (select count(*) from @inserted);

		while @i <= @n
			begin
				set @year_round = (select year_round from @inserted where row_id = @i);
				set @season_id = (select season_id from @inserted where row_id = @i);

				/*If it is a year round season then insert values for January 1 and December 1*/
				if @year_round = 1
					begin
						begin transaction
							insert into tbl_ref_sla_season_definition(season_id, season_date_ref_fixed, season_date_month_name_desc, 
																	  season_date_ref_day_number, season_date_type_id)
								values(@season_id, cast(1 as bit), 'January', cast(1 as int), cast(1 as int)) /*Start Season value*/,
									  (@season_id, cast(1 as bit), 'December', cast(31 as int), cast(2 as int))/*End Season value*/;
						commit;
					end;

				set @i = @i + 1;
			end;

	end;