## メモ

### UnschedulableなPod
Podの `Pending` のPhaseとして定義はされるがこれはkube-scheduleでの状態とは別の話

https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-does-scale-up-work


Phaseの初期化は多分ここ

https://github.com/kubernetes/kubernetes/blob/c2882f314218af489267b7163b2ca09c79ffb00a/pkg/registry/core/pod/strategy.go#L82-L92

kubeletまわり

https://github.com/kubernetes/kubernetes/blob/24a71990e02edbfd0a05f4abfdedcab991525874/pkg/kubelet/kubelet.go#L1500

## ハマったこと

### CPUとメモリをもとにしたHPAとVPAは共存できない
* https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#known-limitations

```
Vertical Pod Autoscaler should not be used with the Horizontal Pod Autoscaler (HPA) on CPU or memory at this moment. However, you can use VPA with HPA on custom and external metrics.
```

カスタムメトリクスを使えば共存可能

例 : CPUやmemoryをVPAして、request per secやp95latencyでHPAする

* https://qiita.com/Ladicle/items/812c7cbee51c7ae8ccac


## 資料
* https://speakerdeck.com/bells17/cluster-autoscaler Cluster Autoscaler Kubernetes Meetup Tokyo #49
* https://ccvanishing.hateblo.jp/entry/2018/10/02/203205 猫でもわかる Vertical Pod Autoscaler
* https://developer.mamezou-tech.com/containers/k8s/tutorial/ops/hpa/ オートスケーリング - Horizontal Pod Autoscaler(HPA)
