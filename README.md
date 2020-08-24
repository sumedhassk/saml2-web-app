# SAML SSO Sample for WSO2 Cloud

This is a sample web application which can be used to demonstrate;
1. SAML SSO Login/ Logout
2. [SAML Extension Grant](https://docs.wso2.com/display/APICloud/SAML+Extension+Grant)

## Pre-Requisites
* Apache Maven 3.5+
* [Apache Tomcat 9.x.x](https://tomcat.apache.org/download-90.cgi)

## How to set up the sample

### Create an OAuth2 Application in API Store
1. Login to API Store of the particular tenant and create an Application **with SAML Grant enabled**

### Configuring Service Provider in Identity Cloud
1. Login to the particular tenant where the Sample needs to be setup
2. Download [`resources/saml2-web-app.xml`](resources/saml2-web-app.xml) file and create a Service Provider in
 Identity Cloud by importing the xml file

### Configuring Identity Provider in Key Manager
1. Login to Key Manager as tenant (tenant admin preferred)
2. Download the public certificate of the tenant ([How to](https://docs.wso2.com/display/APICloud/FAQ#FAQ-HowcanIdownloadthePublicCertificateofthekeyusedtosigntheJWTTokensenttothebackendinAPICloud?))
3. Export the above certificate to a pem format

    ```openssl x509 -inform der -in <tenant>.cert -out <tenant>.pem```
4. Add a new Identity Provider with the following details;
    - Identity Provider Name: `IDENTITY_CLOUD`
    - Choose IDP certificate type: Upload IDP certificate, use the above exported certificate (i.e `<tenant>.pem`)
    - Claim Configuration --> Basic Claim Configuration --> User ID Claim URI: Select `http://wso2.org/claims/emailaddress` 
    - Federated Authenticators --> SAML2 Web SSO Configuration
        - Enable SAML2 Web SSO
        - Service Provider Entity ID: `saml2-web-app`
        - Identity Provider Entity ID: `identity.cloud.wso2.com`
        - SSO URL: `https://identity.cloud.wso2.com/samlsso`
        - Enable Authentication Request Signing
        - Enable Assertion Signing
        - SAML2 Web SSO User ID Location: `User ID found among claims`

### Deploying the application to a local Tomcat Server
1. Open [sso.properties](src/main/resources/sso.properties) file and add the following configurations
    - `OAuth2.ClientId`: Consumer Key of the Application Created in API Store
    - `OAuth2.ClientSecret`: Consumer Secret of the Application Created in API Store
    - `SAML2.SPEntityId`: `saml2-web-app@<ADD_THE_TENANT_DOMAIN>`
2. Build the sample using maven. You will find the final web app in, `target/saml-web-app.war`
3. Download Apache Tomcat Server and copy the above war file into `<TOMCAT_HOME>/webapps` directory and start tomcat
 server
4. Add the following host entry

   ```127.0.0.1 localhost.com```
   
5. Go to [http://localhost.com:8080/saml2-web-app](http://localhost.com:8080/saml2-web-app) to access the app

### Running as a docker image

To build the docker image from scratch, refer [How to build docker image](resources/docker/README.md)

1. Add the following host entry

    ```
    127.0.0.1 localhost.com
    ```

2. Run the docker image with following command

    ```
    docker run -p 8080:8080 -e TENANT_DOMAIN=<TENANT_DOMAIN> -e CLIENT_ID=<CLIENT_ID> -e CLIENT_SECRET=<CLIENT_SECRET> sumedhassk/saml2-web-app:1.0.0
    ```

    * Following are the environment variables that should be provided.
      
      `TENANT_DOMAIN` - Intended tenant domain (i.e where above configurations were added)

      `CLIENT_ID` - Consumer Key of the Application Created in API Store

      `CLIENT_SECRET` - Consumer Secret of the Application Created in API Store

      ***Note:*** If either of CLIENT_ID or CLIENT_SECRET is not provided SAML2 Grant will be disabled

3. Go to [http://localhost.com:8080/saml2-web-app](http://localhost.com:8080/saml2-web-app) to access the app