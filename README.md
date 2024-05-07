[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/) [![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/add-aws-ecr-ecs-fargate)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/pulls?q=is%3Apr+is%3Aclosed) [![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/add-aws-ecr-ecs-fargate)](https://GitHub.com/kunduso/add-aws-ecr-ecs-fargate/pull/) 
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/add-aws-ecr-ecs-fargate)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/issues?q=is%3Aissue+is%3Aclosed) [![GitHub issues](https://img.shields.io/github/issues/kunduso/add-aws-ecr-ecs-fargate)](https://GitHub.com/kunduso/add-aws-ecr-ecs-fargate/issues/) 
[![terraform-infra-provisioning](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/terraform.yml) [![checkov-scan](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/code-scan.yml) [![docker-build-deploy](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/app-ci-cd.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/app-ci-cd.yml)


## Introduction
This repository contains code and resources related to various use cases involving Amazon Elastic Container Service (ECS), Docker, and infrastructure provisioning using Terraform and GitHub Actions.
## Table of Contents
- [Use Case 1: Create Infrastructure for Amazon ECS](#use-case-1-create-infrastructure-for-amazon-ecs)
- [Use Case 2: Build, Scan, and Push Docker Images to Amazon ECR](#use-case-2-build-scan-and-push-docker-images-to-amazon-ecr)
- [Use Case 3: Deploy to Amazon ECS Services](#use-case-3-deploy-to-amazon-ecs-services)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

![Image](https://skdevops.files.wordpress.com/2024/05/92-image-0-2.png)
## Use Case 1: Create Infrastructure for Amazon ECS

This use case covers the creation of all necessary infrastructure components required to host an Amazon Elastic Container Service (ECS) using Terraform and GitHub Actions. 
![Image](https://skdevops.files.wordpress.com/2024/04/90-image-1-2.png)
The components include:
- **Amazon Virtual Private Cloud (VPC)**: A logically isolated virtual network where your resources are deployed.
- **Security Groups**: Virtual firewalls that control inbound and outbound traffic to your resources.
- **VPC Endpoints**: Gateways that enable secure and private connections between your VPC and AWS services.
- **ECS Cluster**: A group of EC2 instances or Fargate tasks that run your containerized applications.
- **Elastic Container Registry (ECR)**: A fully-managed Docker container registry for storing and retrieving Docker images.
- **Application Load Balancer (ALB)**: A load balancer that distributes incoming traffic across your ECS tasks.
- **AWS Key Management Service (KMS) Key**: A secure and managed key for encrypting sensitive data.
- **CloudWatch Log groups**: A monitoring service that collects and stores logs from your containerized applications.

The [Terraform configurations](./infra/) and [GitHub Actions workflow](./.github/workflows/terraform.yml) automate the provisioning and configuration of these components, ensuring a consistent and repeatable deployment process. Here is a detailed note explaining the same - [create-infrastructure-to-host-an-amazon-ecs-service-using-terraform.](http://skundunotes.com/2024/04/10/create-infrastructure-to-host-an-amazon-ecs-service-using-terraform/)
## Use Case 2: Build, Scan, and Push Docker Images to Amazon ECR

This use case demonstrates how to build, scan, and push Docker images to Amazon Elastic Container Registry (ECR) using GitHub Actions.
![Image](https://skdevops.files.wordpress.com/2024/04/91-image-1.png)
The steps involved include:

1. Building a Docker image from a Dockerfile
2. Scanning the Docker image for vulnerabilities
3. Pushing the Docker image to Amazon ECR

The provided [GitHub Actions workflows](./.github/workflows/app-ci-cd.yml) automate the entire process, enabling continuous integration and delivery of Docker images to Amazon ECR. Here is a detailed note explaining the same - [push-docker-image-to-amazon-ecr-using-github-actions.](http://skundunotes.com/2024/04/28/push-docker-image-to-amazon-ecr-using-github-actions/)

## Use Case 3: Deploy to Amazon ECS Services

This use case focuses on deploying Amazon ECS services using Terraform and GitHub Actions. It includes the following steps:

1. Provisioning the necessary infrastructure components (as covered in Use Case 1)
2. Creating the ECS execution role and the ECS task role
3. Creating the ECS task definition
4. Creating an ECS Service
5. Configuring Load Balancing
6. Deploying the Docker image to the ECS Service (using the image pushed in Use Case 2)

The [Terraform configurations](./deploy/) and [GitHub Actions workflows](./.github/workflows/app-ci-cd.yml) handle the deployment and management of the ECS services, ensuring a streamlined and automated process. Here is a detailed note explaining the same - [continuous-deployment-of-amazon-ecs-service-using-terraform-and-github-actions.](http://skundunotes.com/2024/05/06/continuous-deployment-of-amazon-ecs-service-using-terraform-and-github-actions/)


Additionally, this repository includes:
</br> - a [Checkov pipeline](./.github/workflows/code-scan.yml) for scanning the Terraform code for security and compliance issues.

The entire setup and deployment process is automated via the GitHub Actions pipelines, eliminating the need for manual steps.

## Prerequisites
For this code to function without errors, create an OpenID connect identity provider in Amazon Identity and Access Management that has a trust relationship with your GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.
<br />Store the `ARN` of the `IAM Role` as a GitHub secret which is referred in the `terraform.yml` and `app-cd-cd.yml` file.
<br />For the **Infracost** integration, create an `INFRACOST_API_KEY` and store that as a GitHub Actions secret. You can manage the cost estimate process using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.
<br />You can read about that at - [integrate-Infracost-with-GitHub-Actions.](http://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/)
## Usage
Ensure that the policy/ies attached to the IAM role whose credentials are being used in this repository has permission to create and manage all the resources that are included in this repository and push the Docker image to Amazon ECR repository.

<br />If you want to check the pipeline logs, click on the **Build Badges** above the image in this ReadMe.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!

## License
This code is released under the Unlicense License. See [LICENSE](LICENSE).