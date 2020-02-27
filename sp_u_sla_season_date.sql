/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  02/25/2020																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
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
create or alter procedure dbo.sp_u_sla_season_date as
begin

	begin transaction;
		declare @season_updates table(season_id int,
									  effective_end_adj date);

		insert into @season_updates(season_id, effective_end_adj)
			select season_id,
				   effective_end_adj
			from sladb.dbo.tbl_sla_season
			where effective_end_adj = cast(getdate() as date);
		
		declare @season_date_updates table (season_id int,
										    season_date_id int);

		/*Insert values into the updates table.*/
		insert into @season_date_updates(season_id,
										 season_date_id)
			select l.season_id,
				   l.season_date_id
			from (select season_id,
						 season_date_id,
						 /*Calculate the maximum ending date in the season dates table*/
						 max(effective_start) over(partition by season_id order by season_id) as max_effective_start,
						 effective_start
					from sladb.dbo.tbl_sla_season_date) as l
			inner join
				@season_updates as r
			on l.season_id = r.season_id
			/*Filter to include only the rows where the date is equal to the maximum date, since this
				is the only row that should be updated.*/
			where l.effective_start = l.max_effective_start;

		update sladb.dbo.tbl_sla_season_date
				/*Set the ending equal to today and the adjusted ending date equal to the next closest Saturday.*/
			set effective_end = cast(getdate() as date)
				--effective_start_adj = sladb.dbo.fn_getdate(cast(getdate() as date), 0)
			from @updates as u
			where sladb.dbo.tbl_sla_season_date.season_date_id = u.season_date_id;
	commit;
end;