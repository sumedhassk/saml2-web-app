# Docker image for SAML SSO Sample for WSO2 Cloud

## Pre-Requisites
* Apache Maven 3.5+
* Docker

## Building Docker image
1. Build the sample application using maven. 
2. You will find the built web app in, `<SOURCE_ROOT>/target/saml-web-app.war` and copy it to `<SOURCE_ROOT>/resources/docker` directory
3. Got to `<SOURCE_ROOT>/resources/docker` and build the docker image
    
    ```
    docker build . -t sumedhassk/saml2-web-app:1.0.0
   ```
    
## Running the Docker image

1. Add the following host entry

    ```
    127.0.0.1 localhost.com
    ```

2. Run the docker image with following command

    ```
    docker run -p 8080:8080 -e TENANT_DOMAIN=<TENANT_DOMAIN> -e CONSUMER_KEY=<CONSUMER_KEY> -e CONSUMER_SECRET=<CONSUMER_SECRET> sumedhassk/saml2-web-app:1.0.0
    ```

    - Following are the environment variables that should be provided.
      
      TENANT_DOMAIN - Intended tenant domain (i.e where above configurations were added)

      CLIENT_ID - Consumer Key of the Application Created in API Store

      CLIENT_SECRET - Consumer Secret of the Application Created in API Store

      ***Note:*** If either of CLIENT_ID or CLIENT_SECRET is not provided SAML2 Grant will be disabled

3. Go to [http://localhost.com:8080/saml2-web-app](http://localhost.com:8080/saml2-web-app) to access the app
    
    