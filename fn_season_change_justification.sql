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

create or alter function dbo.fn_season_change_justification(@old_season_id int, @new_season_id int)
	returns nvarchar(2000)
	/*Use execute permissions to call the function*/
	with execute as caller
	begin
		declare @justification nvarchar(2000);

		/*Create the justification message for tbl_change_request when migrating records from a discontinued season to a new season.*/
		set @justification = concat('All records with a season_id = ', 
									cast(@old_season_id as nvarchar),
									' were automatically moved to a new season with a season_id = ',
									cast(@new_season_id as nvarchar));
	return @justification;
	end;