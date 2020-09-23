##### Table of Contents
* [Overview](#Overview)
* [Tables](#Tables)
* [Views](#Views)
* [Functions](#Functions)
* [Stored Procedures](#Stored_Procedures)
* [Triggers](#Triggers)

# Overview
Service Level Agreement Database

The intention of the Service Level Agreement Database (aka SLADB) is to provide a robust, mostly automated way to store and manage this important information. In its future state, this database would be tied to a frontend module of the Daily Tasks application where COO Focht and the Borough Administrators could more easily manage the service level agreement of a site.

Currently SLAs are managed inside of the Asset Management Parks System (AMPS). The values are changed manually for within the Prop/Fac/Feat screen on the frontend. In the database, the values are stored in a user-defined field (udf), obj_udfchar02, of the r5objects table for objects having an obj_class of “Property,” “Plgd”, “Zone” or “Greenst.” Historically, the management of SLAs hadn’t been a problem despite that changes needed to be implemented manually. However, the recent addition of seasonal SLAs that change multiple times per year would require a larger investment of time. Furthermore, the historic SLA values, prior to October 17 of 2019, are not retained in AMPS, so analysis and reporting arrive at incorrect conclusions.

# Tables
## Reference Tables

**tbl_ref_calendar** - This table stores date values and their corresponding characteristics such as day of the week and day within the month that are used for translating dates from the tbl_ref_date_definition table.

**tbl_ref_sla** - This is table stores the alphabetic codes for SLAs, the corresponding descriptions and integer values representing the minimum and maximum number of days required to fulfill the SLA in a given week. Values in this table should generally remain unchanged, however, updates or additions may be made at the request of Legal, the Chief Operating Officer, First Deputy Commissioner or the Commissioner.

**tbl_ref_sla_change_status** - This table stores unique numeric codes and the corresponding description of the status. Values in this table should generally remain unchanged, however, updates to descriptions or additions may be made at the request of Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

**tbl_ref_sla_code** - This is table stores unique integer values that are used to preserve the cardinality between the date_category_id and the sla_code columns in the tbl_ref_season_transalation table.

**tbl_ref_season_category** - This table stores numeric codes and descriptions for the generalized periods for each season (ex: season or offseason). This table should generally remain unchanged.

**tbl_ref_sla_season_date_type** - This table stores unique numeric codes, the numeric code indicating the season category and descriptions for both the starting and ending periods for each season (ex: season or offseason). This table should generally remain unchanged.

**tbl_ref_sla_season_day_name** - This table stores the names and integer identifier for the days of the week and a column indicating how the day adjustments should be made when calculating intervals of time that start on Sunday and end on Saturday. This table will not change.

**tbl_ref_sla_season_day_rank** - This table stores alphanumeric codes for the rank of a day in a month (example: “The first Monday of the month.”) and description of the day rank. The day rank description is generic, but is intended to have values in curly brackets {} replaced in the front end. This table will not change.

**tbl_ref_sla_season_definition** - This table stores unique numeric codes, a season identifier and  information about how to compose dates for that particular season. Additions to this table may be made by a select group of users that include Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

**tbl_ref_sla_season_month_name** - This table stores the names and integer identifier for the months of the year. This table will not change.

**tbl_ref_sla_translation** - This table stores every combination of the alphabetic codes for SLAs (one for in-season and one for the offseason) from the tbl_ref_sla table as well as a new coded value representing each unique combination.  SLAs are now required to be represented by coded values because they may be seasonally adjusted. 

**tbl_ref_unit** - This table stores unique alphanumeric codes, the corresponding description and other important information about park units. The values in this table updated once a day through a merge (delta check) with the r5objects table in AMPS. Values in this table should generally remain unchanged, however, updates to descriptions, statuses or additions may be made at the request of Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

**tbl_ref_sla_season** - This table stores a unique numeric code for a season, a description of a season and a binary of whether the season is active. Values in this table should generally remain unchanged, however, updates to descriptions or additions may be made at the request of Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

## Data Tables

**tbl_sla_change_request** - This table stores a change request identification number, the alphanumeric code for a unit, a numeric code for the type of change being requested, a numeric code for the season change being requested (if applicable), the alphabetic code for the SLA change being requested (if applicable), a numeric code for the justification and a written justification that describes why an SLA should be changed. Values in this table can be updated or added through the frontend at the request a Borough Commissioner, Borough Chief, Deputy Chief or a Borough Analyst.

**tbl_sla_change_request_justification** - This table stores a change request identification number and description of the associated justification(s) that are required to make a decision about the status of a change request. Values in this table can be updated or added through the frontend at by a Borough Analyst.

**tbl_sla_change_request_status** - This table stores a change request identification number, the status of the change request status, the date stamp of the status change and the employee registration number (ERN) of the submitter. The status values in this table can be changed by specific individuals or groups which have been predetermined. For example, only the COO or FDC can approve a request.

**tbl_sla_season** - This table stores numeric codes and descriptions of SLA seasons as well as an indicator of whether the season record is still active. Values in this table can be updated or added through the frontend at the request of Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

**tbl_sla_season_change** - This table stores the numeric codes associated with an old and new season_id. It’s intended to allow users to deactivate an existing season, replace it with a new season and move all the records from the old season to the new season.

**tbl_sla_season_date** - This table stores numeric codes and descriptions of SLA seasons as well as an indicator of whether the season record is still active. Values in this table can be updated or added through the frontend at the request of Legal, the Chief Operating Office, First Deputy Commissioner or the Commissioner.

**tbl_unit_sla_season** - This table stores the alphanumeric code for a unit, the alphabetic code for the SLA, the numeric code for the season, the date when the record became active and a binary indicator of whether the record is the most current for a given site. Once a terminal change request status is reached in the tbl_sla_change_request_status table, updated records are inserted into this table. An example of a terminal status is “Approved.”

# Views

# Functions

**fn_getdate(@date, @start)** - This function calculates the date of next closest Saturday (end) to the input date if the @start value is 0 and the date of next closest Sunday (start) to the input date if the @start value is 1.

# Stored Procedures

# Triggers

**trg_change_request_status** - This insert trigger is implemented when a user submits an entry into the tbl_change_request table in order to track that the initial submission was made. It will always insert a value of 1 for the sla_change_status column.

**trg_season_change** - This insert trigger is implemented when an admin submits an entry to the tbl_sla_season_change table, which signifies the discontinuation of a season and the replacement with a new season. Existing units in tbl_unit_sla_season are updated to set effective equal to 0 and the effective_to date equal to the next closest Saturday. Additionally, a new entry is inserted for all the above records for these units with effective equal to 1 and effective_from date equal to the next closest Sunday, referencing the new season.

**trg_season_definition** - This insert trigger is implemented when an admin submits a new entry into the tbl_sla_season table. The trigger inserts two, one for the start of the season and one for the end of the season, records into the tbl_ref_season_definition table for year round seasons only. If these season is not year-round then the user must manually define the start and end dates of that season.

**trg_sla_season_date_update** - This update trigger is implemented when an admin discontinues an existing season in the tbl_sla_season table by setting the value of effective from 1 to 0. The trigger updates the effective_start in the tbl_sla_season_dates table to the current date and the date equal to the next closest Saturday of effective_to date. The trigger also updates the 

**trg_sla_season_upsert REPOINT THIS** - This insert trigger is implemented when a user inserts a new value equal to 2 (Approved) into the tbl_change_request_status table. If record exists for this unit in tbl_unit_sla_season, trigger will update the following for the existing record: value of the effective column to 0 and the value of the effective_to column to the next closest Saturday. It will also insert a new record into the tbl_unit_sla_season table for the newly approved SLA and Season combination for a given unit.

**trg_unit_decommissioned** - This update trigger is implemented when the unit_status in the tbl_ref_unit table changes from the value of ‘I’ to a value of ‘D’ signalling that it has been decommissioned in AMPS. The trigger updates the table tbl_unit_sla_season table and sets the value of effective to 0 and the value of effective_to equal to the date of next closest Saturday.
