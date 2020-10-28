# Overview
Service Level Agreement Database

The intention of the Service Level Agreement Database (aka SLADB) is to provide a robust, mostly automated way to store and manage this important information. In its future state, this database would be tied to a frontend module of the Daily Tasks application where COO Focht and the Borough Administrators could more easily manage the service level agreement of a site.

Currently SLAs are managed inside of the Asset Management Parks System (AMPS). The values are changed manually for within the Prop/Fac/Feat screen on the frontend. In the database, the values are stored in a user-defined field (udf), obj_udfchar02, of the r5objects table for objects having an obj_class of “Property,” “Plgd”, “Zone” or “Greenst.” Historically, the management of SLAs hadn’t been a problem despite that changes needed to be implemented manually. However, the recent addition of seasonal SLAs that change multiple times per year would require a larger investment of time. Furthermore, the historic SLA values, prior to October 17 of 2019, are not retained in AMPS, so analysis and reporting arrive at incorrect conclusions.

For further details on the technical and business processes, please see the [wiki](https://github.com/NYCParks-data/SLADB/wiki) for this repository.
