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
use sladb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter view dbo.vw_sla_current as
	select r.*
	from sladb.dbo.tbl_ref_unit as l
	left join
		 sladb.dbo.vw_sla_historic as r
	on l.unit_id = r.unit_id
	/*Only include the record that is currently effective, so seasonal records will show up with the SLA today OR show any units that are active
	  unit_status = I that have no assigned sla_id.*/ 
	where (cast(getdate() as date) between effective_start_adj and effective_end_adj) or
		  (r.sla_id is null and l.unit_status = 'I')