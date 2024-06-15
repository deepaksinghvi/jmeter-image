FROM openjdk:11

MAINTAINER deepak.singhvi@gmail.com

ARG JMETER_VERSION="5.6.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin

RUN curl http://dlcdn.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /opt/apache-jmeter-${JMETER_VERSION}.tgz
RUN chmod -R 777 /opt/apache-jmeter-${JMETER_VERSION}.tgz 
RUN ls -ltr
RUN tar -xvf /opt/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/
RUN chmod -R 777 /opt/apache-jmeter-${JMETER_VERSION}/lib
RUN find /opt/apache-jmeter-${JMETER_VERSION}/lib -name "*.jar" -exec chmod 666 {} \;

ENV PATH $PATH:${JMETER_BIN}

RUN mkdir /app 
ADD . /app

WORKDIR	/app

RUN mkdir htmlreport
RUN mkdir csvreport

RUN chmod 777 /app/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
CMD ["https://raw.githubusercontent.com/deepaksinghvi/jmeter-one-off-dyno/main/test/jmeter_on_aws.jmx"]