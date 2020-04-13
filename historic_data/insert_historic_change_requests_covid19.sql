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
select r.ava_primaryid as unit_id,
	   r.ava_from,
	   r.ava_to,
	   r.ava_changed,
	   r.ava_modifiedby
from (select aat_code,
			 aat_table
	  from [dataparks].eamprod.dbo.r5audattribs
	  where lower(aat_table) = 'r5objects' and 
		    lower(aat_column) = 'obj_udfchar02') as l
left join
	 [dataparks].eamprod.dbo.r5audvalues as r
on l.aat_table = r.ava_table and
   l.aat_code = r.ava_attribute
where ava_changed >= '2020-03-11'