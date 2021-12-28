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
4.  **Print a list of pods:**  
``` bash
kubectl get pods
kubectl get pods -o wide
```
5.  **Show additional information about pod:**  
``` bash
kubectl describe pods/<pod_name>
```
6. **Print a list of services:**  
``` bash
kubectl get svc
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
11. **Create labels for pods**
``` bash
metadata:
  ...
  labels:
    creation_method: manual
    env: prod
  ...  
```
12. **Show pod with labeles**
``` bash
kubectl get po --show-labels  
# Show all pods and labels's columns  
kubectl get po -L creation_method,env  
# Create the label  
kubectl label po kubia-manual creation_method=manual  
# Change the label
kubectl label po kubia-manual-v2 env=debug --overwrite  
# Show only pods with the label "env"
kubectl get po -l env  
# Show only pods without the label "env"
kubectl get po -l '!env'  
# Show only pods with the label "env" with the value "debug"  
kubectl get po -l "env!=debug"  
# Show only pods with the label "env" with values "debug" or "prod"  
kubectl get po -l "env in (prod,debug)"
# Show only pods with the label "env" without values "debug" and "prod"  
kubectl get po -l "env notin (prod,debug)"
```
13. **Create labels for nodes**
``` bash
kubectl label node <node_name> model=old_asus
```
14. **Show nodes with labels**
``` bash
kubectl get nodes -l model=old_asus
```

