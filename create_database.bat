REM @echo off

REM The sqlcmd -S . tells the script to use the local server. This should allow
REM the script to be server agnostic.

REM Create the database and permissions
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i db_create.sql

sqlcmd -S . -E -i db_permissions.sql


REM Run all the create table scripts for the SLADB reference tables that have
REM no foreign keys.
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i tbl_ref_sla.sql

sqlcmd -S . -E -i tbl_ref_sla_change_status.sql

sqlcmd -S . -E -i tbl_ref_sla_season_category.sql

sqlcmd -S . -E -i tbl_ref_sla_season_date_type.sql

sqlcmd -S . -E -i tbl_ref_sla_season_day_name.sql

sqlcmd -S . -E -i tbl_ref_sla_season_day_rank.sql

sqlcmd -S . -E -i tbl_ref_sla_season_month_name.sql

sqlcmd -S . -E -i tbl_ref_calendar.sql

sqlcmd -S . -E -i tbl_ref_unit.sql

REM Create most of the functions.
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i fn_getdate.sql

sqlcmd -S . -E -i fn_month_maxdays.sql

sqlcmd -S . -E -i fn_season_change_justification.sql


REM Run all the create table scripts for the SLADB reference tables that have
REM foreign keys.
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i tbl_sla_season.sql

sqlcmd -S . -E -i tbl_ref_sla_season_definition.sql

sqlcmd -S . -E -i tbl_ref_sla_code.sql

sqlcmd -S . -E -i tbl_ref_sla_translation.sql


REM Run all the create table scripts for the change request tables.
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i tbl_change_request.sql

sqlcmd -S . -E -i tbl_change_request_status.sql


REM Run all the create table scripts for the sla and season tables.
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i tbl_sla_season_date.sql

sqlcmd -S . -E -i tbl_unit_sla_season.sql

sqlcmd -S . -E -i tbl_sla_season_change.sql


REM Run all the create view scripts.
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i vw_sla_historic.sql

sqlcmd -S . -E -i vw_sla_code_pivot.sql

sqlcmd -S . -E -i vw_unit_sla_season_unassigned.sql

sqlcmd -S . -E -i vw_unit_sla_season_last_id.sql

sqlcmd -S . -E -i vw_delayed_change_request.sql


REM Run scripts to create additional functions
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i fn_sla_code_valid.sql


REM Create all of the stored procedures.
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i sp_i_tbl_ref_calendar.sql

sqlcmd -S . -E -i sp_m_tbl_ref_unit.sql

sqlcmd -S . -E -i sp_m_tbl_sla_season_date.sql

sqlcmd -S . -E -i sp_u_tbl_change_request.sql

sqlcmd -S . -E -i sp_i_tbl_unit_sla_season.sql

sqlcmd -S . -E -i sp_u_tbl_sla_season.sql

sqlcmd -S . -E -i sp_u_tbl_unit_sla_season.sql

sqlcmd -S . -E -i sp_insert_change_request.sql

sqlcmd -S . -E -i sp_insert_season.sql


REM Create all of the triggers.
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i trg_ai_tbl_change_request.sql

sqlcmd -S . -E -i trg_fu_tbl_change_request.sql

sqlcmd -S . -E -i trg_ii_tbl_change_request.sql

sqlcmd -S . -E -i trg_ai_tbl_change_request_status.sql

sqlcmd -S . -E -i trg_ai_tbl_sla_season_change.sql

sqlcmd -S . -E -i trg_ai_tbl_unit_sla_season.sql

sqlcmd -S . -E -i trg_fu_tbl_unit_sla_season.sql

sqlcmd -S . -E -i trg_au_tbl_ref_unit.sql

sqlcmd -S . -E -i trg_ai_tbl_ref_calendar.sql

sqlcmd -S . -E -i trg_ai_tbl_ref_sla.sql 

sqlcmd -S . -E -i trg_ai_tbl_sla_season.sql

sqlcmd -S . -E -i trg_fu_tbl_sla_season.sql

sqlcmd -S . -E -i trg_ii_tbl_ref_sla_season_definition.sql


REM Create the jobs
REM -------------------------------------------------------------------------
REM sqlcmd -S . -E -i job_sladb.sql

REM Create the app tables
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i tbl_ref_app_perms.sql

sqlcmd -S . -E -i tbl_ref_app_sla_change_status_perms.sql


REM Create the app stored procedures
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i sp_app_insert_change_request.sql

sqlcmd -S . -E -i sp_app_update_change_request.sql

sqlcmd -S . -E -i sp_app_get_change_requests.sql

sqlcmd -S . -E -i sp_app_get_season_id.sql

sqlcmd -S . -E -i sp_app_get_sla_code.sql


REM Navigate to the folder with the data and run the batch file
REM -------------------------------------------------------------------------
cd data
call insert_data.bat

pause