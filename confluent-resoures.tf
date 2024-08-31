# Reference the Confluent Cloud
data "confluent_organization" "env" {}

# Create the Confluent Cloud Environment
resource "confluent_environment" "env" {
  display_name = "${var.environment_name}"

  stream_governance {
  package = "ESSENTIALS"
  }
}

# Create the Service Account for the Kafka Cluster API
resource "confluent_service_account" "schema_registry_cluster_api" {
    display_name = "${var.environment_name}-environment-api"
    description  = "Environment API Service Account"
}

# Config the environment's schema registry
data "confluent_schema_registry_cluster" "env" {
  environment {
    id = confluent_environment.env.id
  }

  depends_on = [
    confluent_kafka_cluster.kafka_cluster
  ]
}

# Create the Kafka cluster
resource "confluent_kafka_cluster" "kafka_cluster" {
    display_name = "kafka_cluster"
    availability = "SINGLE_ZONE"
    cloud        = local.cloud
    region       = var.aws_region
    basic {}

    environment {
        id = confluent_environment.env.id
    }
}

# Create the Service Account for the Kafka Cluster API
resource "confluent_service_account" "kafka_cluster_api" {
    display_name = "${var.environment_name}-kafka_cluster-api"
    description  = "Kafka Cluster API Service Account"
}

resource "confluent_role_binding" "kafka_cluster_api_environment_admin" {
  principal   = "User:${confluent_service_account.kafka_cluster_api.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.env.resource_name
}

