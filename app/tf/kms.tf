# Create a KMS key for encryption
resource "aws_kms_key" "ecr_kms_key" {
  description             = "KMS key to encrypt ECR images in central AWS account."
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
# KMS key policy allowing AccountB to use the key for ECR image encryption/decryption
resource "aws_kms_alias" "ecr_key_alias" {
  name          = "alias/${var.name}-ecr-repository-key"
  target_key_id = aws_kms_key.ecr_kms_key.key_id
}

resource "aws_kms_key_policy" "ecr_key_policy" {
  key_id = aws_kms_key.ecr_kms_key.key_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow Central AWS account to perform any KMS actions
      {
        Sid    = "Enable IAM User Permissions"
        Action = ["kms:*"]
        Effect = "Allow"
        Principal = {
          AWS = "${local.principal_root_arn}"
        }
        Resource = "*"
      },
      # Allow Dev environment to use the KMS key for decryption
      {
        Effect = "Allow"
        Principal = {
          AWS = "${local.development_env_root_arn}"
        }
        Action   = ["kms:Decrypt"]
        Resource = "*"
      }
    ]
  })
}