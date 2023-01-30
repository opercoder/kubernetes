### Отобразить точку подключения к API:  
``` bash
kubectl cluster-info
```
### Доступ к серверу API через прокси kubectl:  
``` bash
kubectl proxy
```
Теперь можно давать команды: `curl localhost:8001`.  
### Тестово дать всем sa доступ до API:
``` bash
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts
```
