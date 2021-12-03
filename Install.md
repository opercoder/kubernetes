# Install
**1) Run ansible's playbook on kube hosts.**
``` bash
ansible-playbook kubernetes_install.yml
```
**kubernetes_install.yml**
``` bash
- hosts: kube
  become: true
  strategy: free
  tasks:
    - name: Update apt cache
      shell: 'apt-get clean && apt-get update'
    - name: Установка Kubernetes
      ansible.builtin.shell: |
        apt-get install -y apt-transport-https ca-certificates curl
        curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
        echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
        apt-get update
        apt-get install -y kubelet kubeadm kubectl
        apt-mark hold kubelet kubeadm kubectl
        mkdir /etc/docker
        exit 0
    - name: Change Docker daemon.json
      ansible.builtin.copy:
        src: /etc/ansible/daemon.json
        dest: /etc/docker/daemon.json
        follow: yes
    - name: Restart Docker
      shell: 'systemctl enable docker && systemctl daemon-reload && systemctl restart docker'
    - name: Turn off swap on Ubuntu 18.04
      shell: 'if [ -f "/swap.img" ] ; then swapoff -v /swap.img; fi && sed -i /swap/d /etc/fstab && if [ -f "/swap.img" ] ; then rm /swap.img; fi'
    - name: Install packages
      apt: 
        pkg:
          - vim
          - htop
          - docker.io
```
**daemon.json**
``` bash
{ 
  "exec-opts": ["native.cgroupdriver=systemd"],  
  "log-driver": "json-file",  
  "log-opts": {  
    "max-size": "100m"  
  },  
  "storage-driver": "overlay2"  
}  
```

**2) Run Cluster**\
[HowTo](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)  
On a control-plane node:
`kubeadm init --control-plane-endpoint dnsname_or_ipaddress:6443  --upload-certs`  
If you run the command without control-plane-endpoint, highly available cluster will not be supported by kubeadm.  

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:
``` bash
  mkdir -p $HOME/.kube  
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config  
  sudo chown $(id -u):$(id -g) $HOME/.kube/config  
```
or as root:
``` bash
export KUBECONFIG=/etc/kubernetes/admin.conf

```

**3) You should now deploy a pod network to the cluster.**  
Run `kubectl apply -f [podnetwork].yaml` with one of the options listed at:  
https://kubernetes.io/docs/concepts/cluster-administration/addons/  
For example,  
`kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`

**4) You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:**  
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
``` bash
  kubeadm join control-plane.sirius.mix:6443 --token xxx \
        --discovery-token-ca-cert-hash sha256:xxx \
        --control-plane --certificate-key xxx
```
**5)Then you can join any number of worker nodes by running the following on each as root:**  
``` bash
kubeadm join control-plane.sirius.mix:6443 --token xxx \
        --discovery-token-ca-cert-hash sha256:xxx 
```  
**5.1) If you do not have the token, you can get it by running the following command on the control-plane node:**  
`kubeadm token list`  
By default, tokens expire after 24 hours. For create a new token: `kubeadm token create`  
You can get `--discovery-token-ca-cert-hash` by runnig the following command chain on the control-plane node:  
``` bash 
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
  openssl dgst -sha256 -hex | sed 's/^.* //'
```
**6) In order to get a kubectl on some other computer(e.g. laptop) to talk to your cluster, you need to copy the admin kubeconfig file
from your control-plane node to your workstation like this:**  
``` bash
scp root@control-plane:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get nodes

```
**7) Install Dashboard**
The dashboard will be accessible from the localhost:
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml`  
The dashboard will be accessible remotely:  
`kubectl --namespace kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'`  
Create a patch file:  
``` bash
$ nano nodeport_dashboard_patch.yaml
spec:
  ports:
  - nodePort: 32000
    port: 443
    protocol: TCP
    targetPort: 8443`
```
***
