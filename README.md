
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka In-Sync Replica Count Drops Incident
---

This incident type refers to a situation where the in-sync replica count of a Kafka cluster drops below the expected value. In simple terms, an in-sync replica (ISR) is a replica that is up-to-date with the leader partition. When the ISR count drops, it means that one or more replicas have fallen behind the leader partition, which could result in data loss or inconsistency across the Kafka cluster. This incident requires immediate attention and investigation to identify the root cause and take necessary actions to prevent further impact.

### Parameters
```shell
export PORT="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_SERVER="PLACEHOLDER"

export BROKER_HOST="PLACEHOLDER"

export MAX_WAIT_TIME="PLACEHOLDER"

export BROKER_PORT="PLACEHOLDER"


```

## Debug

### Check the current ISR count for the given topic
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --describe --topic ${TOPIC_NAME} | grep "ReplicationFactor"
```

### Check the current leader for the given topic
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --describe --topic ${TOPIC_NAME} | grep "Leader"
```

### Check the current ISR count for all topics in the cluster
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --list | xargs -I {} kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --describe --topic {} | grep -e "Topic" -e "ReplicationFactor"
```

### Check the current leader for all topics in the cluster
```shell
kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --list | xargs -I {} kafka-topics.sh --zookeeper ${ZOOKEEPER_SERVER}:${PORT} --describe --topic {} | grep -e "Topic" -e "Leader"
```

### Check the logs for any errors or warnings related to ISR
```shell
grep -r "isr" /var/log/kafka
```

## Repair

### Increase the replica fetch maximum wait time: If the ISR count drops due to high replica lag, consider increasing the replica fetch maximum wait time. This parameter determines how long a broker should wait for a replica to catch up with the leader partition before returning the results to the consumer.
```shell


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


```