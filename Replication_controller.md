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
