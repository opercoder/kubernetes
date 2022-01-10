1. **Check pods liveness**
``` bash
spec:
  containers:
  name: kubia
    livenessProbe:
      httpGet:
        path: /
        port: 8080
```
