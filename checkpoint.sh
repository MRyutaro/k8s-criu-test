NODE_IP=$(minikube ip)
echo "Node IP = $NODE_IP"

curl --insecure \
  --cert client-admin.crt \
  --key client-admin.key \
  -X POST "https://${NODE_IP}:10250/checkpoint/default/counters/counter"
