data "aws_caller_identity" "current" {}
locals {
  principal_root_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  development_account      = "743794601996"
  development_env_root_arn = "arn:aws:iam::${local.development_account}:root"
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
resource "aws_ecr_repository" "image_repo" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_kms_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
# ECR Repository policy for cross-account access
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy
resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.image_repo.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountPull"
        Effect = "Allow"
        Principal = {
          AWS = "${local.development_env_root_arn}"
        }
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
      }
    ]
  })
}