# k8s-criu-test

- kubeadm: v1.32.10
- kubectl
  - Client Version: v1.32.10
  - Kustomize Version: v5.5.0
  - Server Version: v1.32.10
- CRI-O: 1.34.3
- CRIU: 4.1.1

## 2ノードでKubernetesクラスタ構築
2ノードでkubernetseクラスタを構築するところまでやる

参考にした記事
- クラスタの構築
  - https://zenn.dev/moz_sec/articles/k8s-by-kubeadm
  - https://qiita.com/murata-tomohide/items/cd408dbed0211fedf5dc
- CRI-Oのインストール
  - https://github.com/cri-o/packaging/blob/main/README.md#distributions-using-deb-packages

sudo swapoff -a
/etc/fstabでswapをコメントアウト

kubeadm, kubelet, kubectlのインストール

CRI-Oのインストール

クラスタをjoinさせる
```
kubeadm join 192.168.20.150:6443 --token <表示されたTOKEN> \
	--discovery-token-ca-cert-hash <表示されたHASH>
```

結果
```
matsumoto@neko:~$ kubectl get nodes
NAME   STATUS     ROLES           AGE   VERSION
inu    NotReady   <none>          13s   v1.32.10
neko   NotReady   control-plane   15m   v1.32.10
```

CNIのインストール
```
matsumoto@neko:~$ kubectl get pods -A
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   coredns-668d6bf9bc-6tn57       0/1     Pending   0          21m
kube-system   coredns-668d6bf9bc-k6kkw       0/1     Pending   0          21m
kube-system   etcd-neko                      1/1     Running   1          22m
kube-system   kube-apiserver-neko            1/1     Running   1          22m
kube-system   kube-controller-manager-neko   1/1     Running   1          22m
kube-system   kube-proxy-2nrq2               1/1     Running   0          21m
kube-system   kube-proxy-lbhzv               1/1     Running   0          6m37s
kube-system   kube-scheduler-neko            1/1     Running   1          22m

matsumoto@neko:~$ kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
~省略~

matsumoto@neko:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS     RESTARTS   AGE
kube-system   calico-kube-controllers-7498b9bb4c-7vwzl   0/1     Pending    0          2s
kube-system   calico-node-p7g2g                          0/1     Init:0/3   0          2s
kube-system   calico-node-qbpb2                          0/1     Init:0/3   0          2s
kube-system   coredns-668d6bf9bc-6tn57                   0/1     Pending    0          22m
kube-system   coredns-668d6bf9bc-k6kkw                   0/1     Pending    0          22m
kube-system   etcd-neko                                  1/1     Running    1          22m
kube-system   kube-apiserver-neko                        1/1     Running    1          22m
kube-system   kube-controller-manager-neko               1/1     Running    1          22m
kube-system   kube-proxy-2nrq2                           1/1     Running    0          22m
kube-system   kube-proxy-lbhzv                           1/1     Running    0          6m49s
kube-system   kube-scheduler-neko                        1/1     Running    1          22m

matsumoto@neko:~$ kubectl get nodes
NAME   STATUS   ROLES           AGE     VERSION
inu    Ready    <none>          7m38s   v1.32.10
neko   Ready    control-plane   23m     v1.32.10
```

## criuでのチェックポイント
criuの設定をしてpodのチェックポイントをとるところまでやる

証明書を持ってくる

criuのインストール
```
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:criu/ppa
sudo apt update
sudo apt install -y criu
```

crioでcriuを使えるようにする
sudo vi /etc/crio/crio.conf.d/10-crio.conf
manage_network_ns_lifecycle = true

applyする

kubeletのapiを叩いてcriuでチェックポイントがとれることを確認
matsumoto@neko:~/k8s-criu-test$ ./checkpoint.sh
Node IP = 192.168.20.149
{"items":["/var/lib/kubelet/checkpoints/checkpoint-counters_default-counter-2025-12-03T07:44:30Z.tar"]}
