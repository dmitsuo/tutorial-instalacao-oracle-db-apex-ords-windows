#!/bin/bash

# set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

echo "Fazendo os ajustes dos parametros do pool de conexoes do ORDS ..." 
sed -i "s# *<\\/properties> *#<entry key=\"jdbc.InitialLimit\">5</entry>\n</properties>#" "${ORDS_CONFIG}/databases/default/pool.xml"

sed -i "s# *<\\/properties> *#<entry key=\"jdbc.MaxLimit\">25</entry>\n</properties>#" "${ORDS_CONFIG}/databases/default/pool.xml"

echo "Desabilitando a nova landing page do ORDS v23+ devido a um bug conhecido que impede a execucao do APEX ..."
sed -i "s# *<\\/properties> *#<entry key=\"misc.defaultPage\">apex</entry>\n</properties>#" "${ORDS_CONFIG}/global/settings.xml"

echo "Ajustes no ORDS concluidos com sucesso!"

cat << EOF > "ords-fix-gateway-user.sql"

set define off

connect sys/${DB_SERVER_PWD}@//${DB_SERVER_IP}:${DB_SERVER_PORT}/${DB_SERVER_SERVICE_NAME} as sysdba

BEGIN
    ORDS_ADMIN.CONFIG_PLSQL_GATEWAY(
        p_runtime_user => 'ORDS_PUBLIC_USER',
        p_plsql_gateway_user => 'APEX_PUBLIC_USER'
    );
    commit;
END;
/

set define on

QUIT

EOF

cat << EOF > "ords-fix-gateway-user.bat"
@ECHO OFF

SET "CURDIR=%~dp0"

set "JAVA_HOME=%CURDIR%${JAVA_BASE_NAME}"
set "PATH=%JAVA_HOME%\bin;%CURDIR%\sqlcl\bin;%PATH%"

cd "%CURDIR%"

echo.
echo POR FAVOR, NAO FECHE ESTA JANELA. AGUARDE A CONCLUSAO DO PROCESSAMENTO ...

sql -S /nolog @"%CURDIR%ords-fix-gateway-user.sql"

exit

EOF

start "" "ords-fix-gateway-user.bat"


echo "Pressione qualquer tecla para continuar..."
read -n 1 -s

exit