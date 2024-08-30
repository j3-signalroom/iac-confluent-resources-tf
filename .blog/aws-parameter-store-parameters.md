# AWS Systems Manager Parameter Store
**AWS Systems Manager Parameter Store** is a secure service for storing, managing, and retrieving configuration data and secrets used by your applications and AWS resources. It is a component of AWS Systems Manager, providing a centralized and hierarchical storage system for configuration data management. You can store plain text data, such as configuration files, or sensitive data, such as passwords, database strings, and API keys.

**Table of Contents**

<!-- toc -->
+ [1.0 Key Features of AWS Systems Manager Parameter Store](#10-key-features-of-aws-systems-manager-parameter-store)
+ [1.1 Our Use Case](#11-our-use-case)
    - [1.1.1 `/confluent_cloud_resource/consumer_kafka_client`](#111-confluent_cloud_resourceconsumer_kafka_client)
    - [1.1.2 `/confluent_cloud_resource/producer_kafka_client`](#112-confluent_cloud_resourceproducer_kafka_client)
+ [1.2 Differences Between AWS Parameter Store and AWS Secrets Manager](#12-differences-between-aws-parameter-store-and-aws-secrets-manager)
+ [1.3 Benefits of AWS Systems Manager Parameter Store](#13-benefits-of-aws-systems-manager-parameter-store)
<!-- tocstop -->

## 1.0 Key Features of AWS Systems Manager Parameter Store

1. **Secure Storage of Configuration Data**:
   - Store configuration data and secrets securely.
   - Supports both plain text parameters and encrypted parameters using AWS Key Management Service (KMS) for added security.

2. **Hierarchical Parameter Storage**:
   - Organize parameters into hierarchies using a folder-like structure (`/application/production/db-host`), which helps in managing multiple versions or configurations of an application across environments.

3. **Parameter Versioning**:
   - Automatically versions parameters, allowing you to track and reference different versions of a parameter, making it easier to roll back changes if necessary.

4. **Integration with AWS Services**:
   - Seamlessly integrates with other AWS services like Amazon EC2, AWS Lambda, AWS CloudFormation, and AWS CodeBuild to securely access parameters and configuration data.

5. **Access Control and Auditing**:
   - Supports AWS Identity and Access Management (IAM) policies to control who can access and modify parameters.
   - Integrates with AWS CloudTrail to provide logging of all parameter accesses and modifications, ensuring compliance and security monitoring.

6. **Change Notifications and Monitoring**:
   - Integrates with Amazon CloudWatch Events and AWS CloudWatch to notify you of parameter changes or to monitor access patterns.

7. **Built-In Parameter Types**:
   - **String**: Stores plain text strings.
   - **StringList**: Stores a comma-separated list of strings.
   - **SecureString**: Stores sensitive data encrypted using AWS KMS.

## 1.1 Our Use Cases

1. **Configuration Management**:
   - Store and manage application configuration settings, such as database connection strings, application environment variables, and feature flags.

2. **Dynamic Configuration**:
   - Dynamically change configurations without redeploying applications. Applications can retrieve parameters at runtime to adapt to new configurations.

For instance, below are the parameters created by the Terraform configuration:

### 1.1.1 `/confluent_cloud_resource/consumer_kafka_client`
> Key|Descriptionx
> -|-
> `auto.commit.interval.ms`|The `auto.commit.interval.ms` property in Apache Kafka defines the frequency (in milliseconds) at which the Kafka consumer automatically commits offsets. This is relevant when `enable.auto.commit` is set to true, which allows Kafka to automatically commit the offsets periodically without requiring the application to do so explicitly.
> `auto.offset.reset`|Specifies the behavior of the consumer when there is no committed position (which occurs when the group is first initialized) or when an offset is out of range. You can choose either to reset the position to the `earliest` offset or the `latest` offset (the default).
> `basic.auth.credentials.source`|This property specifies the source of the credentials for basic authentication.
> `client.dns.lookup`|This property specifies how the client should resolve the DNS name of the Kafka brokers.
> `enable.auto.commit`|When set to true, the Kafka consumer automatically commits the offsets of messages it has processed at regular intervals, specified by the `auto.commit.interval.ms` property. If set to false, the application is responsible for committing offsets manually.
> `max.poll.interval.ms`|This property defines the maximum amount of time (in milliseconds) that can pass between consecutive calls to poll() on a consumer. If this interval is exceeded, the consumer will be considered dead, and its partitions will be reassigned to other consumers in the group.
> `request.timeout.ms`|This property sets the maximum amount of time the client will wait for a response from the Kafka broker. If the server does not respond within this time, the client will consider the request as failed and handle it accordingly.
> `sasl.mechanism`|This property specifies the SASL mechanism to be used for authentication.
> `security.protocol`|This property specifies the protocol used to communicate with Kafka brokers.
> `session.timeout.ms`|This property sets the timeout for detecting consumer failures when using Kafka's group management. If the consumer does not send a heartbeat to the broker within this period, it will be considered dead, and its partitions will be reassigned to other consumers in the group.

### 1.1.2 `/confluent_cloud_resource/producer_kafka_client`
> Key|Description
> -|-
> `sasl.mechanism`|This property specifies the SASL mechanism to be used for authentication.
> `security.protocol`|This property specifies the protocol used to communicate with Kafka brokers.
> `client.dns.lookup`|This property specifies how the client should resolve the DNS name of the Kafka brokers.
> `acks`|This property specifies the number of acknowledgments the producer requires the leader to have received before considering a request complete.

## 1.2 Differences Between AWS Parameter Store and AWS Secrets Manager

- **Purpose**:
  - **Parameter Store**: Used for general-purpose configuration management, including storing non-sensitive data and secrets.
  - **Secrets Manager**: Specifically designed for managing secrets (like credentials and API keys) with built-in features like automatic rotation.

- **Secret Rotation**:
  - **Parameter Store**: Does not support automatic secret rotation natively.
  - **Secrets Manager**: Supports automatic rotation of secrets and integrates with AWS services to handle secret rotation for databases and other services.

- **Cost**:
  - **Parameter Store**: Free for standard parameters; advanced parameters have associated costs.
  - **Secrets Manager**: Has a cost based on the number of secrets stored and secret rotation.

## 1.3 Benefits of AWS Systems Manager Parameter Store

- **Centralized Management**: Provides a centralized location to manage configuration data across all your AWS resources.
- **Security**: Secure storage with encryption using AWS KMS, and fine-grained access control using IAM.
- **Scalability**: Scales with your needs to support thousands of parameters across multiple AWS services and applications.
- **Cost-Effectiveness**: Basic use of the Parameter Store is free, making it a cost-effective solution for many applications.
