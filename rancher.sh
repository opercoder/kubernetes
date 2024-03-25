#DO AS ROOT - SUDO DOESNT INCLUDED
#ALL NODES:
apt-get -y install curl apt-transport-https git iptables-persistent
tee -a /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
overlay
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
EOF
sysctl --system
modprobe br_netfilter
modprobe overlay
swapoff -a

sed -i 's/^.*swap.*$/#&/g' /etc/fstab 

#MASTER:
mkdir -p /etc/rancher/rke2
cat > /etc/rancher/rke2/config.yaml <<EOF
tls-san:
  - fzo-master1.fors.ru
  - fzo-slave1.fors.ru
  - fzo-slave2.fors.ru
cni: calico
debug: true
EOF

curl -sfL https://get.rke2.io --output install.sh
chmod +x install.sh
INSTALL_RKE2_CHANNEL=v1.28 ./install.sh
systemctl enable rke2-server.service
systemctl start rke2-server.service

#WORKER NODES:
curl -sfL https://get.rke2.io --output install.sh
chmod +x install.sh
INSTALL_RKE2_CHANNEL=v1.28 INSTALL_RKE2_TYPE="agent" ./install.sh
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/
cat > /etc/rancher/rke2/config.yaml <<EOF
server: https://fzo-master1.fors.ru:9345
token: K109f173499566cd4206f0ef87865ea485f96fb97943f8a9131f1073e4f4da36504::server:b573d1a335a3b25fce11406a16d00ed4
EOF
systemctl start rke2-agent.service

#INSTALL CERTMANAGER
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager   --namespace cert-manager   --create-namespace   --set installCRDs=true

#INSTALL RANCHER
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher --version 2.8.3-rc5 --namespace cattle-system --set hostname=fzo-master1.fors.ru
helm install my-rancher rancher-latest/rancher --version 2.8.3-rc5
admin
HnuuLRGvVTmMVlZB