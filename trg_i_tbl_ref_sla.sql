/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  02/26/2020																							   
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

create or alter trigger dbo.trg_i_tbl_ref_sla 
	on sladb.dbo.tbl_ref_sla
	after insert as
	begin
		/*Allow identity inserts*/
		set identity_insert sladb.dbo.tbl_ref_sla_code on;

		begin transaction
		insert into sladb.dbo.tbl_ref_sla_code(sla_code)
			/*Perform a cross join between the tbl_ref_sla table and itself. This should produce a table
			  with the squared number of rows of tbl_ref_sla. Use the rank function to assign the rank
			  of each row ordered by the left and right sla_ids.*/
			select row_number() over(order by l.sla_id, r.sla_id) as sla_code
			from sladb.dbo.tbl_ref_sla as l
			cross join
				 sladb.dbo.tbl_ref_sla as r
			/*Use except to filter out any duplicates that already exist.*/
			except
			select sla_code 
			from sladb.dbo.tbl_ref_sla_code
		commit;

		/*Allow identity inserts*/
		set identity_insert sladb.dbo.tbl_ref_sla_code off;
	end;
