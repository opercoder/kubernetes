#### 1. Prohibition to create new podes on a node:
``` bash 
kubectl cordon <node_name>
```
#### 2. Safely drain a node.
``` bash 
kubectl drain <node_name> --ignore-daemonsets
```
#### 3. Delete a node from a cluster:
``` bash 
kubectl delete no <node_name>
```
#### 4. Delete kubernetes software from a node:
``` bash 
echo y | kubeadm reset
apt-get purge -y --allow-change-held-packages kubelet kubeadm kubectl vim htop docker docker.io docker-engine containerd runc
apt-get -y autoremove
rm -rf /etc/kubernetes/*
rm -rf /root/.kube/
```

