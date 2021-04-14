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

create or alter procedure dbo.usp_u_tbl_ref_unit as 

	/*Disable the for update trigger on the tbl_change_request table*/
	disable trigger dbo.trg_fu_tbl_change_request on dbo.tbl_change_request;

	begin transaction
		;with objupdates as(
		select r2.obj_code,
			   l.oup_oldcode/*,*/
			   /*If the record is in a valid obj_class and obj_type then flag it for updating
			   case when lower(r2.obj_class) in('park', 'plgd', 'zone', 'greenst') and lower(r2.obj_obtype) not in('c', 'i') then 1
					else 0
				end as row_update*/
		/*Join the table with the updated obj_codes (r5objectupdate) to the r5objects twice. Once based on the original obj_code (oup_oldcode) and
		  a second time based on the new obj_code (oup_newcode)*/
		from [dataparks].eamprod.dbo.r5objectupdate as l
		left join
			 [dataparks].eamprod.dbo.r5objects as r
		on l.oup_oldcode = r.obj_code
		left join
			[dataparks].eamprod.dbo.r5objects as r2
		on l.oup_newcode = r2.obj_code
		/*Only keep records where the old obj_code no longer exists in r5objects and the new obj_code exists in r5objects.*/
		where r.obj_code is null and
			  r2.obj_code is not null)

		/*Update the unit_id if it has been changed in AMPS*/
		update u
			set unit_id = s.obj_code
			from sladb.dbo.tbl_ref_unit as u
			inner join
				 objupdates as s
			on u.unit_id = s.oup_oldcode collate SQL_Latin1_General_CP1_CI_AS
	commit;

	/*Enable the for update trigger on the tbl_change_request table*/
	enable trigger dbo.trg_fu_tbl_change_request on dbo.tbl_change_request;

