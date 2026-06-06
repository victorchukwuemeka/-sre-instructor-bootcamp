# Lab 5: Kubernetes Reliability Patterns

## Objective

Deploy a service with production-grade reliability patterns and test its resilience.

## Prerequisites

```bash
# Verify kubectl is available
kubectl version --client

# If using minikube
minikube start --nodes=3
```

## Part 1 — Basic Deployment

Deploy the transfer service:

```bash
kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
```

Scale it to 3 replicas and verify:

```bash
kubectl scale deployment nginx --replicas=3
kubectl get pods -w
```

## Part 2 — Add PodDisruptionBudget

Create a PDB that ensures at least 2 pods are always available:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: nginx-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: nginx
```

**Test:** Simulate a node drain. What happens?

```bash
# Drain a node (minikube only)
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
```

## Part 3 — Add Probes

Update the deployment with liveness, readiness, and startup probes:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5

readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
```

**Test:** Kill a pod and watch it restart:

```bash
kubectl delete pod <pod-name>
kubectl get pods -w
```

## Part 4 — Challenge: Chaos on K8s

Design and execute a chaos experiment:

1. **Pod Kill** — kill all pods simultaneously. Does the PDB protect them?
2. **Resource Exhaustion** — deploy a pod that uses excessive memory. What happens?
3. **Network Partition** — use network policies to isolate pods. Does the app survive?

For each experiment, document:
- What you expected to happen
- What actually happened
- What configuration change would improve the outcome

## Part 5 — Production Deployment YAML

Combine everything into a single production-quality deployment YAML file:

```yaml
# transfer-service-production.yaml
# Must include:
# - 6 replicas
# - RollingUpdate strategy (maxUnavailable: 1)
# - PDB (minAvailable: 5)
# - Topology spread constraints (maxSkew: 1 across zones)
# - Priority class (banking-high)
# - Resource requests and limits
# - Liveness, readiness, and startup probes
# - HorizontalPodAutoscaler (CPU > 70%)
```

Share your YAML with the class. Explain each configuration choice.
