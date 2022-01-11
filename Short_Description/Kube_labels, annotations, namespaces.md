1.2 **Create labels for pods**
``` bash
metadata:
  ...
  labels:
    creation_method: manual
    env: prod
  ...  
```
1.2 **Create an annotation for pod**
``` bash
kubectl annotate pod <pod_name> mycompany.com/someannotation="bla bla"
```
2. **Show pod with labeles**
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
3 **Create a label for node**
``` bash
kubectl label node <node_name> model=old_asus
```
4. **Show nodes with labels**
``` bash
kubectl get nodes -l model=old_asus
```
5. **Start a pod on the node with a definite label**
``` bash
...
spec:
  nodeSelector:
    model: "test_asus"
...
```
6. **Show namespaces**
``` bash
kubectl get ns
```
7. **Show podes in the namespace**
``` bash
kubectl get po --namespace kube-system
```
8.1 **Create a namespace from file**
``` bash
apiVersion: v1
kind: Namespace
metadata:
  name: namespace-test
Execute: kubectl create -f namespace-test.yaml
```
8.2 **Create a namespace by command**
``` bash
kubectl create namespace namespace-test
```

