#!/bin/bash
CLUSTER_NAME=hpa-vpa-fargate-demo
REGION=ap-northeast-1
SERVICE_ACCOUNT_NAMESPACE=fargate-container-insights
SERVICE_ACCOUNT_NAME=adot-collector
SERVICE_ACCOUNT_IAM_ROLE=EKS-Fargate-ADOT-ServiceAccount-Role-hpa-vpa-fargate-demo
SERVICE_ACCOUNT_IAM_POLICY=arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

eksctl create iamserviceaccount \
--cluster=$CLUSTER_NAME \
--region=$REGION \
--name=$SERVICE_ACCOUNT_NAME \
--namespace=$SERVICE_ACCOUNT_NAMESPACE \
--role-name=$SERVICE_ACCOUNT_IAM_ROLE \
--attach-policy-arn=$SERVICE_ACCOUNT_IAM_POLICY \
--approve
