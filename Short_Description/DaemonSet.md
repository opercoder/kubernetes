#### Example of the yaml file:
``` bash

apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ssd-monitor
spec:
  selector:
    matchLabels:
      app: ssd-monitor
  template:
    metadata:
      labels:
        app: ssd-monitor
    spec:
      nodeSelector:
        model: ssd_asus
      containers:
      - name: main
        image: luksa/ssd-monitor
```
