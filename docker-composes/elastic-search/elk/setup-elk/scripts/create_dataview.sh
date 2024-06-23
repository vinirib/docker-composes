#!/bin/bash

echo "Creating data views..."
KIBANA_HOST="http://kibana:5601"
USER="sc"
PASSWORD="${ELASTIC_PASSWORD}"

# Data view details
DATA_VIEW_NAMES=("postgres.ad_login" "postgres.ad_application" "mongo.sc_login" "mongo.endpoint_access")
INDEX_PATTERNS=("postgres.ad_login*" "postgres.ad_application*" "mongo.sc_login*" "mongo.endpoint_access*")
TIME_FIELD="@timestamp"

# Wait for Kibana to start. This is a simple loop to wait for the Kibana server to respond.
while [[ "$(curl -s -o /dev/null -w '%{http_code}' -u $USER:$PASSWORD $KIBANA_HOST/api/status)" != "200" ]]; do
  echo "Waiting for Kibana to start..."
  sleep 5
done

for i in "${!DATA_VIEW_NAMES[@]}"; do
  curl -X POST "$KIBANA_HOST/api/index_patterns/index_pattern" \
       -H 'Content-Type: application/json' \
       -H 'kbn-xsrf: true' \
       -u $USER:$PASSWORD  \
       -d "{
    \"index_pattern\": {
      \"title\": \"${DATA_VIEW_NAMES[$i]}\",
      \"name\": \"${INDEX_PATTERNS[$i]}\",
      \"timeFieldName\": \"$TIME_FIELD\"
    }
  }" | jq .
done

echo "Data views created successfully."
