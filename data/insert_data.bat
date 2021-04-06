REM Execute the script to populate tbl_ref_sal_season_day_rank because tbl_ref_calendar is dependent

sqlcmd -S . -E -i insert_tbl_ref_sla_season_day_rank.sql


REM Execute the stored procedures to populate the tbl_ref_calendar and tbl_ref_unit tables

sqlcmd -S . -E -Q "exec sladb.dbo.sp_i_tbl_ref_calendar;"

sqlcmd -S . -E -Q "exec sladb.dbo.sp_m_tbl_ref_unit;"


REM Execute the scripts to populate the other reference tables

sqlcmd -S . -E -i insert_tbl_ref_sla_season_category.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_date_type.sql

sqlcmd -S . -E -i insert_tbl_ref_sla.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_day_name.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_change_status.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_month_name.sql


REM Populate tbl_sla_season with the historic seasons then execute the sp_season_dates proc

sqlcmd -S . -E -i insert_historic_seasons.sql

sqlcmd -S . -E -Q "exec sladb.dbo.sp_m_tbl_sla_season_date"


REM Update the validation script to bypass checking the unit_status column value

sqlcmd -S . -E -i sp_u_tbl_change_request.sql

sqlcmd -S . -E -i trg_fu_tbl_change_request.sql


REM Populate tbl_change_request with all historic change request, auto-approving them in order

REM sqlcmd -S . -E -i insert_tbl_change_request_historic_original.sql

REM sqlcmd -S . -E -i insert_tbl_change_request_historic_update.sql

REM sqlcmd -S . -E -i insert_tbl_change_request_historic_nypause1.sql

REM sqlcmd -S . -E -i insert_tbl_change_request_historic_nypause2.sql

REM sqlcmd -S . -E -i insert_tbl_change_request_historic_endnypause.sql

REM sqlcmd -S . -E -i update_tbl_change_request_status.sql

REM sqlcmd -S . -E -i update_tbl_unit_sla_season.sql

sqlcmd -S . -E -i insert_tbl_change_request.sql

sqlcmd -S . -E -i insert_tbl_change_request_status.sql

REM navigate a directory up

cd ..

REM Restore the proper logic for validation script

sqlcmd -S . -E -i sp_u_tbl_change_request.sql

sqlcmd -S . -E -i trg_fu_tbl_change_request.sql

pause

