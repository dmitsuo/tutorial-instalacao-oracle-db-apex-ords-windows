#!/bin/bash

# set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

start "" "$DB_INSTALL_PACKAGE_BASE_NAME\setup.exe"

exit
