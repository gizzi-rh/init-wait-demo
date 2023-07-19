# Description

This is a simple demo to show a workload app container can be created after a dependency pod is ready. The demo covers the particular case where the dependency is not a very strict dependency. Therefore, there is a timeout and if it expires then the workload container is created even if the dependency pod is not ready yet.

The demo is implemented in three ways:
- Helm Chart
- List object that defines: namespace, daemonset, deployment, configmap, service account, role binding
- Openshift template object defining the same resources as List object


# Helm Chart

To install the Helm Chart run the following:

```
helm upgrade --install init-wait-demo init-wait-demo -n init-wait-demo --create-namespace
```

To uninstall the Helm Chart:

```
helm uninstall init-wait-demo -n init-wait-demo
```


# List Object

To create the resource using the list object file run the following:

```
kubectl/oc apply -f init-wait-demo-list.yaml
```


# Openshift Template

Use the following command to install and use the openshift template:

```
oc apply -f init-wait-demo-template.yaml -n openshift
oc process init-wait-demo-template -n openshift | oc apply -f -
```


# Reference
[1] https://kubernetes.io/docs/concepts/overview/kubernetes-api/
[2] https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/