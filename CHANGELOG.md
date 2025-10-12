# Changelog
All notable changes to this project will be documented in this file.

The format is base on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.29.00.000] - 2025-10-12
### Added
- Issue [#111](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/111).
- Issue [#113](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/113).

## [0.28.00.000] - 2025-08-31
### Added
- Issue [#107](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/107).
- Issue [#108](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/108).

## [0.27.00.000] - 2025-08-09
### Added
- Issue [#103](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/103).

## [0.26.00.000] - 2025-05-19
### Added
- Issue [#99](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/99).

## [0.25.00.000] - 2025-04-19
### Changed
- Upgraded the version of Terraform AWS Provider to `5.95.0`, and Terraform Confluent Provider to `2.25.0`.

## [0.24.00.000] - 2025-04-13
### Changed
- Upgraded the version of Terraform AWS Provider to `5.94.1`, and Terraform Confluent Provider to `2.24.0`.

## [0.23.00.000] - 2024-11-22
### Changed
- Upgraded the version of Terraform AWS Provider to `5.77.0`, and Terraform Confluent Provider to `2.10.0`.

## [0.22.00.000] - 2024-11-08
### Added
- Issue [#81](https://github.com/j3-signalroom/iac-confluent-resources-tf/issues/81).

### Changed
- Upgraded the version of Terraform AWS Provider to `5.75.0`, and Terraform Confluent Provider to `2.9.0`.

## [0.21.00.000] - 2024-09-05
### Changed
- Upgraded the version of Terraform AWS Provider to `5.66.0`, and Terraform Snowflake Provider to `0.95.0`.

### Fixed
- Fix typo in the `undeployed.yml`, and removed the `aws_profile` argument that was being passed to the Terraform configuration.

## [0.20.00.000] - 2024-09-01
### Added
- GitHub Action that determines the AWS Account ID.
- instructions on how to execute Terraform from a GitHub Workflow.

### Fixed
- from the GitHub Workflows the AWS credentials are now being passed to the Terraform configuration.

## [0.11.00.000] - 2024-08-31
### Added
- instructions to the README.md to run the Terraform script.

## [0.10.00.000] - 2024-08-31
### Added
- the `run-terraform.locally.sh` BASH script to run the Terraform configuration locally.

### Changed
- slightly renamed the repo.
- Upgraded and refactored all the Terraform Confluent Provider resources and data blocks to adhere to release `2.1.0`.

## [0.01.00.000] - 2024-08-03
### Added
- First release.