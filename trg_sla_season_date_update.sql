/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management    																						   			          
 Created Date:  10/11/2019																							   
 Modified Date: 10/15/2019																							   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: inserted																						   
 			  sladb.dbo.tbl_change_request																								   		
			  																				   
 Description: Create a trigger  									   
																													   												
***********************************************************************************************************************/
use sladb
go
--drop trigger dbo.trg_sla_season_upsert
create trigger dbo.trg_sla_season_date_update
on sladb.dbo.tbl_sla_season
after update as

	begin transaction;
		select l.season_id
		from inserted as l
		left join
			 (select season_id, date_start
			  from sladb.dbo.tbl_sla_season_date
			  group by season_id
			  having max(date_start)) as r
		on l.season_id = r.season_id

		

	commit;