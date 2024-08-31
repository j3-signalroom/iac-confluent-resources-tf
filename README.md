# IaC Confluent Resources Terraform Configuration
[Terraform](https://terraform.io), an open-source Infrastructure as Code (IaC) tool developed by HashiCorp, uses a **declarative** approach for managing infrastructure resources. Unlike **imperative** programming languages like Java, which require explicit, sequential commands to achieve a specific outcome, Terraform enables users to define their desired infrastructure state through configuration files using a YAML-like syntax. This approach abstracts the complexity of manual infrastructure management by allowing users to focus on "what" the final state should be rather than "how" to achieve it.

With Terraform, users can efficiently manage a wide range of [Confluent resources](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)—including Kafka Clusters, Environments, Schema Registry Clusters, Schemas, Topics, and Service Accounts—by defining their desired state in configuration files. Terraform maintains a detailed record of the current state of these resources and compares it against the desired state specified by the user. Based on this comparison, Terraform automatically generates a reconciliation plan to bring the existing infrastructure into alignment with the desired configuration. This process involves creating, updating, or deleting resources as needed, enabling consistent, repeatable, and predictable management of infrastructure components.

The configuration leverages the [**IaC Confluent API Key Rotation Terraform module**](https://github.com/j3-signalroom/iac-confluent-api_key_rotation-tf_module) to automate the creation and rotation of API Keys for both the [Kafka Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster) and the [Schema Registry Cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/confluent_schema_registry_clusters) in Confluent Cloud. This module ensures that each API Key is securely rotated based on a defined schedule, reducing the risk of credential compromise and improving the overall security of the data streaming environment.

To protect sensitive credentials, the configuration securely stores the generated API Key pairs for both resources in [**AWS Secrets Manager**](.blog/aws-secrets-manager-secrets.md), ensuring that only authorized users and services have access to these credentials. This secure storage method prevents unauthorized access and minimizes the risk of key exposure.

Additionally, the configuration manages **Kafka client configuration parameters**—such as consumer and producer settings—by storing them in the [**AWS Systems Manager Parameter Store**](.blog/aws-parameter-store-parameters.md). This approach centralizes the management of these parameters, provides secure access controls, and allows for easy versioning and auditing, simplifying the operational management of Kafka clients.

**Table of Contents**

<!-- toc -->
+ [Let's get started!](#lets-get-started)
+ [Resources](#resources)
<!-- tocstop -->

## Let's get started!
**These are the steps**

1. Take care of the cloud and local environment prequisities listed below:
    > You need to have the following cloud accounts:
    > - [AWS Account](https://signin.aws.amazon.com/) *with SSO configured*
    > - [Confluent Cloud Account](https://confluent.cloud/)
    > - [GitHub Account](https://github.com) *with OIDC configured for AWS*
    > - [Terraform Cloud Account](https://app.terraform.io/)

    > You need to have the following installed on your local machine:
    > - [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    > - [Confluent CLI version 3 or higher](https://docs.confluent.io/confluent-cli/4.0/overview.html)
    > - [Terraform CLI version 1.85 or higher](https://developer.hashicorp.com/terraform/install)

2. Get your Confluent Cloud API key pair, by execute the following Confluent CLI command to generate the Cloud API Key:

    > Click [here](.blog/why-do-you-need-the-confluent-cloud-api-key.md#2-integration-with-cicd-pipelines) to learn why you need it.

    ```shell
    confluent api-key create --resource "cloud" 
    ```

    Next, securely store the Confluent Cloud API Key and Secret in a reliable secret management solution, such as AWS Secrets Manager or GitHub Secrets. These platforms provide encrypted storage, access controls, and automated rotation capabilities, ensuring that sensitive credentials are protected against unauthorized access or leakage. Properly storing your API Key pair is critical because it is required to authenticate and authorize any interactions with the Confluent Cloud when executing your local scripts or running your Terraform configuration in environments like GitHub Actions. This API Key pair allows Terraform to provision, manage, and update Confluent Cloud resources as defined in your infrastructure code, maintaining a secure, automated deployment pipeline.

3. Clone the repo:
    ```shell
    git clone https://github.com/j3-signalroom/iac-confluent-resources-tf.git
    ```

4. Update the cloned Terraform module's [main.tf](main.tf) by following these steps:

    a. Locate the `terraform.cloud` block and replace **`signalroom`** with your [Terraform Cloud Organization Name](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations).

    b. In the `terraform.cloud.workspaces` block, replace **`iac-confluent-resources-workspace`** with your [Terraform Cloud Organization's Workspaces Name](https://developer.hashicorp.com/terraform/cloud-docs/workspaces).

## Resources
[Terraform Confluent Provider GitHub Examples](https://github.com/confluentinc/terraform-provider-confluent/tree/master/examples/configurations)

[Create a Kafka Cluster on Confluent Cloud from a Template Using Terraform](https://docs.confluent.io/cloud/current/clusters/terraform-provider.html)

[YouTube video by Confluent on Getting started with the Confluent Terraform Provider](https://www.youtube.com/watch?v=ofSQ4j9u6W4)

[Automating Infrastructure as Code with Apache Kafka and Confluent ft. Rosemary Wang](https://developer.confluent.io/learn-more/podcasts/automating-infrastructure-as-code-with-apache-kafka-and-confluent-ft-rosemary-wang/?utm_medium=sem&utm_source=google&utm_campaign=ch.sem_br.nonbrand_tp.prs_tgt.dsa_mt.dsa_rgn.namer_lng.eng_dv.all_con.confluent-developer&utm_term=&creative=&device=c&placement=&gad_source=1&gclid=Cj0KCQjw28W2BhC7ARIsAPerrcISmtX3Y10dSCLzaSA8wLBdVfZLxh9QulaJQY55N-_oOoaLVjrggSoaAmRAEALw_wcB)

[Best Practices for Confluent Terraform Provider](https://www.confluent.io/blog/best-practices-confluent-terraform-provider/)