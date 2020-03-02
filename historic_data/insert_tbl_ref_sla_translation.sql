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

begin transaction;
declare @sla_tab table(sla_id nvarchar(1),
					   date_category_id int,
					   sla_translation_id int,
					   row_id int identity(1,1));

insert into @sla_tab(sla_id, date_category_id)
	select sla_id, date_category_id
	from sladb.dbo.tbl_ref_sla
	cross join
		 sladb.dbo.tbl_ref_sla_season_category;

with combos as(
select l.*, 
	   r.sla_id as sla_id2,
	   row_number() over(partition by l.date_category_id order by l.date_category_id, l.sla_id) as sla_code
from @sla_tab as l
cross join
	 @sla_tab as r
where l.date_category_id != r.date_category_id)

	insert into sladb.dbo.tbl_ref_sla_translation(sla_id,
												  date_category_id,
												  sla_code)
		select case when date_category_id = 1 then sla_id
				else sla_id2
			end as sla_id,
		   date_category_id,
		   sla_code
	from combos;
commit;