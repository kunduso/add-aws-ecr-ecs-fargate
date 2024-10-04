#!/bin/bash
echo "Starting CodeDeploy agent deployment"
aws --version

DEPLOYMENT_INFO=$(aws deploy create-deployment \
    --application-name app-6 \
    --deployment-config-name CodeDeployDefault.OneAtATime \
    --deployment-group-name app-6-deploy-group \
    --revision '{"revisionType":"AppSpecContent","appSpecContent":{"content":"{\"Resources\":[{\"TargetService\":{\"Properties\":{\"LoadBalancerInfo\":{\"ContainerName\":\"first\",\"ContainerPort\":8080},\"TaskDefinition\":\"arn:aws:ecs:us-east-2:743794601996:task-definition/app-6:39\"},\"Type\":\"AWS::ECS::Service\"}}],\"version\":0}","sha256":"db536aa77e74e9e6d1683cea5d89c8781fe573cc24e5a3e833a3e64ba58b67aa"}}' \
    --description "Deployment from Terraform" \
    --output json)
ID=$(echo $DEPLOYMENT_INFO | jq -r '.deploymentId')
STATUS=$(echo $DEPLOYMENT_INFO | jq -r '.deploymentInfo.status')
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
