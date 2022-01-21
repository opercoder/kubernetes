### Example of the yaml file
``` bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubia
spec:
  rules:
  - host: foo.example.com
    http:
      paths:
      - path: /one
        pathType: Prefix
        backend:
          service:
            name: kubia-nodeport
            port:
              number: 80
      - path: /two
        pathType: Prefix
        backend:
          service:
            name: kubia-nodeport
            port:
              number: 80
  - host: boo.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubia-nodeport
            port:
              number: 80
```
