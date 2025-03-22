terraform {
    cloud {
        organization ="signalroom"

        workspaces {
            name = "iac-confluent-resources-workspace"
        }
  }

  # Using the "pessimistic constraint operators" for all the Providers to ensure
  # that the provider version is compatible with the configuration.  Meaning
  # only patch-level updates are allowed but minor-level and major-level 
  # updates of the Providers are not allowed
  required_providers {
        confluent = {
            source  = "confluentinc/confluent"
            version = "~> 2.22.0"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.92.0"
        }
    }
}

locals {
  cloud          = "AWS"
  secrets_prefix = "/confluent_cloud_resource"
}

# Create the Environment API Key Pairs, rotate them in accordance to a time schedule, 
# and provide the current acitve API Key Pair to use
module "schema_registry_cluster_api_key_rotation" {
    
    source  = "github.com/j3-signalroom/iac-confluent-api_key_rotation-tf_module"

    # Required Input(s)
    owner = {
        id          = confluent_service_account.schema_registry_cluster_api.id
        api_version = confluent_service_account.schema_registry_cluster_api.api_version
        kind        = confluent_service_account.schema_registry_cluster_api.kind
    }

    resource = {
        id          = data.confluent_schema_registry_cluster.env.id
        api_version = data.confluent_schema_registry_cluster.env.api_version
        kind        = data.confluent_schema_registry_cluster.env.kind

        environment = {
            id = confluent_environment.env.id
        }
    }

    confluent_api_key    = var.confluent_api_key
    confluent_api_secret = var.confluent_api_secret

    # Optional Input(s)
    key_display_name = "Confluent Schema Registry Cluster Service Account API Key - {date} - Managed by Terraform Cloud"
    number_of_api_keys_to_retain = var.number_of_api_keys_to_retain
    day_count = var.day_count
}

# Create the Kafka Cluster API Key Pairs, rotate them in accordance to a time schedule,
# and provide the current acitve API Key Pair to use
module "kafka_cluster_api_key_rotation" {
    source  = "github.com/j3-signalroom/iac-confluent-api_key_rotation-tf_module"

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

    confluent_api_key    = var.confluent_api_key
    confluent_api_secret = var.confluent_api_secret

    # Optional Input(s)
    key_display_name = "Confluent Kafka Cluster Service Account API Key - {date} - Managed by Terraform Cloud"
    number_of_api_keys_to_retain = var.number_of_api_keys_to_retain
    day_count = var.day_count
}
