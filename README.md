# k8s-criu-test

- minikube version: v1.37.0
- docker version: 29.1.2

## 環境構築
```
minikube start \
  --driver=docker \
  --kubernetes-version=v1.30.0 \
  --container-runtime=cri-o \
  --cpus=4 \
  --memory=4096
```

```
minikube ssh   # ノードに入る
sudo apt-get update
sudo apt-get install -y criu buildah
```

podの作成
```
minikube kubectl -- apply -f pod.yaml
```

ログの確認
```
minikube kubectl -- logs -f counters
```

```
minikube kubectl -- get pods
```

kubectl logs -f -c counter counters

## 証明書
```
minikube ssh -- 'sudo cat /var/lib/minikube/certs/ca.crt' > kubelet-ca.crt
minikube ssh -- 'sudo cat /var/lib/minikube/certs/ca.key' > kubelet-ca.key
```

minikubeに入っている