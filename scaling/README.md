## ハマったこと

### CPUとメモリをもとにしたHPAとVPAは共存できない
* https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#known-limitations

```
Vertical Pod Autoscaler should not be used with the Horizontal Pod Autoscaler (HPA) on CPU or memory at this moment. However, you can use VPA with HPA on custom and external metrics.
```

カスタムメトリクスを使えば共存可能

例 : CPUやmemoryをVPAして、request per secやp95latencyでHPAする

* https://qiita.com/Ladicle/items/812c7cbee51c7ae8ccac


