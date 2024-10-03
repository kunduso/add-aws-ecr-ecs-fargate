data "aws_iam_policy_document" "assume_by_codedeploy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  name               = "${var.name}-code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
}


data "aws_iam_policy_document" "codedeploy" {
  statement {
    sid    = "AllowLoadBalancingAndECSModifications"
    effect = "Allow"
    actions = [
      "ecs:CreateTaskSet",
      "ecs:DeleteTaskSet",
      "ecs:DescribeServices",
      "ecs:UpdateServicePrimaryTaskSet"
    ]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/*",
      "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:listener/*",
      "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:targetgroup/*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = "s3:GetObject"
    resources = [
      "arn:aws:s3:::*/*"
    ]
  }
  statement {
    sid    = "AllowPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = [
      aws_iam_role.ecs_task_execution_role.arn
    ]
  }
  statement {
    sid    = "DeployService"
    effect = "Allow"
    actions = [
      "codedeploy:GetDeploymentGroup",
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = [
      "arn:aws:codedeploy:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}
resource "aws_iam_role_policy" "codedeploy" {
  role   = aws_iam_role.codedeploy.name
  policy = data.aws_iam_policy_document.codedeploy.json
}