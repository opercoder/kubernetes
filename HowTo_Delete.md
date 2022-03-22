#### 1. Safely remove a node from a cluster.
``` bash 
kubectl drain <node_name> --ignore-daemonsets
```
#### 2. If you leave the node in the cluster during the maintenance operation, you need to run:
``` bash 
kubectl uncordon <node_name>
```
 
