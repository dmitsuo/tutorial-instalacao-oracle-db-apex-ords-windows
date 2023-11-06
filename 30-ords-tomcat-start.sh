#!/bin/bash

# set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

cat << EOF > ords-tomcat-start.bat
@ECHO OFF

SET "CURDIR=%~dp0"
SET "CATALINA_HOME=%CURDIR%${TOMCAT_BASE_NAME}"

call "%CATALINA_HOME%\bin\startup.bat"

exit

EOF

start "" "ords-tomcat-start.bat"

exit