FROM tomcat:9.0-jdk17

LABEL maintainer="ashok@oracle.com"

EXPOSE 8080

COPY target/maven-web-app.war /usr/local/tomcat/webapps/ROOT.war
