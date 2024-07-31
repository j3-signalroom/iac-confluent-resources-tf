# IaC Confluent Cloud Resources API Keys Terraform Configuration

> In the [main.tf](main.tf) replace **`<TERRAFORM CLOUD ORGANIZATION NAME>`** in the `terraform.cloud` block with your [Terraform Cloud Organization Name](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations) and **`<TERRAFORM CLOUD ORGANIZATION's WORKSPACE NAME>`** in the `terraform.cloud.workspaces` block with your [Terraform Cloud Organization's Workspaces Name](https://developer.hashicorp.com/terraform/cloud-docs/workspaces).


**Table of Contents**

<!-- toc -->
+ [Purpose](#purpose)
    - [`/confluent_cloud_resource/schema_registry`](#confluent_cloud_resourceschema_registry)
    - [`/confluent_cloud_resource/demo-kafka-cluster`](#confluent_cloud_resourcedemo-kafka-cluster)
+ [GitHub Setup](#github-setup)
    - [Terraform Cloud API token](#terraform-cloud-api-token)
    - [Confluent Cloud API](#confluent-cloud-api)
<!-- tocstop -->

## Purpose
The configuration leverages the [IaC Confluent Cloud Resource API Key Rotation Terraform module](https://github.com/j3-signalroom/iac-confluent_cloud_resource_api_key_rotation-tf_module) to handle the creation and rotation of each of the Confluent Cloud Resource API Key for each of the Confluent Cloud Resources:
- [Schema Registry Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_schema_registry_cluster)
- [Kafka Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster)

Along with the current active API Key of each of the Confluent Cloud Resources, Schema Registry Cluster REST endpoint, and Kafka Cluster's Bootstrap URI and REST endpoint are stored in the [AWS Secrets Manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret).  Below are the Secrets created:

#### `/confluent_cloud_resource/schema_registry`

> Key|Value Description
> -|-
> api_key|The ID of the API Key.
> api_secret|The secret of the API Key.
> rest_endpoint|The HTTP endpoint of the Schema Registry cluster.

#### `/confluent_cloud_resource/demo-kafka-cluster`
> Key|Value Description
> -|-
> api_key|The ID of the API Key.
> api_secret|The secret of the API Key.
> java_client_jaas_configuration|Java Authentication and Authorization Service (JAAS) for SASL configuration.
> bootstrap_url|The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster.
> rest_endpoint|The REST endpoint of the Kafka cluster.

## GitHub Setup
In order to run the Terraform configuration, the Terraform Cloud API token and Confluent Cloud API Key are required as GitHub Secret variables:

### Terraform Cloud API token
From the [Tokens page](https://app.terraform.io/app/settings/tokens), create/update the API token and store it in the [AWS Secrets Manager](https://us-east-1.console.aws.amazon.com/secretsmanager/secret?name=%2Fsi-iac-confluent_cloud_kafka_api_key_rotation-tf%2Fconfluent&region=us-east-1).  Then add/update the `TF_API_TOKEN` secret on the [GitHub Action secrets and variables, secret tab](https://github.com/signalroom/si-iac-confluent_cloud_kafka_api_key_rotation-tf/settings/secrets/actions).

### Confluent Cloud API
Confluent Cloud requires API keys to manage access and authentication to different parts of the service.  An API key consists of a key and a secret.  You can create and manage API keys by using the [Confluent Cloud CLI](https://docs.confluent.io/confluent-cli/current/overview.html).  Learn more about Confluent Cloud API Key access [here](https://docs.confluent.io/cloud/current/access-management/authenticate/api-keys/api-keys.html#ccloud-api-keys).


Using the Confluent CLI, execute the follow command to generate the Cloud API Key:
```
confluent api-key create --resource "cloud" 
```
Then copy-and-paste the API Key and API Secret values to the respective, `CONFLUENT_CLOUD_API_KEY` and `CONFLUENT_CLOUD_API_SECRET` secrets, that need to be created/updated on the [J3 repository Actions secrets and variables page](https://github.com/j3-signalroom/j3-iac-confluent_cloud_resources_api_keys-tf/settings/secrets/actions).
