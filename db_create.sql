/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  10/22/2019																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: SLADB	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: Create the database									   
																													   												
***********************************************************************************************************************/
use master;
go
create database sladb
on
(name = sladb_dat,
 filename = 'd:\sqldata\sladb.mdf',
 filegrowth = 10%)
log on
(name = sladb_log,
 filename = 'd:\tlogs\sladb_log.ldf',
 filegrowth = 10%);

/* use master
 go
 drop database sladb*/