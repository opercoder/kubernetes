### A few type of volumes:
- emptyDir
- hostPath
- nfs
- gcePersistentDisk
- configMap, secret
- cephfs, glusterfs

#### emptyDir 
It is useful to share files between the containers running in one pod. When the pod is removed from a node for any reason, the data in the emptyDir is deleted.
**Example of the yaml file:**  
``` bash
apiVersion: v1
kind: Pod
metadata:
  name: fortune
spec:
  containers:
  - image: luksa/fortune
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    emptyDir: {}     // local disk
        or
    emptyDir:
      medium: Memory // tmpfs
```
#### hostPath
A hostPath volume mounts a file or directory from the host node's filesystem into your Pod.  
HostPath volumes present many security risks, and it is a best practice to avoid the use of HostPaths when possible. When a HostPath volume must be used, it should be scoped to only the required file or directory, and mounted as ReadOnly.
#### nfs
``` bash
volumes:
  - name: db-data
    nfs:
      server: 1.1.1.1
      path: /some/path
```
#### StorageClass
``` bash
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: ceph
provisioner: rbd.csi.ceph.com
parameters:
   clusterID: 1785241c-51b1-11ec-a431-b9cfb200a6c1
   pool: kubernetes
   imageFeatures: layering
   csi.storage.k8s.io/provisioner-secret-name: csi-rbd-secret
   csi.storage.k8s.io/provisioner-secret-namespace: default
   csi.storage.k8s.io/controller-expand-secret-name: csi-rbd-secret
   csi.storage.k8s.io/controller-expand-secret-namespace: default
   csi.storage.k8s.io/node-stage-secret-name: csi-rbd-secret
   csi.storage.k8s.io/node-stage-secret-namespace: default
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
   - discard
```


