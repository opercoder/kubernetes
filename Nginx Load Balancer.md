### Access to the K8s Dashboard by one address: https://kube.mydomain
**Put kubernetes_proxy.conf in the path: /etc/nginx/config:**
``` bash
upstream kube.mydomain {
        server kube-1.mydomain:32000;
        server kube-2.mydomain:32000;
        server kube-3.mydomain:32000;
}

server {
        listen 443 ssl;
        server_name k8s.mydomain;

        location / {
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header Host $host;
                proxy_ssl_certificate /etc/nginx/conf.d/nginx_proxy.chained.cert.pem;
                proxy_ssl_certificate_key /etc/nginx/conf.d/nginx_proxy.key.pem;
                proxy_pass https://kube.mydomain/;
        }
}
```
