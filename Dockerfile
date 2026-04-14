FROM tomcat:9.0-jdk17-temurin

LABEL maintainer="ashok@oracle.com"

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

EXPOSE 8080

COPY target/maven-web-app.war /usr/local/tomcat/webapps/ROOT.war
