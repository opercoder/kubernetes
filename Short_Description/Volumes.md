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
