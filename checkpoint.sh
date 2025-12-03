NODE_IP=192.168.20.149  # podがある方のノード
echo "Node IP = $NODE_IP"

curl --insecure \
  --cert apiserver-kubelet-client.crt \
  --key apiserver-kubelet-client.key \
  --cacert ca.crt \
  -X POST "https://${NODE_IP}:10250/checkpoint/default/counters/counter"
