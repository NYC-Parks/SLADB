/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management   																						   			          
 Created Date:  09/04/2019																							   
 Modified Date: 02/27/2020																							   
											       																	   
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
--drop trigger dbo.trg_season_definition
create or alter trigger dbo.trg_season_definition
on sladb.dbo.tbl_sla_season
after insert as 
	begin
	declare @tbl_ref_sla_season_definition table(season_date_ref_id int identity(1,1),
												 date_ref_fixed bit not null,
												 month_name_desc nvarchar(9) not null,
												 date_ref_day_number int null,
												 day_name_desc nvarchar(9) null,
												 day_rank_id nvarchar(5) null,
												 date_type_id int not null);

		insert into @tbl_ref_sla_season_definition(date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
			values(cast(1 as bit), 'January', cast(1 as int), cast(1 as int)) /*Start Season value*/,
				  (cast(1 as bit), 'December', cast(31 as int), cast(2 as int));

		begin transaction
		insert into sladb.dbo.tbl_ref_sla_season_definition(season_id, date_ref_fixed, month_name_desc, date_ref_day_number, date_type_id)
			select l.season_id,
				   r.date_ref_fixed, 
				   r.month_name_desc, 
				   r.date_ref_day_number, 
				   r.date_type_id
			from (select season_id
				  from inserted
				  where year_round = 1) as l
			cross join
				 @tbl_ref_sla_season_definition as r
			order by season_id, date_type_id;
		commit;
	end;