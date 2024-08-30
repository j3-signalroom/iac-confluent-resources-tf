# Reference the Confluent Cloud
data "confluent_organization" "env" {}

# Create the Confluent Cloud Environment
resource "confluent_environment" "env" {
    display_name = "${var.aws_profile}"

    #lifecycle {
    #  prevent_destroy = true
    #}
}

# Create the Service Account for the Kafka Cluster API
resource "confluent_service_account" "schema_registry_cluster_api" {
    display_name = "${var.aws_profile}-environment-api"
    description  = "Environment API Service Account"
}

# Config the environment's schema registry
data "confluent_schema_registry_region" "env" {
    cloud   = local.cloud
    region  = var.aws_region
    package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "env" {
  package = data.confluent_schema_registry_region.env.package

  environment {
    id = confluent_environment.env.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    # Schema Registry and Kafka clusters can be in different regions as well as different cloud providers,
    # but you should to place both in the same cloud and region to restrict the fault isolation boundary.
    # A fault isolation boundary, also known as a swimlane, is a concept that separates services into failure 
    # domains to limit the impact of a failure to a specific number of components.
    id = data.confluent_schema_registry_region.env.id
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
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
    display_name = "${var.aws_profile}-kafka_cluster-api"
    description  = "Kafka Cluster API Service Account"
}

resource "confluent_role_binding" "kafka_cluster_api_environment_admin" {
  principal   = "User:${confluent_service_account.kafka_cluster_api.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.env.resource_name
}

