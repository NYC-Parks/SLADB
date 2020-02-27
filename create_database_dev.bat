REM @echo off
REM Create the database
REM -------------------------------------------------------------------------
sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\db_create.sql

REM Run all the create table scripts for the SLADB reference tables that have
REM no foreign keys.
REM -------------------------------------------------------------------------
sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_change_status.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_category.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_date_type.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_day_name.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_day_rank.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_month_name.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_calendar.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_unit.sql

REM Create all of the functions.
REM -------------------------------------------------------------------------
sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\fn_getdate.sql

REM Run all the create table scripts for the SLADB reference tables that have
REM foreign keys.
REM -------------------------------------------------------------------------

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_sla_season.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_season_definition.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_code.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_ref_sla_translation.sql

REM Run all the create table scripts for the change request tables.
REM -------------------------------------------------------------------------

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_change_request.sql

REM sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_change_request_justification.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_change_request_status.sql

REM Run all the create table scripts for the sla and season tables.
REM -------------------------------------------------------------------------

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_sla_season_date.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_unit_sla_season.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\tbl_sla_season_change.sql


REM Run all the create view scripts.
REM -------------------------------------------------------------------------

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_ref_sla_season_definition.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_season_dates_adjusted.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_date_ref_fixed.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_date_ref_notfixed.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_sla_historic.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\vw_sla_code_pivot.sql



REM Create all of the stored procedures.
REM -------------------------------------------------------------------------
sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_insert_tbl_ref_calendar.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_merge_ref_unit.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_season_dates.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_insert_season.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_i_tbl_unit_sla_season_delay.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_u_tbl_sla_season.sql

REM Create all of the triggers.
REM -------------------------------------------------------------------------
sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_i_change_request.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_i_tbl_change_request_status.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_season_change.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_season_definition.sql

REM sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_sla_season_date_update.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_i_tbl_unit_sla_season.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_unit_decommissioned.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_i_tbl_ref_calendar.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_i_tbl_ref_sla.sql 

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\trg_u_tbl_sla_season.sql


REM Create the jobs
REM -------------------------------------------------------------------------
REM sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\job_tbl_ref_unit.sql

REM exit
pause