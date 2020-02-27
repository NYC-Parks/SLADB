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

create or alter trigger dbo.trg_i_tbl_ref_sla 
	on sladb.dbo.tbl_ref_sla
	after insert as
	begin
		/*Select the count of records in the tbl_ref_sla table*/
		declare @n int = (select count(*) from sladb.dbo.tbl_ref_sla/*inserted*/);
		/*Get the current identity value of the tbl_ref_sla_code table*/
		declare @m int = (select ident_current('sladb.dbo.tbl_ref_sla_code'));

		/*Multiply the number of records in the tbl_ref_sla table by itself to get the number of records that should exist in tbl_ref_sla_code*/
		declare @i int = (select @n * @n);

		/*Calculate the difference between the current identity -1 and the number rows in the tbl_ref_sla table*/
		declare @d int = (select @i - (@m - 1));
		print @d
		
		--declare @j int, @k int, @l int;

		declare @k int = (select @m);

		if @d > 1
			begin
				while @m <= @d
					begin;
						/*Allow identity inserts*/
						set identity_insert sladb.dbo.tbl_ref_sla_code on;

						begin transaction
							insert into sladb.dbo.tbl_ref_sla_code(sla_code)
								values(@m);				
						commit;
						set @m = @m + 1;
					end;
			end;
	end;
