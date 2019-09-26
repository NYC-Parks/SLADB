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
use sladb go

create procedure dbo.sp_merge_ref_unit as

	if object_id('tempdb..#ampsunits') is not null
		drop table #ampsunits;

	select obj_code,
		   obj_desc,
		   obj_class,
		   obj_mrc,
		   obj_status,
		   obj_gisobjid,
		   obj_record,
		   obj_updated,
		   obj_withdraw
	into #ampsunits
	from [data.nycdpr.parks.nycnet].eamprod.dbo.r5objects
	where lower(obj_class) in('park', 'plgd', 'zone', 'greenst') and
		  lower(obj_obtype) not in('c', 'i')


	merge sladb.dbo.tbl_ref_unit as t 
		using #ampsunits as s
	on (t.unit_id = s.obj_code)
	when matched and t.unit_updated != s.obj_updated and t.unit_status != s.obj_status
		then update set t.unit_updated = s.obj_updated,
						t.unit_withdraw = s.obj_withdraw,
						t.unit_status = s.obj_status
	when not matched by t
		then insert(unit_id, unit_class, unit_mrc, unit_status, gisobjid, unit_record, unit_updated, unit_withdraw)
			values(s.obj_code, s.obj_desc, s.obj_class, s.obj_mrc, s.obj_status, s.obj_gisobjid, s.obj_record, s.obj_updated, s.obj_withdraw);



begin transaction
insert into sladb.dbo.tbl_ref_unit(unit_id,
								   unit_desc,
								   unit_class,
								   unit_mrc,
								   unit_status,
								   gisobjid,
								   unit_record,
								   unit_updated,
								   unit_withdraw)


commit;
