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
    - name: Обновляем apt cache
      shell: 'apt-get clean && apt-get update'
    - name: Install packages
      apt: 
        pkg:
          - vim
          - htop
    - name: Подключаем репозиторий
      shell: curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    - name: Подключаем репозиторий
      shell: echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    - name: Подключаем репозиторий
      shell: echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    - name: Обновление репозитория
      shell: apt-get update
    - name: Установка доп. пакетов
      shell: apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    - name: Установка докер
      shell: apt-get install -y docker-ce docker-ce-cli containerd.io
    - name: Установка пакетов Kubernetes
      shell: apt-get install -y kubelet kubeadm kubectl --allow-change-held-packages
    - name: Запрещаем обновлять Kubernetes
      shell: apt-mark hold kubelet kubeadm kubectl
    - name: Для докера
      shell: mkdir -p /etc/docker
    - name: Change Docker daemon.json
      ansible.builtin.copy:
        src: /etc/ansible/daemon.json
        dest: /etc/docker/daemon.json
        follow: yes
    - name: Create dir for certificate
      ansible.builtin.file:
        path: "/etc/docker/certs.d/"
        state: directory
        mode: '0755'
    - name: Create dir for certificate
      ansible.builtin.file:
        path: "/etc/docker/certs.d/registry.sirius.mix:5000/"
        state: directory
        mode: '0755'
    - name: Копируем сертификат
      ansible.builtin.copy:
        src: "ca.crt"
        dest: "/etc/docker/certs.d/registry.sirius.mix:5000/ca.crt"
        owner: root
        group: root
        mode: '0644'
    - name: Перезапускаем Docker
      shell: 'systemctl enable docker && systemctl daemon-reload && systemctl restart docker'
    - name: Отключаем swap на Ubuntu 18.04
      shell: 'if [ -f "/swap.img" ] ; then swapoff -v /swap.img; fi && sed -i /swap/d /etc/fstab && if [ -f "/swap.img" ] ; then rm /swap.img; fi'
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
        --control-plane --certificate-key xxx --apiserver-advertise-address <local_ip_which will_be_listen>
```
**5)Then you can join any number of worker nodes by running the following on each as root:**  
``` bash
kubeadm join control-plane.sirius.mix:6443 --token xxx \
        --discovery-token-ca-cert-hash sha256:xxx 
```  
**5.1) If you do not have the token, you can get it by running the following command on the control-plane node:**  
`kubeadm token list`  
By default, tokens expire after 24 hours. For create a new token: `kubeadm token create`  
You can get `--discovery-token-ca-cert-hash` by running the following command chain on the control-plane node:  
``` bash 
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
  openssl dgst -sha256 -hex | sed 's/^.* //'
```
You can get `--certificate-key` by running the following command chain on the control-plane node:  
``` bash 
kubeadm init phase upload-certs --upload-certs
```
**6) In order to get a kubectl on some other computer(e.g. laptop) to talk to your cluster, you need to copy the admin kubeconfig file
from your control-plane node to your workstation like this:**  
``` bash
scp root@control-plane:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get nodes

```
**7) Install Dashboard:**  
The dashboard will be accessible from the localhost:
``` bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml  
```
The dashboard will be accessible remotely:  
``` bash
kubectl --namespace kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'`  
```
Create the patch file:  
``` bash
$ nano nodeport_dashboard_patch.yaml
spec:
  ports:
  - nodePort: 32000
    port: 443
    protocol: TCP
    targetPort: 8443`
```
Apply the patch:
``` bash
kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard --patch "$(cat nodeport_dashboard_patch.yaml)"  
```
Confirm thet the service was actually created:
``` bash
$ kubectl get service -n kubernetes-dashboard  
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.103.159.77   <none>        8000/TCP        8m40s
kubernetes-dashboard        NodePort    10.101.194.22   <none>        443:32000/TCP   8m40s
```
The dashboard is available on the port 32000:
``` bash
https://<ip or domain-name>:32000
```
**How to create an admin user who has access to all Kubernetes resources.**  
Create Admin service account
``` bash
$ vim admin-sa.yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kubernetes-dashboard
```
Apply the manifest:  
``` bash
kubectl apply -f admin-sa.yml
```
Assign the service account created a cluster role binding of cluster-admin.  
``` bash
$ vim admin-rbac.yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kubernetes-dashboard
```
Apply the manifest:  
``` bash
kubectl apply -f admin-rbac.yml
```
Run the command below to print the token for the admin user created.
``` bash
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```
***
