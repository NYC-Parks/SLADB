sqlcmd -S . -E -i sp_i_tbl_unit_sla_season_historic.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_day_rank.sql

sqlcmd -S . -E -Q "exec sladb.dbo.sp_insert_tbl_ref_calendar;"

sqlcmd -S . -E -Q "exec sladb.dbo.sp_merge_ref_unit;"

sqlcmd -S . -E -i insert_tbl_ref_sla.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_category.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_date_type.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_translation.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_day_name.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_change_status.sql

sqlcmd -S . -E -i insert_tbl_ref_sla_season_month_name.sql

sqlcmd -S . -E -i insert_historic_seasons.sql

sqlcmd -S . -E -i insert_historic_change_requests.sql

sqlcmd -S . -E -Q "exec sladb.dbo.sp_season_dates"

sqlcmd -S . -E -Q "update_amps_inactive.sql"

sqlcmd -S . -E -Q "insert_missing_historic_change_requests.sql"

sqlcmd -S . -E -Q "insert_historic_change_requests_covid19.sql"

sqlcmd -S . -E -Q "exec sladb.dbo.sp_season_dates"

cd ..

sqlcmd -S . -E -i sp_i_tbl_unit_sla_season.sql

pause

