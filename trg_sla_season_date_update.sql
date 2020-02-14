/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  10/11/2019																							   
 Modified Date: 02/12/2020																							   
											       																	   
 Project: SLADB 	
 																							   
 Tables Used: inserted																						   
 			  sladb.dbo.tbl_change_request																								   		
			  																				   
 Description: Create a trigger to update the ending date of a season if it has its effective value set to 0  									   
																													   												
***********************************************************************************************************************/
use sladb
go
--drop trigger dbo.trg_sla_season_upsert
create trigger dbo.trg_sla_season_date_update
on sladb.dbo.tbl_sla_season
after update as

	begin transaction;
		/*Create a table to hold the updates.*/
		declare @updates table(season_id int,
							   season_date_id int);
		
		/*Insert values into the updates table.*/
		insert into @updates(season_id,
							 season_date_id)
			select l.season_id,
				   r.season_date_id
			from inserted as l
			left join
				 (select season_id,
						 season_date_id,
						 /*Calculate the maximum ending date in the season dates table*/
						 max(effective_start) over(partition by season_id order by season_id) as max_effective_start,
						 effective_start
				  from sladb.dbo.tbl_sla_season_date) as r
			on l.season_id = r.season_id
			/*Filter to include only the rows where the date is equal to the maximum date, since this
			  is the only row that should be updated.*/
			where r.effective_start = r.max_effective_start;

		update sladb.dbo.tbl_sla_season_date
				/*Set the ending equal to today and the adjusted ending date equal to the next closest Saturday.*/
			set effective_start = cast(getdate() as date)
				--effective_start_adj = sladb.dbo.fn_getdate(cast(getdate() as date), 0)
			from @updates as u
			where sladb.dbo.tbl_sla_season_date.season_date_id = u.season_date_id;

	commit;