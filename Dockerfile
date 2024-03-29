FROM ubuntu:22.04 as build
LABEL maintainer="Jan-Hendrik Hausner <to.jan-hendrik.hausner@outlook.com>"
ARG ACTIVE_MQ_VERSION=5.17.3
RUN apt update && \
    apt install -y wget && \
    wget https://archive.apache.org/dist/activemq/$ACTIVE_MQ_VERSION/apache-activemq-$ACTIVE_MQ_VERSION-bin.tar.gz && \
    tar -xvzf apache-activemq-$ACTIVE_MQ_VERSION-bin.tar.gz && \
    mv apache-activemq-$ACTIVE_MQ_VERSION /opt/apache-activemq-$ACTIVE_MQ_VERSION
COPY activemq.xml /opt/apache-activemq-$ACTIVE_MQ_VERSION/conf

FROM openjdk:11.0.16
ENV ACTIVE_MQ_VERSION=5.17.3
ENV ACTIVE_MQ_USERNAME=test
ENV ACTIVE_MQ_PASSWORD=test
WORKDIR /opt/apache-activemq-$ACTIVE_MQ_VERSION
COPY --from=build /opt/apache-activemq-$ACTIVE_MQ_VERSION .
EXPOSE 8161
EXPOSE 61616
CMD ["/bin/sh", "-c", "echo \"${ACTIVE_MQ_USERNAME}: ${ACTIVE_MQ_PASSWORD}, admin\" > /opt/apache-activemq-${ACTIVE_MQ_VERSION}/conf/jetty-realm.properties && bin/activemq console -Djetty.host=0.0.0.0"]