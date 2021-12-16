1. **Autocompletion by button Tab**  
``` bash
source <(kubectl completion bash)
# Add this string to the file ".bashrc".
```
2. **Send messages to Pod without any services**  
``` bash
kubectl port-forward <pod_name> <port_out>:<port_in>
# To check execute: curl localhost:<port_out>.  
```


