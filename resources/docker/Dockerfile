FROM tomcat:9.0.37-jdk8-adoptopenjdk-openj9

ENV APP_WAR saml2-web-app.war
ENV APP_NAME saml2-web-app

ENV WEB_APP_HOME /usr/local/tomcat/webapps

ARG TMP_DIR=/tmp

# install required packages
RUN apt-get update && \
    apt-get install \
    unzip \
    zip

COPY "$APP_WAR" "$TMP_DIR/"
COPY init.sh "$TMP_DIR/"
COPY web.xml "$TMP_DIR/"

RUN cd $TMP_DIR \
    && mkdir $APP_NAME \
    && unzip -q $APP_WAR -d $APP_NAME \
    && rm ${APP_WAR}

CMD ["bash", "-c", "source /tmp/init.sh"]
