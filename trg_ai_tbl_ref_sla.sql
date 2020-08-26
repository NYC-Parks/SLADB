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

create or alter trigger dbo.trg_ai_tbl_ref_sla 
	on sladb.dbo.tbl_ref_sla
	after insert as
	begin
		/*Select and store the current identity value of tbl_ref_sla_code*/
		declare @sla_code int = (select ident_current('sladb.dbo.tbl_ref_sla_code'));

		/*Allow identity inserts into sladb.dbo.tbl_ref_sla_code*/
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
		
		/*Disallow identity inserts into sladb.dbo.tbl_ref_sla_code*/
		set identity_insert sladb.dbo.tbl_ref_sla_code off;

		if object_id('tempdb..#cross') is not null
			drop table #cross;

		/*Cross join the inserted records with all records in tbl_ref_sla, then cross join all the records in
		  tbl_ref_sla with the inserted records and union the results to deduplicate them.*/
		select *
		into #cross
		from(select l.sla_id, 
			 	    r.sla_id as sla_id2
			 from inserted as l
			 cross join
			 	  sladb.dbo.tbl_ref_sla as r
			 union
			 select l.sla_id, 
			 	    r.sla_id as sla_id1
			 from sladb.dbo.tbl_ref_sla as l
			 cross join
			 	  inserted as r) as u;

		begin transaction
			insert into sladb.dbo.tbl_ref_sla_translation(sla_id, date_category_id, sla_code)
				/*Cross join the results from above with the date_category_id table. Choose the sla_id when the date_category_id 
				  is 1 and flip and choose the sla_id2 if the date_category_id is 2. This table results in every combination of sla_id
				  and date_category_id.*/
				select case when r.date_category_id = 1 then l.sla_id
							else l.sla_id2
					   end as sla_id,
					   r.date_category_id,
					   /*Add the identity value from tbl_ref_sla_code before the inserts occurred to the row_number to get the 
					     correct sla_code.*/
					   row_number() over(partition by date_category_id order by date_category_id, sla_id) + @sla_code
				from #cross as l
				cross join
					  sladb.dbo.tbl_ref_sla_season_category as r
		commit;

	end;
