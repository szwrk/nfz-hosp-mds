/* Create common user and roles */
-- Setup common users...

CREATE USER c##jsmith IDENTIFIED BY oracle;
CREATE USER c##jdoe IDENTIFIED BY oracle;

ALTER SESSION SET CONTAINER = datamart;

CREATE ROLE dm_engineer;
CREATE ROLE dm_analyst;

--tech datamart schema
GRANT CONNECT TO dm_nfzhosp; 
GRANT CREATE TABLE TO dm_nfzhosp; -- MV need it
GRANT CREATE ANY INDEX TO dm_nfzhosp;
GRANT CREATE MATERIALIZED view to dm_nfzhosp;
GRANT CREATE ANY SEQUENCE TO dm_nfzhosp;
GRANT CREATE ANY SYNONYM TO dm_nfzhosp;

--setup data engineer
GRANT CONNECT TO dm_engineer;
GRANT CREATE ANY TABLE TO dm_engineer;
GRANT CREATE ANY VIEW TO dm_engineer;
GRANT CREATE ANY MATERIALIZED VIEW TO dm_engineer;
GRANT ALTER SESSION TO dm_engineer;

GRANT CREATE TABLE TO dm_engineer;
GRANT CREATE ANY INDEX TO dm_engineer;
GRANT CREATE ANY SEQUENCE TO dm_engineer;
GRANT CREATE MATERIALIZED VIEW TO dm_engineer;
GRANT ALTER ANY TABLE TO dm_engineer;
GRANT CREATE ANY SYNONYM TO dm_engineer;
GRANT SELECT ANY TABLE TO dm_engineer;
GRANT SELECT ANY TABLE TO dm_engineer;
GRANT INSERT ANY TABLE TO dm_engineer;
GRANT UPDATE ANY TABLE TO dm_engineer;
GRANT DELETE ANY TABLE TO dm_engineer;
GRANT COMMENT ANY TABLE TO dm_engineer;
-- GRANT COMMENT ANY MATERIALIZED VIEW TO dm_engineer;

--setup data analyst
GRANT CONNECT TO dm_analyst;
GRANT CREATE VIEW TO dm_analyst;
GRANT CREATE MATERIALIZED VIEW TO dm_analyst;

-- add roles
GRANT dm_engineer TO c##jsmith;
GRANT dm_analyst TO c##jdoe;

ALTER USER c##jsmith DEFAULT ROLE dm_engineer;
ALTER USER c##jdoe DEFAULT ROLE dm_analyst;

ALTER USER c##jsmith QUOTA 5500M ON tbs_devdata;
ALTER USER c##jsmith QUOTA 5500M ON tbs_datamart;

ALTER USER c##jdoe QUOTA 500M ON tbs_devdata;

EXIT;
