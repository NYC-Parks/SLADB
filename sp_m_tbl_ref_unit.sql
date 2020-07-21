/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management  																					   			          
 Created Date:  09/20/2019																							   
 Modified Date: 03/02/2020																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: eamprod.dbo.r5objects																							   
 			  sladb.dbo.tbl_ref_unit																							   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
use sladb 
go

create or alter procedure dbo.sp_m_tbl_ref_unit as
	begin transaction;
		with ampsunits as(
		select obj_code collate SQL_Latin1_General_CP1_CI_AS as obj_code,
			   obj_desc,
			   obj_class,
			   obj_mrc,
			   obj_status,
			   obj_gisobjid,
			   obj_commiss,
			   obj_updated,
			   obj_withdraw
		from [dataparks].eamprod.dbo.r5objects
		where lower(obj_class) in('park', 'plgd', 'zone', 'greenst') and
			  lower(obj_obtype) not in('c', 'i'))

	merge sladb.dbo.tbl_ref_unit as tgt using ampsunits as src
	on (tgt.unit_id = src.obj_code)
	when matched and tgt.unit_updated != src.obj_updated
		then update set unit_desc = src.obj_desc,
						unit_class = src.obj_class,
						unit_mrc = src.obj_mrc,
						unit_status = src.obj_status,
						gisobjid = src.obj_gisobjid,
						unit_updated = src.obj_updated,
						unit_withdraw = src.obj_withdraw

	when not matched by target
		then insert(unit_id, unit_desc, unit_class, unit_mrc, unit_status, gisobjid, unit_commiss, unit_updated, unit_withdraw)
			values(src.obj_code, src.obj_desc, src.obj_class, src.obj_mrc, src.obj_status, src.obj_gisobjid, src.obj_commiss, 
				   src.obj_updated, src.obj_withdraw);

	commit;

