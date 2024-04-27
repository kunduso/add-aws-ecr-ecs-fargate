[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/) [![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/add-aws-ecr-ecs-fargate)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/pulls?q=is%3Apr+is%3Aclosed) [![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/add-aws-ecr-ecs-fargate)](https://GitHub.com/kunduso/add-aws-ecr-ecs-fargate/pull/) 
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/add-aws-ecr-ecs-fargate)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/issues?q=is%3Aissue+is%3Aclosed) [![GitHub issues](https://img.shields.io/github/issues/kunduso/add-aws-ecr-ecs-fargate)](https://GitHub.com/kunduso/add-aws-ecr-ecs-fargate/issues/) 
[![terraform-infra-provisioning](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/terraform.yml) [![checkov-scan](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/code-scan.yml) [![docker-build-deploy](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/app-ci-cd.yml/badge.svg?branch=main)](https://github.com/kunduso/add-aws-ecr-ecs-fargate/actions/workflows/app-ci-cd.yml)


## Introduction
This repository contains the [Terraform code](./infra) to provision the necessary infrastructure components and the [Docker application](./app/) for running containerized applications on Amazon Elastic Container Service (ECS). 
![Image](https://skdevops.files.wordpress.com/2024/04/90-image-1-2.png)
<br />The infrastructure components include:
- **Amazon Virtual Private Cloud (VPC)**: A logically isolated virtual network where your resources are deployed.
- **Security Groups**: Virtual firewalls that control inbound and outbound traffic to your resources.
- **VPC Endpoints**: Gateways that enable secure and private connections between your VPC and AWS services.
- **ECS Cluster**: A group of EC2 instances or Fargate tasks that run your containerized applications.
- **Elastic Container Registry (ECR)**: A fully-managed Docker container registry for storing and retrieving Docker images.
- **Application Load Balancer (ALB)**: A load balancer that distributes incoming traffic across your ECS tasks.
- **AWS Key Management Service (KMS) Key**: A secure and managed key for encrypting sensitive data.
- **CloudWatch Log groups**: A monitoring service that collects and stores logs from your containerized applications.

Additionally, this repository includes:

- **Dockerfile**: A [file](./app/Dockerfile) containing instructions for building a Docker image for the application.
- **GitHub Actions Workflows**:
    - A [CI/CD pipeline defined in a YAML file](./.github/workflows/app-ci-cd.yml) that automatically builds the Docker image, pushes it to the ECR registry, and deploys the updated service to the ECS cluster.
    - A [separate workflow](./.github/workflows/terraform.yml) that uses Terraform to provision and manage the ECS infrastructure components.
    - A [Checkov pipeline](./.github/workflows/code-scan.yml) for scanning the Terraform code for security and compliance issues.

The entire setup and deployment process is automated via the GitHub Actions pipelines, eliminating the need for manual steps. If you are interested in learning about the provisioning process of the AWS cloud infrasctructure components using Terraform and GitHub Actions, please check out [create-infrastructure-to-host-an-amazon-ecs-service-using-terraform.](http://skundunotes.com/2024/04/10/create-infrastructure-to-host-an-amazon-ecs-service-using-terraform/)
## Prerequisites
For this code to function without errors, I created an OpenID connect identity provider in Amazon Identity and Access Management that has a trust relationship with this GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.
<br />I stored the `ARN` of the `IAM Role` as a GitHub secret which is referred in the [`terraform.yml`]() file.
<br />As part of the **Infracost** integration, I also created a `INFRACOST_API_KEY` and stored that as a GitHub Actions secret. I also managed the cost estimate process using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.
<br />You can read about that at - [integrate-Infracost-with-GitHub-Actions.](http://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/)
## Usage
Ensure that the policy/ies attached to the IAM role whose credentials are being used in this repository has permission to create and manage all the resources that are included in this repository and push the Docker image to Amazon ECR repository.
<br />
<br />Review the code including the [`terraform.yml`](./.github/workflows/terraform.yml) to understand the steps in the GitHub Actions pipeline. Also review the `terraform` code to understand all the concepts associated with creating an AWS VPC, subnets, security groups, internet gateway, VPC endpoints, route table, and route table association, Amazon ECR, ECS Cluster, load balancer, target groups, KMS key and CloudWatch log groups.
<br />If you want to check the pipeline logs, click on the **Build Badge** (terrform-infra-provisioning) above the image in this ReadMe.

## Contributing

If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!

## License
This code is released under the Unlicense License. See [LICENSE](LICENSE).