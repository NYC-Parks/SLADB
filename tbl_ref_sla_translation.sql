/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  <MM/DD/YYYY>																							   
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
create table sladb.dbo.tbl_ref_sla_translation(sla_code int identity(1,1) primary key,
											   sla_in nvarchar(1) foreign key references sladb.dbo.tbl_ref_sla(sla_id),
											   sla_off nvarchar(1) foreign key references sladb.dbo.tbl_ref_sla(sla_id));

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