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
select *
from sladb.dbo.tbl_change_request
where season_id = 10

select * 
from sladb.dbo.tbl_unit_sla_season
where unit_id in('Q371', 'Q371-01')

select *
from sladb.dbo.vw_unit_sla_season_unassigned
where unit_class = 'PLGD'

select *
from sladb.dbo.vw_sla_code_pivot

select *
from sladb.dbo.tbl_sla_season

begin transaction
	insert into sladb.dbo.tbl_change_request(unit_id, sla_code, season_id, effective_start, change_request_justification)
		  /*Should succeed*/
	values('R046-05', 1, 6, '2020-08-02', 'Testing SLA, Season Assignment procs.'),
		  /*Should have change request status of 4 = invalid, invalid SLA*/
		  ('R046-01', 2, 6, '2020-08-02', 'Testing SLA, Season Assignment procs.'),
		  /*Should have change request status of 4 = invalid, ineffective season*/
		  --('Q104-02', 1, 1, '2020-08-02', 'Testing SLA, Season Assignment procs.'),
		  /*Should succeed*/
		  ('R016-01', 1, 6, '2020-08-02', 'Testing SLA, Season Assignment procs.')
commit;
/*Error in TRIGGER!!!*/
--Msg 3609, Level 16, State 1, Line 39
--The transaction ended in the trigger. The batch has been aborted.
select *
from sladb.dbo.tbl_change_request
where change_request_id > 166636

select *
from sladb.dbo.tbl_change_request_status
where change_request_id > 166636

begin transaction
	insert into sladb.dbo.tbl_change_request_status(change_request_id, sla_change_status, status_user)
		values(166640, 2, '1549482'),
		      (166642, 2, '1549482')
commit;

