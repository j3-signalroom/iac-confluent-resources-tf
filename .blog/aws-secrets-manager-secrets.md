# AWS Secrets Manager
AWS Secrets Manager is a fully managed service that helps you securely store, manage, and retrieve secrets, such as database credentials, API keys, passwords, and other sensitive information needed by your applications. It is designed to help you protect access to your secrets by encrypting them and managing their lifecycle, such as automatic rotation, auditing, and access control.

**Table of Contents**

<!-- toc -->
+ [1.0 Key Features of AWS Secrets Manager](#10-key-features-of-aws-secrets-manager)
+ [1.1 Our Use Case](#11-our-use-case)
    - [1.1.1 `/confluent_cloud_resource/schema_registry_cluster/java_client`](#111-confluent_cloud_resourceschema_registry_clusterjava_client)
    - [1.1.2 `/confluent_cloud_resource/kafka_cluster/java_client`](#112-confluent_cloud_resourcekafka_clusterjava_client)
+ [1.2 Benefits of Using AWS Secrets Manager](#12-benefits-of-using-aws-secrets-manager)
<!-- tocstop -->

## 1.0 Key Features of AWS Secrets Manager

1. **Secure Storage and Encryption**: Secrets are stored securely and are encrypted using AWS Key Management Service (KMS). You can use AWS-managed keys or your own customer-managed keys to control encryption.

2. **Automatic Secret Rotation**: AWS Secrets Manager can automatically rotate secrets according to a specified schedule without disrupting your applications. It supports built-in integrations for popular services (like RDS databases), and you can also create custom rotation lambdas for other types of secrets.

3. **Fine-Grained Access Control**: You can use AWS Identity and Access Management (IAM) policies to define who can access secrets and under what conditions, providing granular control over who can read or manage your secrets.

4. **Audit and Monitoring**: AWS Secrets Manager integrates with AWS CloudTrail to log all API requests, giving you the ability to audit access and modifications to your secrets. You can also set up AWS CloudWatch alarms to monitor any suspicious activity or unauthorized access attempts.

5. **Version Management**: Secrets Manager supports versioning, allowing you to have multiple versions of a secret. This is useful for gradual transitions between old and new credentials.

6. **Integrated with AWS Services**: It integrates seamlessly with various AWS services like AWS Lambda, AWS RDS, and AWS IAM, making it easier to use and manage secrets across your AWS environment.

## 1.1 Our Use Case

- **API Key Storage**: Securely store Confluent Cloud API keys.

For instance, below are the secrets created by the Terraform configuration:

### 1.1.1 `/confluent_cloud_resource/schema_registry_cluster/java_client`
> Key|Description
> -|-
> `basic.auth.credentials.source`|Specifies the the format used in the `basic.auth.user.info` property.
> `basic.auth.user.info`|Specifies the API Key and Secret for the Schema Registry Cluster.
> `schema.registry.url`|The HTTP endpoint of the Schema Registry cluster.

### 1.1.2 `/confluent_cloud_resource/kafka_cluster/java_client`
> Key|Description
> -|-
> `sasl.jaas.config`|Java Authentication and Authorization Service (JAAS) for SASL configuration.
> `bootstrap.servers`|The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster.


## 1.2 Benefits of Using AWS Secrets Manager

- **Improved Security**: Secrets are stored securely and are encrypted, reducing the risk of exposure.
- **Reduced Risk of Credential Exposure**: Automatic rotation and fine-grained access control help minimize the risk of credential leaks.
- **Simplified Compliance**: Audit and logging capabilities make it easier to meet compliance requirements by providing a clear record of who accessed or modified secrets.
- **Easier Secret Management**: Centralized management of secrets simplifies operational overhead and makes it easier to enforce security best practices.
