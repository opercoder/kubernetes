Requests or limits of cpu and memory for each container may be assigned.
``` bash
resources:
  limits:   or   requests:
    cpu: 4
    memory: 8Gi
```
#### Show request and limits:
``` bash
kubectl describe node
```
