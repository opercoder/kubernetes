### 1. Create with a command:
``` bash
kubectl create configmap fortune-config --from-literal=sleep-interval=25
```
### 2. Example of the yaml file:
``` bash
apiVersion: v1
kind: ConfigMap
metadata:
  name: fortune-config
data:
  sleep-interval: "25"
```
### 3. Create the content of the ConfigMap from file configuration:
> You'll get the key: config-file.conf
``` bash
kubectl create configmap fortune-config --from-file=config-file.conf
```
> You'll get the key: customkey
``` bash
kubectl create configmap fortune-config --from-file=customkey=config-file.conf
```
### 4. Union of the variants:
``` bash
kubectl create configmap fortune-config --from-file=foo.json --from-file=bar=bar.conf --from-file=config-opts/ --from-literal=some=thing
```
