## Node 
* メモリの消費量
   * 実メモリ(docker daemonも含むメモリをみる)
### eviction
ノードを正常に動かし続けるためのセーフティネット
* https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/
* https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/

* http://nekop.github.io/slides/hbstudy78.html#/14

#### diskの容量
古いdocker imageを消してくれる
https://kubernetes.io/docs/concepts/cluster-administration/kubelet-garbage-collection/#image-collection

* コード 
    * https://github.com/kubernetes/kubernetes/blob/a3ccea9d8743f2ff82e41b6c2af6dc2c41dc7b10/pkg/kubelet/images/image_gc_manager.go#L258

#### memory
eviciotnが走るとPodが死ぬ可能性あり
