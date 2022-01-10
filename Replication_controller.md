Replication controller consist of three main parts:  
- label's selector;
- replica's count;
- pod's template.  

It is example of yaml file which create a replication controller:
``` bash
apiVersion: v1
kind: ReplicationController
metadata:
  name: kubia
spec:
  replicas: 3
  selector:
    app: kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: luksa/kubia
        ports:
        - containerPort: 8080
```
1. **Show replication controller which control a pod.**
``` bash
kubectl describe po <pod_name> | grep Controll
```
2. **Edit yaml file with replication controllers update.**
``` bash
kubectl edit rc <rc_name>
```
3. **Edit parameter of the replication controller.**
``` bash
kubectl scale rc <rc_name> --replicas=3
```
4. **Delete the replication controller with all pods.**
``` bash
kubectl delete rc <rc_name>
```
5. **Delete the replication controller without pods.**
``` bash
kubectl delete rc <rc_name> --cacsade=false
```
