resource "shoreline_notebook" "kafka_in_sync_replica_count_drops_incident" {
  name       = "kafka_in_sync_replica_count_drops_incident"
  data       = file("${path.module}/data/kafka_in_sync_replica_count_drops_incident.json")
  depends_on = [shoreline_action.invoke_kafka_config_update]
}

resource "shoreline_file" "kafka_config_update" {
  name             = "kafka_config_update"
  input_file       = "${path.module}/data/kafka_config_update.sh"
  md5              = filemd5("${path.module}/data/kafka_config_update.sh")
  description      = "Increase the replica fetch maximum wait time: If the ISR count drops due to high replica lag, consider increasing the replica fetch maximum wait time. This parameter determines how long a broker should wait for a replica to catch up with the leader partition before returning the results to the consumer."
  destination_path = "/tmp/kafka_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_config_update" {
  name        = "invoke_kafka_config_update"
  description = "Increase the replica fetch maximum wait time: If the ISR count drops due to high replica lag, consider increasing the replica fetch maximum wait time. This parameter determines how long a broker should wait for a replica to catch up with the leader partition before returning the results to the consumer."
  command     = "`chmod +x /tmp/kafka_config_update.sh && /tmp/kafka_config_update.sh`"
  params      = ["TOPIC_NAME","ZOOKEEPER_SERVER","MAX_WAIT_TIME","BROKER_PORT","BROKER_HOST"]
  file_deps   = ["kafka_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_config_update]
}

