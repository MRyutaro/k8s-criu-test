# apiserver が kubelet に話すときのクライアント証明書を流用
sudo cp /etc/kubernetes/pki/apiserver-kubelet-client.crt .
sudo cp /etc/kubernetes/pki/apiserver-kubelet-client.key .

# kubelet が使っている CA も取っておく
sudo cp /etc/kubernetes/pki/ca.crt .

# 権限調整
sudo chown $USER:$USER apiserver-kubelet-client.crt apiserver-kubelet-client.key ca.crt
chmod 600 apiserver-kubelet-client.key
