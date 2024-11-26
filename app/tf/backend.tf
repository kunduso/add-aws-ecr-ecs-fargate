terraform {
  backend "s3" {
    bucket  = "terraform-remote-state-076680484948"
    encrypt = true
    key     = "tf/add-aws-ecr-ecs-fargate/terraform.tfstate"
    region  = "us-east-2"
  }
}