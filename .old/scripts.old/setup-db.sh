#!/bin/bash
# set -x
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "LOAD VARIABLES..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
source ./env.sh
# End Tests
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
echo "DROP DATAMART..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sql -S $DBA_NAME@$DB_TNS_CDB as sysdba<<EOF
$DBA_PASS
@drop
exit
EOF

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "SETUP PDB DATAMART..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sql -S $DBA_NAME@$DB_TNS_CDB as sysdba<<EOF
$DBA_PASS
DEFINE DATA_PATH='$DATA_PATH';
DEFINE DB_HOST='$DB_HOST';
DEFINE ADMIN_NAME='$ADMIN_NAME';
DEFINE ADMIN_PASS='$ADMIN_PASS';
DEFINE DB_TNS_CDB='$DB_TNS_CDB';
DEFINE DB_TNS_PDB='$DB_TNS_PDB';
@setup-db
exit
EOF

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "SETUP USERS..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sql -S $DBA_NAME@$DB_TNS_CDB as sysdba<<EOF
$DBA_PASS
@setup-users
exit
EOF

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "DONE"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
