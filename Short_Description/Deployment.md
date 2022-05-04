Example of yaml file:  
``` bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zabbix-db
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zabbix-db
  template:
    metadata:
      name: zabbix-db
      labels:
        type: monitoring
        app: zabbix-db
        env: dev
      annotations:
        application: "PostgreSQL-14 with TimescaleDB for Zabbix"
    spec:
      containers:
      - name: zabbix-db
        image: registry.sirius.mix/timescaledb_for_zabbix
        env:
        - name: POSTGRES_USER
          value: "user"
        - name: POSTGRES_PASSWORD
          value: "password"
        readinessProbe:
          tcpSocket:
            port: 5432
          initialDelaySeconds: 30
          periodSeconds: 30
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
