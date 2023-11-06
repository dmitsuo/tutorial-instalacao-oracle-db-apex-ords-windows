#!/bin/bash

# set -eux

# Geral
export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${APEX_ORDS_DIR}"
chmod +x *.sh

# JAVA
export JAVA_BASE_NAME="java-17"
export JAVA_HOME="$APEX_ORDS_DIR/$JAVA_BASE_NAME"
export JAVA_INSTALL_PACKAGE="OpenJDK17U-jre_x64_windows_hotspot_17.0.9_9.zip"

# ORDS
export ORDS_VERSION="23.3.0.289.1830"
export ORDS_BASE_NAME="ords-${ORDS_VERSION}"
export ORDS_HOME="$APEX_ORDS_DIR/$ORDS_BASE_NAME"
export ORDS_CONFIG="${APEX_ORDS_DIR}/ords-config"
export ORDS_INSTALL_PACKAGE="${ORDS_BASE_NAME}.zip"
mkdir -p "${ORDS_HOME}"
mkdir -p "${ORDS_CONFIG}"

# APEX
export APEX_VERSION="23.1"
export APEX_BASE_NAME="apex_${APEX_VERSION}"
export APEX_BASE_DIR="$APEX_ORDS_DIR/$APEX_BASE_NAME"
export APEX_INSTALL_PACKAGE="${APEX_BASE_NAME}.zip"
APEX_ADMIN_PWD="OracleApex_82"
# A tablespace abaixo pode ser substituida por outra que tenha sido criada especificamente para o APEX e ORDS
export APEX_TABLESPACE="SYSAUX"
mkdir -p "${APEX_BASE_DIR}"

# SQLcl
export SQLCL_HOME="$APEX_ORDS_DIR/sqlcl"
export SQLCL_INSTALL_PACKAGE="sqlcl-latest.zip"

# Database
export DB_INSTALL_PACKAGE_BASE_NAME="OracleXE213_Win64"
export DB_INSTALL_PACKAGE="${DB_INSTALL_PACKAGE_BASE_NAME}.zip"
export DB_INSTALL_TEMP_DIR="$APEX_ORDS_DIR/$DB_INSTALL_PACKAGE_BASE_NAME"
export DB_SERVER_IP="localhost"
export DB_SERVER_PORT="1521"
export DB_SERVER_SERVICE_NAME="xepdb1"
DB_SERVER_PWD="123"
DB_SERVER_APEX_USERS_PWD="123"
mkdir -p "${DB_INSTALL_TEMP_DIR}"

# Apache Tomcat
export TOMCAT_BASE_NAME="apache-tomcat-9.0.82"
export TOMCAT_INSTALL_PACKAGE="${TOMCAT_BASE_NAME}.zip"
export TOMCAT_HOME="${APEX_ORDS_DIR}/${TOMCAT_BASE_NAME}"

if ! [[ $PATH =~ (^|:)${SQLCL_HOME}/bin(:|$) ]]; then
  export PATH="${JAVA_HOME}/bin:${SQLCL_HOME}/bin:${ORDS_HOME}/bin:$PATH"
fi
