/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management																						   			          
 Created Date:  08/19/2019																							   
 Modified Date: 10/15/2019																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: sladb.dbo.tbl_ref_sla																							   			
			  																				   
 Description: Create a translation table for SLAs that includes the in season and out of season SLAs. 									   
																													   												
***********************************************************************************************************************/
create table sladb.dbo.tbl_ref_sla_translation(sla_code int identity(1,1) primary key,
											   season_category_id foreign key references sladb.dbo.tbl_ref_sla_season_category(season_category_id),
											   sla nvarchar(1) foreign key references sladb.dbo.tbl_ref_sla(sla_id));

declare @sla_in nvarchar(1), @sla_off nvarchar(1), @nsla int, @i int, @j int;

declare @sla_tab table(sla_id nvarchar(1),
					   row_id int identity(1,1));

insert into @sla_tab(sla_id)
	select sla_id
	from sladb.dbo.tbl_ref_sla;

set @nsla = (select count(*) from @sla_tab);

set @i = 1;

while @i <= @nsla
	begin
		set @j = 1;
		set @sla_in = (select sla_id from @sla_tab where row_id = @i);

		while @j <= @nsla
			begin

				set @sla_off = (select sla_id from @sla_tab where row_id = @j);
				set @j = @j + 1;

				begin transaction
					insert into sladb.dbo.tbl_ref_sla_translation(sla_in, sla_off)
						values(@sla_in, @sla_off);
				commit;
				print @i;
				print @j;
		end;
		set @i = @i + 1;
	end;

--truncate table sladb.dbo.tbl_ref_sla_translation