
## Create Cluster

```
eksctl create cluster --config-file=fargate_sample.yaml
export KARPENTER_VERSION=v0.8.0
export CLUSTER_NAME="hpa-vpa-fargate-demo"
export AWS_DEFAULT_REGION="ap-northeast-1"
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
```

## Cluster Setup

```
aws sts get-caller-identity --query Account --output text
eksctl create iamidentitymapping --cluster hpa-vpa-fargate-demo --arn xxxx --group system:masters --username xxxx
```

## Install ALB controller
xxxx は適切に変える

```
eksctl create iamserviceaccount \
--cluster=hpa-vpa-fargate-demo \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region ap-northeast-1 \
--approve
```

```
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=hpa-vpa-fargate-demo --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set vpcId=vpc-xxxx
```

確認
```
kubectl get pods -n kube-system
kubectl logs aws-load-balancer-controller-xxx -n kube-system
```

## HPA用metric-server

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## ADOT
https://aws.amazon.com/jp/blogs/news/introducing-amazon-cloudwatch-container-insights-for-amazon-eks-fargate-using-aws-distro-for-opentelemetry/

```
sh adot.sh
kubectl apply -f kuberbetes/adot.yaml
```

## Karpenter

```
export KARPENTER_VERSION=v0.8.0
export CLUSTER_NAME="hpa-vpa-fargate-demo"
export AWS_DEFAULT_REGION="ap-northeast-1"
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${CLUSTER_NAME} --query "cluster.endpoint" --output text)"


TEMPOUT=$(mktemp)
curl -fsSL https://karpenter.sh/"${KARPENTER_VERSION}"/getting-started/getting-started-with-eksctl/cloudformation.yaml  > $TEMPOUT \
&& aws cloudformation deploy \
  --stack-name "Karpenter-${CLUSTER_NAME}" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=${CLUSTER_NAME}"

eksctl create iamidentitymapping \
  --username system:node:{{EC2PrivateDNSName}} \
  --cluster "${CLUSTER_NAME}" \
  --arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --group system:bootstrappers \
  --group system:nodes

eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --name karpenter --namespace karpenter \
  --role-name "${CLUSTER_NAME}-karpenter" \
  --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}" \
  --role-only \
  --approve

export KARPENTER_IAM_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER_NAME}-karpenter"
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com || true

helm repo add karpenter https://charts.karpenter.sh/
helm repo update

helm upgrade --install --namespace karpenter --create-namespace \
  karpenter karpenter/karpenter \
  --version ${KARPENTER_VERSION} \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set clusterName=${CLUSTER_NAME} \
  --set clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${CLUSTER_NAME} \
  --wait # for the defaulting webhook to install before creating a Provisioner
```

確認
```
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```

### debug
https://karpenter.sh/v0.8.0/development-guide/

Log Levelの変更

```
kubectl patch configmap config-logging -n karpenter --patch '{"data":{"loglevel.controller":"debug"}}'
```

Provisonerの設定

```
kubectl apply -f kuberbetes/karpenter_provisioner.yaml
```

## appのdeploy

```
kubectl apply -f kuberbetes/high_load_sample_server.yaml 
```
