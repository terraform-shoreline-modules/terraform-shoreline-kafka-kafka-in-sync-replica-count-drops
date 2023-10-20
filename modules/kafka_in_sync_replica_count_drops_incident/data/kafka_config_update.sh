

#!/bin/bash



# Set the necessary parameters

BROKER_HOST=${BROKER_HOST}

BROKER_PORT=${BROKER_PORT}

TOPIC_NAME=${TOPIC_NAME}

MAX_WAIT_TIME=${MAX_WAIT_TIME}



# Increase the replica fetch maximum wait time

echo "Increasing the replica fetch maximum wait time to ${MAX_WAIT_TIME}ms..."

kafka-configs.sh --zookeeper ${ZOOKEEPER_SERVER}  --entity-type topics --entity-name ${TOPIC_NAME} --alter --add-config replica.fetch.wait.max.ms=${MAX_WAIT_TIME} --entity-default

echo "Replica fetch maximum wait time increased successfully."



# Restart the Kafka broker

echo "Restarting the Kafka broker..."

systemctl restart kafka

echo "Kafka broker restarted successfully."