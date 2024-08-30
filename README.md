# IaC Confluent Resources Terraform Configuration
[Terraform](https://terraform.io), an open-source Infrastructure as Code (IaC) tool developed by HashiCorp, uses a **declarative** approach for managing infrastructure resources. Unlike **imperative** programming languages like Java, which require explicit, sequential commands to achieve a specific outcome, Terraform enables users to define their desired infrastructure state through configuration files using a YAML-like syntax. This approach abstracts the complexity of manual infrastructure management by allowing users to focus on "what" the final state should be rather than "how" to achieve it.

With Terraform, users can efficiently manage a wide range of [Confluent resources](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)—including Kafka Clusters, Environments, Schema Registry Clusters, Schemas, Topics, and Service Accounts—by defining their desired state in configuration files. Terraform maintains a detailed record of the current state of these resources and compares it against the desired state specified by the user. Based on this comparison, Terraform automatically generates a reconciliation plan to bring the existing infrastructure into alignment with the desired configuration. This process involves creating, updating, or deleting resources as needed, enabling consistent, repeatable, and predictable management of infrastructure components.

The configuration leverages the [**IaC Confluent API Key Rotation Terraform module**](https://github.com/j3-signalroom/iac-confluent-api_key_rotation-tf_module) to automate the creation and rotation of API Keys for both the [Kafka Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster) and the [Schema Registry Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_schema_registry_cluster) in Confluent Cloud. This module ensures that each API Key is securely rotated based on a defined schedule, reducing the risk of credential compromise and improving the overall security of the data streaming environment.

To protect sensitive credentials, the configuration securely stores the generated API Key pairs for both resources in [**AWS Secrets Manager**](.blog/aws-secrets-manager-secrets.md), ensuring that only authorized users and services have access to these credentials. This secure storage method prevents unauthorized access and minimizes the risk of key exposure.

Additionally, the configuration manages **Kafka client configuration parameters**—such as consumer and producer settings—by storing them in the [**AWS Systems Manager Parameter Store**](.blog/aws-parameter-store-parameters.md). This approach centralizes the management of these parameters, provides secure access controls, and allows for easy versioning and auditing, simplifying the operational management of Kafka clients.

**Table of Contents**

<!-- toc -->
+ [How to use this repo?](#how-to-use-this-repo)
    + [GitHub Setup](#github-setup)
        - [Terraform Cloud API token](#terraform-cloud-api-token)
        - [Confluent Cloud API](#confluent-cloud-api)
<!-- tocstop -->



## How to use this repo?
In the [main.tf](main.tf) replace **`<TERRAFORM CLOUD ORGANIZATION NAME>`** in the `terraform.cloud` block with your [Terraform Cloud Organization Name](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations) and **`<TERRAFORM CLOUD ORGANIZATION's WORKSPACE NAME>`** in the `terraform.cloud.workspaces` block with your [Terraform Cloud Organization's Workspaces Name](https://developer.hashicorp.com/terraform/cloud-docs/workspaces).

### GitHub Setup
In order to run the Terraform configuration, the Terraform Cloud API token and Confluent Cloud API Key are required as GitHub Secret variables:

#### Terraform Cloud API token
From the [Tokens page](https://app.terraform.io/app/settings/tokens), create/update the API token and store it in the [AWS Secrets Manager](https://us-east-1.console.aws.amazon.com/secretsmanager/secret?name=%2Fsi-iac-confluent_cloud_kafka_api_key_rotation-tf%2Fconfluent&region=us-east-1).  Then add/update the `TF_API_TOKEN` secret on the [GitHub Action secrets and variables, secret tab](https://github.com/signalroom/si-iac-confluent_cloud_kafka_api_key_rotation-tf/settings/secrets/actions).

#### Confluent Cloud API
Confluent Cloud requires API keys to manage access and authentication to different parts of the service.  An API key consists of a key and a secret.  You can create and manage API keys by using the [Confluent Cloud CLI](https://docs.confluent.io/confluent-cli/current/overview.html).  Learn more about Confluent Cloud API Key access [here](https://docs.confluent.io/cloud/current/access-management/authenticate/api-keys/api-keys.html#ccloud-api-keys).

Using the Confluent CLI, execute the follow command to generate the Cloud API Key:
```
confluent api-key create --resource "cloud" 
```
Then, for instance, copy-and-paste the API Key and API Secret values to the respective, `CONFLUENT_CLOUD_API_KEY` and `CONFLUENT_CLOUD_API_SECRET` secrets, that need to be created/updated on the [J3 repository Actions secrets and variables page](https://github.com/j3-signalroom/j3-iac-confluent_cloud_resources_api_keys-tf/settings/secrets/actions).
