# Cluster
1. **Common cluster information:**  
``` bash
kubectl cluster-info
```
2. **Cluster information about nodes:**  
``` bash
kubectl get nodes
```
3. **Detailed information about node:**  
``` bash
kubectl describe node <node_name>
```
4.1  **Print a list of pods:**  
``` bash
kubectl get pods
kubectl get pods -o wide
```
4.2  **Show additional information about pod:**  
``` bash
kubectl describe pods/<pod_name>
```
5. **Print a list of services:**  
``` bash
kubectl get svc
```
6.1 **Print a list of replication controllers:**  
``` bash
kubectl get rc
```
6.2 **Print a list of replication controllers:**  
``` bash
kubectl describe rc <rc_name>
```
7. **Show yaml file of the pod:**  
``` bash
kubectl get po <pod_name> -o yaml  
kubectl get po <pod_name> -o json  
```
**metadata** - include name, namespaces, tags and other additional information;  
**spec** (specification) - include pod's description: containers, volumes and other;  
**status** - include a current information about pod: status of each container, ip address and other base information.  
**Example of simple yaml manifest:**  
``` bash
apiVersion: v1  
kind: Pod  
metadata:  
  name: kubia-manual  
spec:  
  containers:  
  - image: opercoder/kubia  
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```
8. **Show competent fields for kubernetes objects:**
``` bash
kubectl explain pods
kubectl explain sc
kubectl explain pod.spec 
```
9. **Create a pod:**
``` bash
kubectl create -f <yaml_filename>  
```
10. **Show logs**
``` bash
kubectl logs <pod_name>
kubectl logs <pod_name> -c <container_name>
```
11. **Execute a command on a pod**
``` bash
kubectl exec <pod_name> -- <command>
kubectl exec kubia-ddwrt -- curl -s http://10.105.26.216
kubectl exec <pod_name> -c <container_name> -ti -- /bin/bash
```
12.1 **Delete immediately a pod**
``` bash
kubectl delete po <pod_name> --force --grace-period 0
```
12.2 **Delete a pod using the type and name specified in pod.json**
``` bash
kubectl delete -f ./pod.json
```
12.3 **Delete resources from a directory containing kustomization.yaml - e.g. dir/kustomization.yaml**
``` bash
kubectl delete -k dir
```  
12.4 **Delete pods and services with same names "baz" and "foo"**
``` bash
kubectl delete pod,service baz foo
```  
12.5 **Delete pods and services with label name=myLabel**
``` bash
kubectl delete pods,services -l name=myLabel
``` 
12.6 **Delete a pod with minimal delay**
``` bash
kubectl delete pod foo --now
```  
12.7 **Force delete a pod on a dead node**
``` bash
kubectl delete pod foo --force
```  
12.8 **Delete all pods**
``` bash
kubectl delete pods --all
```
13. Change objects with _kubectl_:  
**edit** - open a manifest in an editor, then update the object.  
_kubectl edit deployment zabbix-db_  
**patch** - modify particular features.  
_kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'_  
_kubectl patch deployment patch-demo --patch-file patch-file.yaml_  
_kubectl patch deployment zabbix-db -p '{"spec":{"template":{"spec":{"containers":\[{"name": "nodejs", "image": "luksa/kubia:v2"}\]}}}}'_  
**apply** - modify an object from file _yaml_ or _json_.  
_kubectl apply -f zabbix-db.yaml_  
**replace** - replace an object from file _yaml_ or _json_.  
_kubectl replace -f zabbix-db.yaml_  
**set image**   - modify an object from file _yaml_ or _json_.  
_kubectl set image deployment zabbix-db zabbix_db=registry.local/timescaledb_for_zabbix:v2_  
```
