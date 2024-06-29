#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-task-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
          },
          "StringEquals" : {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ]
  })
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-task-execution-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
#Attach role to policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "${var.name}-ecs-fargate-secrets-manager-access"
  description = "IAM policy for ECS Fargate to access Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [local.infra_output["secret_arn"]]
      }
    ]
  })
}
#Attach role to policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "attach_secrets_read_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager_read_policy.arn
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "${var.name}-kms-decrypt"
  description = "IAM policy ro decrypt the Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ]
        Resource = [aws_kms_key.encryption_rest.arn]
      }
    ]
  })
}

#Attach role to policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "attache_kms_decrypt_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}