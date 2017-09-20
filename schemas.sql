USE [Reports]
GO

--if schema_id('Warehouses') is null
--  exec('create schema Warehouses');
--Go

if schema_id('Reports') is null
  exec('create schema Reports');
Go

if schema_id('import_1c') is null
  exec('create schema import_1c');
Go

if schema_id('Monitor') is null
  exec('create schema Monitor');
Go
