### Example oh the yaml file
``` bash
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  sessionAffinity: ClientIP // connections from a particular client are passed to the same Pod each time
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```
