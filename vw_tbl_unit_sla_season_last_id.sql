/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: SLADB																						   			          
 Created Date:  03/03/2020																							   
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

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter view dbo.vw_tbl_unit_sla_season_last_id as
	select unit_id, 
		   sla_season_id,
		   effective_start,
		   /*Rank the records for each unit that have a record with a value effective = 1. Units with more
		     than one record with effective = 1 will be assigned sequential values from 1 to the number of records.*/
		   rank() over(partition by unit_id order by effective_start desc) as row_rank,
		   /*Count the number of records for each unit that have record with a value effective = 1. Units with more
		     than one record with effective = 1 will have a value greater than 1.*/
		   count(*) over(partition by unit_id order by unit_id) as n
	from sladb.dbo.tbl_unit_sla_season
	/*Only include records with a value of effective = 1*/
	where effective = 1;