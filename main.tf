terraform {
    cloud {
        organization ="<TERRAFORM CLOUD ORGANIZATION NAME>"

        workspaces {
            name = "<TERRAFORM CLOUD ORGANIZATION's WORKSPACE NAME>"
        }
  }

  required_providers {
        confluent = {
            source  = "confluentinc/confluent"
            version = "~> 1.80.0"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.58.0"
        }
    }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

provider "aws" {
    region  = var.aws_region
}

locals {
  cloud          = "AWS"
  secrets_prefix = "/confluent_cloud_resource"
}

# Reference the My Organization Confluent Cloud
data "confluent_organization" "env" {}

# Create the Confluent Cloud Environment
resource "confluent_environment" "env" {
    display_name = "${var.aws_profile}"

    #lifecycle {
    #  prevent_destroy = true
    #}
}

# Create the Service Account for the My Organization Kafka Cluster API
resource "confluent_service_account" "schema_registry_api" {
    display_name = "${var.aws_profile}-environment-api"
    description  = "My Organization Environment API Service Account"
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

# Create the Environment API Key Pairs, rotate them in accordance to a time schedule, and provide the current
# acitve API Key Pair to use
module "schema_registry_api_key_rotation" {
    source  = "github.com/j3-signalroom/iac-confluent_cloud_resource_api_key_rotation-tf_module"

    # Required Input(s)
    owner = {
        id          = confluent_service_account.schema_registry_api.id
        api_version = confluent_service_account.schema_registry_api.api_version
        kind        = confluent_service_account.schema_registry_api.kind
    }

    resource = {
        id          = confluent_schema_registry_cluster.env.id
        api_version = confluent_schema_registry_cluster.env.api_version
        kind        = confluent_schema_registry_cluster.env.kind

        environment = {
            id = confluent_environment.env.id
        }
    }

    confluent_cloud_api_key    = var.confluent_cloud_api_key
    confluent_cloud_api_secret = var.confluent_cloud_api_secret

    # Optional Input(s)
    key_display_name = "Confluent Schema Registry Cluster Service Account API Key - {date} - Managed by Terraform Cloud"
    number_of_api_keys_to_retain = var.number_of_api_keys_to_retain
    day_count = var.day_count
}

# Create the My Organization Kafka cluster
resource "confluent_kafka_cluster" "kafka_cluster" {
    display_name = "myorg"
    availability = "SINGLE_ZONE"
    cloud        = local.cloud
    region       = var.aws_region
    basic {}

    environment {
        id = confluent_environment.env.id
    }
}

# Create the Service Account for the My Organization Kafka Cluster API
resource "confluent_service_account" "kafka_cluster_api" {
    display_name = "${var.aws_profile}-kafka_cluster-api"
    description  = "My Organization Kafka Cluster API Service Account"
}

# Create the Kafka Cluster API Key Pairs, rotate them in accordance to a time schedule, and provide the current acitve API Key Pair
# to use
module "kafka_cluster_api_key_rotation" {
    source  = "github.com/j3-signalroom/iac-confluent_cloud_resource_api_key_rotation-tf_module"

    #Required Input(s)
    owner = {
        id          = confluent_service_account.kafka_cluster_api.id
        api_version = confluent_service_account.kafka_cluster_api.api_version
        kind        = confluent_service_account.kafka_cluster_api.kind
    }

    resource = {
        id          = confluent_kafka_cluster.kafka_cluster.id
        api_version = confluent_kafka_cluster.kafka_cluster.api_version
        kind        = confluent_kafka_cluster.kafka_cluster.kind

        environment = {
            id = confluent_environment.env.id
        }
    }

    confluent_cloud_api_key    = var.confluent_cloud_api_key
    confluent_cloud_api_secret = var.confluent_cloud_api_secret

    # Optional Input(s)
    key_display_name = "My Organization Confluent Kafka Cluster Service Account API Key - {date} - Managed by Terraform Cloud"
    number_of_api_keys_to_retain = var.number_of_api_keys_to_retain
    day_count = var.day_count
}

# Create the Schema Registry Secrets: API Key Pair and REST endpoint
resource "aws_secretsmanager_secret" "schema_registry_api_key" {
    name = "${local.secrets_prefix}/schema_registry"
    description = "My Organization Schema Registry secrets"
}

resource "aws_secretsmanager_secret_version" "schema_registry_api_key" {
    secret_id     = aws_secretsmanager_secret.schema_registry_api_key.id
    secret_string = jsonencode({"api_key": "${module.schema_registry_api_key_rotation.active_api_key.id}", 
                                "api_secret": "${module.schema_registry_api_key_rotation.active_api_key.secret}",
                                "rest_endpoint": "${confluent_schema_registry_cluster.env.rest_endpoint}"})
}

# Create the Kafka Cluster Secrets: API Key Pair, JAAS (Java Authentication and Authorization) representation,
# bootstrap server URI and REST endpoint
resource "aws_secretsmanager_secret" "kafka_cluster_api_key" {
    name = "${local.secrets_prefix}/kafka-cluster"
    description = "My Organization Kafka Cluster secrets"
}

resource "aws_secretsmanager_secret_version" "kafka_cluster_api_key" {
    secret_id     = aws_secretsmanager_secret.kafka_cluster_api_key.id
    secret_string = jsonencode({"api_key": "${module.kafka_cluster_api_key_rotation.active_api_key.id}", 
                                "api_secret": "${module.kafka_cluster_api_key_rotation.active_api_key.secret}",
                                "java_client_jaas_configuration": "org.apache.kafka.common.security.plain.PlainLoginModule required username='${module.kafka_cluster_api_key_rotation.active_api_key.id}' password='${module.kafka_cluster_api_key_rotation.active_api_key.secret}';",
                                "bootstrap_url": "${confluent_kafka_cluster.kafka_cluster.bootstrap_endpoint}"
                                "rest_endpoint": "${confluent_kafka_cluster.kafka_cluster.rest_endpoint}"})
}
