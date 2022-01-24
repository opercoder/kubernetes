## On ceph's host
#### 1. Create a pool.
``` bash
ceph osd pool create kubernetes
```
#### 2. Initialize the pool.
``` bash
ceph osd pool create kubernetes
```
#### 3. Create a new user for Kubernetes and ceph-csi.
``` bash
ceph auth get-or-create client.kubernetes mon 'profile rbd' osd 'profile rbd pool=kubernetes' mgr 'profile rbd pool=kubernetes'
```
Record the generated key:  
>\[client.kubernetes\]  
>	 key = AQCyW+5hy/zMMRAAXWG2mapEirEl6qvH9hO28g==
#### 4. The ceph-csi requires a ConfigMap object stored in Kubernetes to define the the Ceph monitor addresses for the Ceph cluster. Collect both the Ceph cluster unique fsid and the monitor addresses:
``` bash
ceph mon dump
```
> fsid b9127830-b0cc-4e34-aa47-9d1a2e9949a8  
> 0: [v2:192.168.1.1:3300/0,v1:192.168.1.1:6789/0] mon.a  
> 1: [v2:192.168.1.2:3300/0,v1:192.168.1.2:6789/0] mon.b  
> 2: [v2:192.168.1.3:3300/0,v1:192.168.1.3:6789/0] mon.c  
#### 5. Recent versions of ceph-csi also require an additional ConfigMap object to define Key Management Service (KMS) provider details. If KMS isn’t set up, put an empty configuration:
``` bash
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    {}
metadata:
  name: ceph-csi-encryption-kms-config
```
> kubectl apply -f csi-kms-config-map.yaml
#### 6. Recent versions of ceph-csi also require yet another ConfigMap object to define Ceph configuration to add to ceph.conf file inside CSI containers:
``` bash
apiVersion: v1
kind: ConfigMap
data:
  ceph.conf: |
    [global]
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
  # keyring is a required key and its value should be empty
  keyring: |
metadata:
  name: ceph-config
```
> kubectl apply -f ceph-config-map.yaml
## On kubernetes's hosts
#### 1. Generate a csi-config-map.yaml file:
``` bash
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    [
      {
        "clusterID": "b9127830-b0cc-4e34-aa47-9d1a2e9949a8",
        "monitors": [
          "192.168.1.1:6789",
          "192.168.1.2:6789",
          "192.168.1.3:6789"
        ]
      }
    ]
metadata:
  name: ceph-csi-config
```
> kubectl apply -f csi-config-map.yaml
#### 2. Create yaml file for secret:
``` bash
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
  namespace: default
stringData:
  userID: kubernetes
  key: AQCyW+5hy/zMMRAAXWG2mapEirEl6qvH9hO28g==
```
#### 3. Create the required ServiceAccount and RBAC ClusterRole/ClusterRoleBinding Kubernetes objects:
``` bash
kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-provisioner-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-nodeplugin-rbac.yaml
```
#### 4. Create the ceph-csi provisioner and node plugins:
> Important: write actual stable version from https://quay.io/repository/cephcsi/cephcsi?tag=latest&tab=tags
``` bash
wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml
kubectl apply -f csi-rbdplugin-provisioner.yaml
wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml
kubectl apply -f csi-rbdplugin.yaml
```
