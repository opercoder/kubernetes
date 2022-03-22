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
kubectl delete <node_name>
```
 
