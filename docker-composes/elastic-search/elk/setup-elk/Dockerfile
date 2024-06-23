ARG ELASTIC_VERSION

# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}
USER root
RUN apt-get update && apt-get install -y jq
USER elasticsearch
COPY ./scripts/create_dataview.sh /opt/elasticsearch/scripts/create_dataview.sh
ENTRYPOINT ["/entrypoint.sh"]
