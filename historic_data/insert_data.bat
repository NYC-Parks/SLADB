sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\sp_i_tbl_unit_sla_season_historic.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_season_day_rank.sql

sqlcmd -S dpr-vdipm001 -E -Q "exec sladb.dbo.sp_insert_tbl_ref_calendar;"

sqlcmd -S dpr-vdipm001 -E -Q "exec sladb.dbo.sp_merge_ref_unit;"

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_season_category.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_season_date_type.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_translation.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_season_day_name.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_change_status.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_tbl_ref_sla_season_month_name.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_historic_seasons.sql

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\historic_data\insert_historic_change_requests.sql

sqlcmd -S dpr-vdipm001 -E -Q "exec sladb.dbo.sp_season_dates;"

sqlcmd -S dpr-vdipm001 -E -i C:\Projects\sladb\sp_i_tbl_unit_sla_season.sql

pause

