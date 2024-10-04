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
              "ContainerName" = "first"
              "ContainerPort" = 8080
            }
          }
        }
      }
    ]
  }

  appspec_content = replace(jsonencode(local.appspec), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.appspec))

  # create deployment script
  script = <<EOF
#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
echo "Starting CodeDeploy agent deployment"
aws --version

DEPLOYMENT_INFO=$(aws deploy create-deployment \
    --application-name ${aws_codedeploy_app.application_main.name} \
    --deployment-config-name CodeDeployDefault.OneAtATime \
    --deployment-group-name ${aws_codedeploy_deployment_group.application_main.deployment_group_name} \
    --revision '{"revisionType":"AppSpecContent","appSpecContent":{"content":"${local.appspec_content}","sha256":"${local.appspec_sha256}"}}' \
    --description "Deployment from Terraform" \
    --output json)

if [ $? -ne 0 ]; then
    echo "Failed to create deployment."
    exit 1
fi

ID=$(echo \$DEPLOYMENT_INFO | jq -r '.deploymentId')
STATUS=$(echo \$DEPLOYMENT_INFO | jq -r '.deploymentInfo.status')
echo "waiting for deployment to complete"

while [[ "\$STATUS" == "Created" || "\$STATUS" == "InProgress" || "\$STATUS" == "Pending" || "\$STATUS" == "Queued" || "\$STATUS" == "Ready" ]]; do
    echo "Deployment status: \$STATUS"
    STATUS=$(aws deploy get-deployment \
        --deployment-id "\$ID" \
        --output json | jq -r '.deploymentInfo.status')
    echo "waiting for 30 seconds."
    sleep 30
done

if [ "\$STATUS" == "Succeeded" ]; then
    echo "Deployment \$ID succeeded"
else
    echo "Deployment \$ID failed with status \$STATUS"
    exit 1
fi
EOF
}


#Create the code_deploy.sh file to run the AWS CodeDeploy deployment
#https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "code_deploy_sh" {
  content  = local.script
  filename = "${path.module}/code_deploy.sh"
  depends_on = [
    aws_codedeploy_app.application_main,
    aws_codedeploy_deployment_group.application_main,
    aws_ecs_task_definition.web_app
  ]
}

#Execute the code_deploy.sh file to run the AWS CodeDeploy deployment
#https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "code_deploy" {
  provisioner "local-exec" {
    command     = "./code_deploy.sh"
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [local_file.code_deploy_sh]
}
