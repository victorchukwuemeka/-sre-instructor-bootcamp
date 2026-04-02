# SRE COURSE — MODULE 5 INSTRUCTOR NOTE
### Kubernetes Basics for Reliability

---

## 1. One Sentence You Must Remember
**Kubernetes keeps the desired state running.**

---

## 2. What Kubernetes Is (Plain English)
Kubernetes is a system that runs containers for you, keeps them healthy, and replaces them when they fail.

---

## 3. Core Concepts (Only These)
- **Pod:** Smallest unit that runs one or more containers
- **Deployment:** Tells Kubernetes how many pods to keep running
- **Service:** Gives pods a stable network identity

---

## 4. Reliability Connection (Make This Clear)
Kubernetes improves reliability by:
- Restarting failed pods automatically
- Spreading workloads across nodes
- Making deployments repeatable

---

## 5. Demo Script (Use This Live)
Say this out loud:
“I will create a deployment, delete a pod, and watch Kubernetes recreate it.  
This is self‑healing in action.”

---

## 6. Practical Lab (What You Run)
Folder: `sre-labs/05-k8s/`
1. `kubectl create deployment hello --image=nginx`
2. `kubectl get pods`
3. `kubectl delete pod -l app=hello`
4. `kubectl get pods`

---

## 7. Teaching Script — First 10 Minutes
“Kubernetes is not magic. It just keeps the desired state running.  
If a pod dies, Kubernetes creates a new one.  
This is why it helps reliability at scale.”

---

## 8. Student Learning Objectives
- Define pod, deployment, and service
- Explain why Kubernetes improves reliability
- Perform a basic create and delete cycle

---

## 9. Cheat Sheet for Teaching Day
- Pods run containers
- Deployments keep pods alive
- Deleting a pod shows self‑healing

