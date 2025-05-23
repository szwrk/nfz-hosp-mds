SET ECHO OFF;
--DELETE DM USERS
ALTER SESSION SET CONTAINER = datamart;
DROP ROLE dm_engineer;
DROP ROLE dm_analyst;
DROP USER dm_nfzhosp CASCADE;
DROP USER sysdm;
--DELETE CBD USERS
ALTER SESSION SET CONTAINER = cdb$root;
DROP USER c##jsmith;
DROP USER c##jdoe;
-- DROP XEPDB1 (DEFAULT PDB)
DECLARE
	var1 number;
BEGIN
	select count(*) into var1 from dba_pdbs where pdb_name = 'XEPDB1';
IF var1 = 1 THEN 
	EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE XEPDB1 CLOSE IMMEDIATE';
	EXECUTE IMMEDIATE 'DROP PLUGGABLE DATABASE XEPDB1 INCLUDING DATAFILES';
ELSE
	dbms_output.put_line('PDB XEPDB1 not exists, skipping deletion');
END IF;
end;
/
-- DROP DATAMART
DECLARE 
	var1 number;
BEGIN
	select count(*) into var1 from dba_pdbs where pdb_name = 'DATAMART';
IF var1 = 1 THEN 
	EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE DATAMART CLOSE IMMEDIATE';
	EXECUTE IMMEDIATE 'DROP PLUGGABLE DATABASE DATAMART INCLUDING DATAFILES';
ELSE
        dbms_output.put_line('PDB DATAMART not exists, skipping deletion');
END IF;
END;
/

EXIT;
