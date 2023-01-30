### Отобразить точку подключения к API:  
``` bash
kubectl cluster-info
```
### Доступ к серверу API через прокси kubectl:  
``` bash
kubectl proxy
```
Теперь можно давать команды: `curl localhost:8001`.  
