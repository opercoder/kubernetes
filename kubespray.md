### Установка заданной версии с помощью контейнера
``` bash
git clone https://github.com/kubernetes-sigs/kubespray.git
git checkout v2.24.1
# ---> Заполнить /inventory/mycluster/inventory.ini данными по нодам будущего кластера
docker pull quay.io/kubespray/kubespray:v2.24.1
docker run --rm -it --mount type=bind,source="$(pwd)"/inventory/mycluster,dst=/inventory \
  --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
  quay.io/kubespray/kubespray:v2.24.1 bash
# Inside the container you may now run the kubespray playbooks:
ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa cluster.yml
```
