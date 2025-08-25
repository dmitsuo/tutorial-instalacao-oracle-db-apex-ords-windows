#!/bin/bash

# set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

# Download JAVA JRE 17
echo
echo "Fazendo o download do Java JRE ..."
curl -L -k -o "$JAVA_INSTALL_PACKAGE" "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9.1/${JAVA_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Java JRE ..."
unzip -q "$JAVA_INSTALL_PACKAGE"
mv "jdk-17.0.9+9-jre" "$JAVA_HOME"

# Download SQLcl
echo
echo "Fazendo o download do Oracle SQLcl ..."
curl -L -k -o "$SQLCL_INSTALL_PACKAGE" "https://download.oracle.com/otn_software/java/sqldeveloper/${SQLCL_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Oracle SQLcl ..."
unzip -q "$SQLCL_INSTALL_PACKAGE"

# Download Oracle Database 21c XE
echo
echo "Fazendo o download do Oracle Database Express Edition (XE) ..."
curl -L -k -o "$DB_INSTALL_PACKAGE" "https://download.oracle.com/otn-pub/otn_software/db-express/${DB_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Oracle Database Express Edition (XE) ..."
unzip -q "${DB_INSTALL_PACKAGE}" -d "${DB_INSTALL_TEMP_DIR}"

# Download APEX 23.1
echo
echo "Fazendo o download do Oracle Application Express (APEX) ..."
curl -L -k -o "${APEX_INSTALL_PACKAGE}" "https://download.oracle.com/otn_software/apex/${APEX_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Oracle Application Express (APEX) ..."
unzip -q "${APEX_INSTALL_PACKAGE}" -d "${APEX_BASE_DIR}"

# Download ORDS 23.3
echo
echo "Fazendo o download do Oracle REST Data Services (ORDS) ..."
curl -L -k -o "${ORDS_INSTALL_PACKAGE}" "https://download.oracle.com/otn_software/java/ords/${ORDS_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Oracle REST Data Services (ORDS) ..."
unzip -q "${ORDS_INSTALL_PACKAGE}" -d "${ORDS_HOME}"

# Download Apache Tomcat 9
echo
echo "Fazendo o download do Apache Tomcat ..."
curl -L -k -o "${TOMCAT_INSTALL_PACKAGE}" "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/${TOMCAT_INSTALL_PACKAGE}"
echo "Descompactando o pacote de instalação do Apache Tomcat ..."
unzip -q "${TOMCAT_INSTALL_PACKAGE}"

echo 
echo "Copiando o arquivo \"ords.war\" e o diretorio de imagens do APEX para o diretorio [CATALINA_HOME]/webapps do Tomcat ..."
mv "${APEX_BASE_DIR}/apex/images" "${TOMCAT_HOME}/webapps/i"
cp "${ORDS_HOME}/ords.war" "${TOMCAT_HOME}/webapps/ords.war"

echo
echo "Adicionando as variaveis de ambiente do ORDS para o Tomcat ..."
ORDS_CONFIG_WIN="$(echo "$ORDS_CONFIG" | sed 's#^/\([a-z]\)\(.*\)#\1:\2#g')"
JAVA_HOME_WIN="$(echo "$JAVA_HOME" | sed 's#^/\([a-z]\)\(.*\)#\1:\2#g')"
echo "set \"JAVA_HOME=${JAVA_HOME_WIN}\"" > "$TOMCAT_HOME/bin/setenv.bat"
echo "set \"JAVA_OPTS=%JAVA_OPTS% -Dconfig.url=$ORDS_CONFIG_WIN\"" >> "$TOMCAT_HOME/bin/setenv.bat"

echo
echo "Todos os downloads foram concluídos com sucesso!"
echo

echo "Pressione qualquer tecla para continuar..."
read -n 1 -s

exit
