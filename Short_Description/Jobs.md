### Example of the yaml file
``` bash
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-job
spec:
  completions: 5 // sequential execution
  parallelism: 2 // up to two modules can be executed in parallel
  <activeDeadlineSeconds: 100 // duration of the job before it failure>
  <backoffLimit: 5 // count of retries before job failure>
  template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure
      containers:
      - name: main
        image: luksa/batch-job
```
#### 1. Change parallelism from 2 to 3  
`kubectl scale job batch job --replicas 3`
