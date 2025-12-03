# 証明書の設定
USER=$(whoami)
cp /home/${USER}/.minikube/profiles/minikube/client.crt ./client-admin.crt
cp /home/${USER}/.minikube/profiles/minikube/client.key ./client-admin.key
chmod 600 client-admin.key
