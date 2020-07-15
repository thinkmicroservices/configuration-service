# grab the base image
FROM openjdk:8-jdk-alpine

# install curl
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*

# create a working volume in tmp
VOLUME /tmp

#define the jar dependency files
ARG DEPENDENCY=target/dependency

COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
EXPOSE 8888
EXPOSE 8089

#ENTRYPOINT ["java","-cp","app:app/lib/*","com.thinkmicroservices.ri.spring.config.ConfigurationService",\
#"-Dcom.sun.management.jmxremote", \
#"-Dcom.sun.management.jmxremote.port=9010", \
#"-Dcom.sun.management.jmxremote.local.only=false", \
#"-Dcom.sun.management.jmxremote.authenticate=false", \
#"-Dcom.sun.management.jmxremote.ssl=false"]
ENTRYPOINT ["java",
 "-Djava.rmi.server.hostname=127.0.0.1",
"-Dcom.sun.management.jmxremote.port=8089",
"-Dcom.sun.management.jmxremote.rmi.port=8089",
"-Dcom.sun.management.jmxremote.ssl=false",
"-Dcom.sun.management.jmxremote.authenticate=false",
"-cp","app:app/lib/*",
"com.thinkmicroservices.ri.spring.config.ConfigurationService"]
 