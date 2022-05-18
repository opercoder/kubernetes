### 1. Service  
for access from internal k8s network to pods by ip and port:
##### 1.1 Example of the yaml file  
``` bash
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  sessionAffinity: ClientIP // connections from a particular client are passed to the same Pod each time
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443
  selector:
    app: kubia
```  
##### 1.2 Example of the headless service:  
``` bash
apiVersion: v1
kind: Service
metadata:
  name: kubia-headless
spec:
  clusterIP: None
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```
### 2. NodePort  
for access from external network to k8s pods by an opened port:
``` bash
apiVersion: v1
kind: Service
metadata:
  name: zabbix-web-service
  namespace: dev
spec:
  type: NodePort
  ports:
  - name: zbx-web
    port: 28080
    targetPort: zbx-web
    nodePort: 30001
  selector:
    app: zabbix-web
```
### 3. Ingress (for LOCAL k8s)
An API object that manages external access to the services in a cluster, typically HTTP.  
Ingress may provide load balancing, SSL termination and name-based virtual hosting.  
At the beggining install ingress controller:  
``` bash
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
```
In the **deploy.yml** make changes:  
``` bash
spec:
  externalTrafficPolicy: Cluster <---- CHANGE
  ports:
  - appProtocol: http
    name: http
    port: 80
    protocol: TCP
    targetPort: http  <---- ADD
    nodePort: 30080
  - appProtocol: https
    name: https
    port: 443
    protocol: TCP
    targetPort: https
    nodePort: 30443   <---- ADD
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    type: NodePort   <---- CHANGE
```
Then apply:  
``` bash
kubectl apply -f deploy.yaml
```
### 3.1 Nginx configuration:  
``` bash
server {
  listen 443 ssl;
  server_name zbx.sirius.mix;
   
  gzip on;
  gzip_comp_level 5;
  
  location / {
    proxy_pass http://zbx.sirius.mix:5080;
    proxy_redirect off;
    proxy_buffering off;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header Connection "Keep-Alive";
    proxy_set_header Proxy-Connection "Keep-Alive";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
  }
}

server {
        listen 5080;
        location / {
                proxy_pass http://kube-http;
        }
}
upstream kube-http {
        least_conn;
        server controlplane-1.domain:30080;
        server controlplane-2.domain:30080;
        server controlplane-3.domain:30080;
        server workernode-1.domain:30080;
        server workernode-2.domain:30080;
        server workernode-3.domain:30080;
}
```
### 3.2 Ingress configuration:

