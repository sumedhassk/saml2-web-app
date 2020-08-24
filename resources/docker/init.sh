#!/bin/bash

cNone='\033[00m'
cRed='\033[01;31m'
cGreen='\033[00;32m'
cYellow='\033[01;33m'
cBlue='\033[01;34m'
cCyan='\033[01;36m'
cBold='\033[1m'

cd /tmp/

if [[ -n "${TENANT_DOMAIN}" ]]; then
  echo -e "${cBold}[${cBlue}INFO${cNone}${cBold}]${cNone} Using Tenant Domain: ${TENANT_DOMAIN}"
  sed -i "s/TENANT_DOMAIN/${TENANT_DOMAIN}/g" ${APP_NAME}/WEB-INF/classes/sso.properties
else
  sed -i "s/TENANT_DOMAIN//g" ${APP_NAME}/WEB-INF/classes/sso.properties
fi

if [[ -n "${CONSUMER_KEY}"  &&  -n "${CONSUMER_SECRET}" ]]; then
  echo -e "${cBold}[${cBlue}INFO${cNone}${cBold}]${cNone} Using CONSUMER KEY: ${CONSUMER_KEY}"
  sed -i "s/CONSUMER_KEY/${CONSUMER_KEY}/g" ${APP_NAME}/WEB-INF/classes/sso.properties
  sed -i "s/CONSUMER_SECRET/${CONSUMER_SECRET}/g" ${APP_NAME}/WEB-INF/classes/sso.properties
else
  echo -e "${cBold}[${cYellow}*** WARNING ***${cNone}${cBold}]${cNone} CONSUMER_KEY or CONSUMER_SECRET is not set. Hence SAML2 Grant will be disabled"
  cp web.xml ${APP_NAME}/WEB-INF/
fi

cd ${APP_NAME}/ ; zip -q -r ../${APP_WAR} . * ; cd ..
cp ${APP_WAR} ${WEB_APP_HOME}/

#start Tomcat
/usr/local/tomcat/bin/catalina.sh run
