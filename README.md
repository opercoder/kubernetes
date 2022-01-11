# Shortly about Kubernetes
## Main elements
### Node
Kubernetes runs your workload by placing containers into Pods to run on Nodes. A node may be a virtual or physical machine, depending on the cluster. Each node is managed by the control plane and contains the services necessary to run Pods.  
Typically you have several nodes in a cluster; in a learning or resource-limited environment, you might have only one node.  
The components on a node include the kubelet, a container runtime, and the kube-proxy.  
### Pod
Pods are the smallest deployable units of computing that you can create and manage in Kubernetes.
### Replication Controller
A ReplicationController ensures that a specified number of pod replicas are running at any one time.
### ReplicaSet
A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.
### DaemonSet
A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected.
Some typical uses of a DaemonSet are:
- running a cluster storage daemon on every node
- running a logs collection daemon on every node
- running a node monitoring daemon on every node
### Job
A Job creates one or more Pods and will continue to retry execution of the Pods until a specified number of them successfully terminate. As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. Deleting a Job will clean up the Pods it created. Suspending a Job will delete its active Pods until the Job is resumed again.
***
_This info from https://kubernetes.io/docs/._
