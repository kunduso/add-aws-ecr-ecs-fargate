locals {
  # appspec file
  appspec = {
    version = 0.0
    Resources = [
      {
        TargetService = {
          Type = "AWS::ECS::Service"
          Properties = {
            TaskDefinition = aws_ecs_task_definition.web_app.arn
            LoadBalancerInfo = {
              "ContainerName" = "first" #var.container_name
              "ContainerPort" = 8080    #var.container_port
            }
          }
        }
      }
    ]
  }
  appspec_file   = replace(jsonencode(local.appspec), "/\"([0-9]+\\.?[0-9]*)\"/", "$1") # remove unnecessary decimal
  appspec_sha256 = sha256(jsonencode(local.appspec))

  # create deployment script
  script = <<EOF
#!/bin/bash
echo "Starting CodeDeploy agent deployment"
ID=$(aws deploy create-deployment \
    --application-name ${aws_codedeploy_app.application_main.name} \
    --deployment-config-name CodeDeployDefault.OneAtATime \
    --deployment-group-name ${aws_codedeploy_deployment_group.application_main.deployment_group_name} \
    --appspec-content "$(cat appspec.json)" \
    --description "Deployment from Terraform" \
    --output json | jq -r '.deploymentId')

echo "waiting for deployment to complete"
STATUS=$(aws deploy get-deployment \
  --deployment-id "$ID" \
  --output json | jq -r '.deploymentInfo.status')

while [ "$STATUS" == "Created" ] || [ "$STATUS" == "InProgress" ] || [ "$STATUS" == "Pending" ] || [ "$STATUS" == "Queued" ] || [ "$STATUS" == "Ready" ]; do
    echo "Deployment status: $STATUS"
    STATUS=$(aws deploy get-deployment \
        --deployment-id "$ID" \
        --output json | jq -r '.deploymentInfo.status')
    echo "waiting for 30 seconds."
    sleep 30
done

if [ "$STATUS" == "Succeeded" ]; then
    echo "Deployment $ID succeeded"
else
    echo "Deployment $ID failed"
    exit 1
fi
EOF
}

#Create the code_deploy.sh file to run the AWS CodeDeploy deployment
#https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "code_deploy_sh" {
  content              = local.script
  filename             = "${path.module}/code_deploy.sh"
  file_permission      = "0777"
  directory_permission = "0777"
  depends_on = [
    aws_codedeploy_app.application_main,
    aws_codedeploy_deployment_group.application_main,
    aws_ecs_task_definition.web_app
  ]
}

#Execute the code_deploy.sh file to run the AWS CodeDeploy deployment
#https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "terraform_data" "code_deploy" {
  provisioner "local-exec" {
    command     = "./code_deploy.sh"
    interpreter = ["bash", "-c"]
  }
  input            = local.appspec_sha256
  triggers_replace = local_file.code_deploy_sh
}
