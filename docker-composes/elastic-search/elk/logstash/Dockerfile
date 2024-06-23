ARG ELASTIC_VERSION

FROM docker.elastic.co/logstash/logstash:${ELASTIC_VERSION}

USER root
# Install unzip
RUN apt-get update && apt-get install -y unzip
# Download the PostgreSQL JDBC driver
RUN curl -L -o /usr/share/logstash/logstash-core/lib/jars/postgresql.jar \
    https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar
# Download the MongoDB JDBC driver
RUN curl -L -o /usr/share/logstash/logstash-core/lib/jars/mongodb.zip \
    https://dbschema.com/jdbc-drivers/MongoDbJdbcDriver.zip && \
    unzip /usr/share/logstash/logstash-core/lib/jars/mongodb.zip -d /usr/share/logstash/logstash-core/lib/jars/ && \
    rm /usr/share/logstash/logstash-core/lib/jars/mongodb.zip
USER logstash
# Add logstash plugins setup here if it is needed
# Example: RUN logstash-plugin install logstash-filter-json
RUN bin/logstash-plugin update
RUN #bin/logstash-plugin install logstash-output-mongodb
