Example of yaml file:  
``` bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: kubia
spec:
  replicas: 3
  selector:
    matchLabels:
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
1. **Show info abouut ReplicaSet.**
``` bash
kubectl get rs
kubectl describe rs
```
2. **Other variants of selector.**
``` bash
  selector:
    matchExpressions:
      - key: app
        operator: In (NotIn, Exists, DoesNotExist)
        values:
          - kubia
```
