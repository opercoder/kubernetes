1. Create gitlab.yml
``` bash
gitlabUrl: https://may24.gitlab.yandexcloud.net

runnerRegistrationToken: "glrt-us8yq5NQoPUgEoP-kL5j"

concurrent: 5

checkInterval: 30

rbac:
  create: true
  rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["list", "get", "watch", "create", "delete"]
    - apiGroups: [""]
      resources: ["pods/exec"]
      verbs: ["create"]
    - apiGroups: [""]
      resources: ["pods/log"]
      verbs: ["get"]
    - apiGroups: [""]
      resources: ["pods/attach"]
      verbs: ["list", "get", "create", "delete", "update"]
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["list", "get", "create", "delete", "update"]
    - apiGroups: [""]
      resources: ["configmaps"]
      verbs: ["list", "get", "create", "delete", "update"]

runners:
  privileged: true

  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "gitlab"
        tls_verify = false
        image = "docker:19"
        privileged = true
        pull_policy = ["always", "if-not-present"]
        image_pull_secrets = ["registry-credentials-devops"]
```
1. Execute: helm install gitlab-runner gitlab/gitlab-runner -f gitlab.yaml --namespace gitlab
1. Use generate-token.sh:
``` bash
#!/bin/bash

if [ "$#" -ne 1 ]; then
    printf "Invalid arguments, please after script write the gitlab token. \n" >&2
    printf "Looks the following example Buddy ;) \n" >&2
    printf "./secret-gitlab-generator.sh <GITLAB_DEPLOY_TOKEN> \n" >&2
    exit 1;
fi

# Variable to obtain the .dockerconfigjson

secret_gen_string='{"auths":{"may24.gitlab.yandexcloud.net:5050":{"username":"{{USER}}","password":"{{TOKEN}}","auth":"{{SECRET}}"}}}'

gitlab_user=k8s # Change the parameter USER_GITLAB_DEPLOY_TOKEN_USER for your Gitlabuser or Gitlab Service Account.
gitlab_token=$1
gitlab_secret=$(echo -n "$gitlab_user:$gitlab_token" | base64 )

# Generator of the Gitlab Token for the secret file.
#
printf " \n" >&2
printf "............................................................................................. \n" >&2
printf " \n" >&2
printf " Please, put the token in your secret-file.YAML and complete the field : .dockerconfigjson: \n" >&2
printf " \n" >&2
printf "............................................................................................. \n" >&2
printf " \n" >&2
echo -n $secret_gen_string | sed "s/{{USER}}/$gitlab_user/" | sed "s/{{TOKEN}}/$gitlab_token/" | sed "s/{{SECRET}}/$gitlab_secret/" | base64
```
1. Create secret registry-credentials-devops.yml and input generated token: 
``` bash
apiVersion: v1
kind: Secret
metadata:
  name: registry-credentials-devops
  namespace: gitlab
data:
  .dockerconfigjson: >-
    eyJhdXRocyI6eyJtYXkyNC5naXRsYWIueWFuZGV4Y2xvdWQubmV0OjUwNTAiOnsidXNlcm5hbWUiOiJrOHMiLCJwYXNzd29yZCI6ImdsZHQtX21vRmtadDM2Z3VkRGo3WHc4czciLCJhdXRoIjoiYXpoek9tZHNaSFF0WDIxdlJtdGFkRE0yWjNWa1JHbzNXSGM0Y3pjPSJ9fX0=
type: kubernetes.io/dockerconfigjson
```
1. kubectl apply -f registry-credentials-devops.yml
