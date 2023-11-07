#!/bin/bash

# set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

cat << EOF > p.txt
${DB_SERVER_PWD}
${DB_SERVER_APEX_USERS_PWD}
EOF

cat << EOF > ords-install.bat
@ECHO OFF

SET CURDIR=%~dp0

set "JAVA_HOME=%CURDIR%${JAVA_BASE_NAME}"
set "ORDS_CONFIG=%CURDIR%ords-config"
set "ORDS_LOGS=%CURDIR%ords-logs"

%CURDIR%${ORDS_BASE_NAME}\bin\ords.exe install --log-folder %ORDS_LOGS% --admin-user "SYS AS SYSDBA" --proxy-user ^
--db-hostname "${DB_SERVER_IP}" --db-port "${DB_SERVER_PORT}" --db-servicename "${DB_SERVER_SERVICE_NAME}" --feature-sdw true ^
--proxy-user-tablespace "${APEX_TABLESPACE}" --proxy-user-temp-tablespace "TEMP" ^
--schema-tablespace "${APEX_TABLESPACE}" --schema-temp-tablespace "TEMP" --password-stdin < p.txt

echo.
echo ORDS instalado com sucesso!
echo.

pause

exit

EOF

start "" "ords-install.bat"

exit