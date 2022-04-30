FROM ubuntu:20.04 as build
ENV ACTIVE_MQ_VERSION=5.16.3
LABEL maintainer="Jan-Hendrik Hausner <to.jan-hendrik.hausner@outlook.com>"
RUN apt update && \
    apt install -y wget && \
    wget https://archive.apache.org/dist/activemq/$ACTIVE_MQ_VERSION/apache-activemq-$ACTIVE_MQ_VERSION-bin.tar.gz && \
    tar -xvzf apache-activemq-$ACTIVE_MQ_VERSION-bin.tar.gz && \
    mv apache-activemq-$ACTIVE_MQ_VERSION /opt/apache-activemq-$ACTIVE_MQ_VERSION
COPY activemq.xml /opt/apache-activemq-$ACTIVE_MQ_VERSION/conf
COPY jetty-realm.properties /opt/apache-activemq-$ACTIVE_MQ_VERSION/conf/jetty-realm.properties

FROM openjdk:11.0.14
ENV ACTIVE_MQ_VERSION=5.16.3
WORKDIR /opt/apache-activemq-$ACTIVE_MQ_VERSION
COPY --from=build /opt/apache-activemq-$ACTIVE_MQ_VERSION .
EXPOSE 8161
EXPOSE 61616
CMD ["/bin/sh", "-c", "bin/activemq console -Djetty.host=0.0.0.0"]