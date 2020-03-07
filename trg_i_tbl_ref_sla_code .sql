/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  03/06/2020																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: sladb	
 																							   
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

create or alter trigger dbo.trg_i_tbl_ref_sla_code 
	on sladb.dbo.tbl_ref_sla_code
	after insert as
	begin
		with a as(select date_category_id, sla_code
		from sladb.dbo.tbl_ref_sla_season_category
		cross join
			 sladb.dbo.tbl_ref_sla_code)
		
		select *
		from (select sla_id,
					 row_number() over(order by sla_id) as rownum
			  from sladb.dbo.tbl_ref_sla) as l
		left join
			a as r
		on r.sla_code % l.rownum = 0

	end;