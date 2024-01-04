terraform {
  backend "s3" {
    bucket  = "kunduso-terraform-remote-bucket"
    encrypt = true
    key     = "tf/add-aws-ecr-ecs-fargate/terraform.tfstate"
    region  = "us-east-2"
  }
}