## EKS on Fargate
* [EKS on Fargate：virtual-kubelet の違い + Network/LB 周りの調査](https://amsy810.hateblo.jp/entry/2019/12/04/151642)
* [AWS Distro for OpenTelemetry を使用した CloudWatch Container Insights の EKS Fargate サポートのご紹介](https://aws.amazon.com/jp/blogs/news/introducing-amazon-cloudwatch-container-insights-for-amazon-eks-fargate-using-aws-distro-for-opentelemetry/)
  * `1 つ目の Fargate プロファイルは fargate-container-insights という名前で、fargate-container-insights という Namespace を指定します。` ここを

## Bottlerocket
* AWS blogのbottletocketタグ https://aws.amazon.com/jp/blogs/news/tag/bottlerocket/
  * 基本ここみる
* [Bottlerocket を使ってみよう！](https://qiita.com/Anorlondo448/items/8a6125ee17825503306d)

## Karpenter
### 資料
* https://aws.amazon.com/jp/blogs/news/introducing-karpenter-an-open-source-high-performance-kubernetes-cluster-autoscaler/ Karpenter のご紹介 – オープンソースの高性能 Kubernetes Cluster Autoscaler
* https://qiita.com/takaf04/items/2f8875c0196f1d0aee3f Karpenterでなにがうれしいのか試してみた！
* https://blog.inductor.me/entry/2021/12/06/165743 Karpenterのファーストインプレッション
* https://blog.recruit.co.jp/rmp/infrastructure/aws-oss-cluster-autoscaler-karpenter/ AWS OSS製の高速Cluster Autoscaler Karpenter

## ハマったポイント

### Bottlerocket
* [Do not collect pod metrics using Bottlerocket #1071](https://github.com/aws-observability/aws-otel-collector/issues/1071)


### AWS Loadbalancer
* VPC id は指定する https://github.com/awsdocs/amazon-eks-user-guide/pull/245

### Karpenter
* Fargateの場合はfargateProfileを作っておく
