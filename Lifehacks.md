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
3. **Fast namespace changing**  
``` bash
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace '
```
4. **Edit yaml declaration with update of a pod**  
``` bash
kubectl edit po <pod_name>
```
5. **Use Nano by default editor**  
``` bash
export KUBE_EDITOR="/usr/bin/nano"
```


