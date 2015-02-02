FROM mustardgrain/java8:latest

MAINTAINER Kirk True <kirk@mustardgrain.com>

CMD ["/sbin/my_init"]

ENV CASSANDRA_VERSION 2.1.2
ENV CASSANDRA_URL http://www.us.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
ENV CASSANDRA_HOME /opt/apache-cassandra-$CASSANDRA_VERSION

ENV AGENT_VERSION 5.0.2
ENV AGENT_URL http://downloads.datastax.com/community/datastax-agent-$AGENT_VERSION.tar.gz
ENV AGENT_HOME /opt/datastax-agent-$AGENT_VERSION

RUN cd /opt && /usr/bin/curl -L -s $CASSANDRA_URL | tar xz
RUN cd /opt && /usr/bin/curl -L -s $AGENT_URL | tar xz

COPY . /src

RUN cp /src/cassandra.yaml $CASSANDRA_HOME/conf

RUN	\
	mkdir -p /etc/service/cassandra && cp /src/cassandra-run /etc/service/cassandra/run; \
    mkdir -p /etc/service/agent && cp /src/agent-run /etc/service/agent/run

WORKDIR $CASSANDRA_HOME

EXPOSE 7000 7001 7199 9042 9160 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
