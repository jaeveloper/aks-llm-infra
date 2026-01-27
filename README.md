# AKS LLM Inference Platform (GPU‑Ready, Cost‑Optimized)

## Overview

This project demonstrates the design and implementation of a **production‑grade Large Language Model (LLM) inference platform on Azure Kubernetes Service (AKS)** with a strong emphasis on **cost efficiency, scalability, security, and observability**.

The platform is designed to run **CPU‑based inference by default**, while being **fully GPU‑ready** without requiring refactoring. GPU node pools are configured to **scale to zero**, enabling inference validation during short windows and eliminating unnecessary GPU spend when idle.

This project reflects real‑world cloud infrastructure decision‑making under **budget constraints, quota limitations, and enterprise security requirements**.

---

## Key Objectives

* Design a **secure, scalable AKS-based LLM inference architecture**
* Enable **ephemeral GPU usage** for inference validation
* Minimize cloud spend using **scale‑to‑zero GPU node pools**
* Deploy **quantized LLM workloads** using Ollama
* Implement **horizontal autoscaling, health probes, and observability**
* Validate both **internal and external inference access paths**

---

## Technology Stack

* **Cloud Provider:** Microsoft Azure
* **Container Orchestration:** Azure Kubernetes Service (AKS)
* **Infrastructure as Code:** Terraform
* **LLM Runtime:** Ollama
* **Ingress:** NGINX Ingress Controller (Helm)
* **Autoscaling:** Kubernetes HPA
* **Observability:** Azure Monitor + Grafana
* **GPU Enablement:** NVIDIA Device Plugin (GPU‑ready)

---

## Architecture Summary

<img width="993" height="535" alt="image" src="https://github.com/user-attachments/assets/84afdf7d-5dad-4333-b861-29c3a5a5bedc" />

**IMAGE C – Project Architecture**

Client

│
│ (kubectl / port‑forward / internal or external ingress)
▼
AKS Cluster

├── System Node Pool (CPU‑only)
│     ├── Ingress Controller
│     └── Ollama LLM Pods (CPU inference)

│

├── GPU Node Pool (NVIDIA, scale‑to‑zero)

│     └── Reserved for heavy inference workloads

│
▼

Azure Monitor / Grafana

### Design Principles

* **Ingress runs only on CPU nodes** to avoid wasting GPU capacity
* **GPU nodes are isolated, ephemeral, and cost‑controlled**
* **LLM workloads are GPU‑ready**, but safely operate on CPU until quota is approved
* **Observability is built‑in from day one**

---

## Infrastructure Provisioning

<img width="968" height="518" alt="image" src="https://github.com/user-attachments/assets/b70ee091-503d-44e0-b860-38e57bddba3e" />

**IMAGE A – Terraform Code in VS Code**

* AKS cluster provisioned using **Terraform**
* Separate **system (CPU)** and **GPU** node pools defined
* GPU pool configured with:

  * Autoscaling enabled
  * Minimum node count set to **zero**
  * Pending Azure quota approval for NC/NV SKUs

This ensures GPU resources incur **no cost unless explicitly activated**.

---

## Kubernetes Cluster State

<img width="963" height="479" alt="image" src="https://github.com/user-attachments/assets/e8f30376-5179-4de1-aa10-b593f53e34e8" />

**IMAGE B – `kubectl get pods -A`**

* System components running on CPU node pool
* Ollama inference workloads deployed and healthy
* No GPU nodes running during cost‑optimized testing

---

## LLM Deployment

<img width="968" height="514" alt="image" src="https://github.com/user-attachments/assets/c0c9b76e-64bd-452b-a8e9-c30283f18745" />

**IMAGE D – Create Namespace & Apply Deployment/Service**

* Dedicated `llm` namespace created
* Ollama deployed as a Kubernetes Deployment
* Resource requests and limits defined
* Persistent volume mounted for model storage

---

## Model Management

<img width="899" height="490" alt="image" src="https://github.com/user-attachments/assets/cf59ea34-23a3-4d16-96e7-667ad3d23348" />

**IMAGE E – Pulling a CPU‑Safe Model into Ollama Pod**

* Quantized, CPU‑safe model (`tinyllama`) pulled into the pod
* Model artifacts persisted via Kubernetes PVC
* Ensures models survive pod restarts and scaling events

---

## Internal Inference Validation

<img width="857" height="396" alt="image" src="https://github.com/user-attachments/assets/6eb299f9-0e2e-4112-af34-9ddeafebe99c" />

**IMAGE F – Testing `/api/tags` from Test Client**

> "Deployed an LLM inference service on AKS, validated internal service discovery, and successfully served model metadata via REST API."

* Verified internal connectivity
* Confirmed Ollama REST API reachable within cluster

---

## External Access via Ingress

<img width="991" height="557" alt="image" src="https://github.com/user-attachments/assets/192b82d5-167f-4af8-83e9-6a2822ff028d" />

**IMAGE G – NGINX Ingress Installed via Helm**

* NGINX Ingress Controller deployed using Helm
* Azure Public LoadBalancer provisioned
* Stable entry point into the cluster

> "Exposed Kubernetes‑hosted LLM inference service via NGINX Ingress on Azure AKS, enabling secure HTTP access to internal model‑serving workloads while preserving GPU isolation and scalability."

---

## External Connectivity Test

<img width="951" height="519" alt="image" src="https://github.com/user-attachments/assets/48702465-29f4-46e6-a4c4-b8dd957bfb51" />
<img width="1090" height="222" alt="image" src="https://github.com/user-attachments/assets/b8cb1b5f-5ac6-484a-bf56-c9673189e94a" />

**IMAGE H – External API Invocation via Public IP**

* REST requests sent to the public LoadBalancer IP
* Verified successful inference responses from outside the cluster

---

## LLM Interaction

<img width="976" height="551" alt="image" src="https://github.com/user-attachments/assets/5f2b819f-2dc1-4f56-b938-71a7edc53a35" />

**IMAGE I – Interacting with the LLM**

* Sent multiple inference requests to the model
* Confirmed stable responses under repeated calls
* Demonstrated real‑time LLM interaction over HTTP

---

## Autoscaling Behavior

<img width="889" height="462" alt="image" src="https://github.com/user-attachments/assets/94878acd-8174-425b-a7bc-40a094a160ce" />

**IMAGE J – HPA Scaling from 1 to 3 Replicas**

> "We deployed a CPU‑based LLM inference service on AKS using Ollama. The deployment uses Kubernetes HPA based on CPU utilization, allowing the system to scale horizontally under inference load."

* Sustained inference traffic triggered HPA
* Pods scaled from **1 → 3 replicas**
* Traffic distributed via NGINX Ingress

---

## Health Probes & Stability

<img width="1090" height="554" alt="image" src="https://github.com/user-attachments/assets/381bc03e-2bb6-4aef-bcd8-21b56129de3c" />

**IMAGE K – Readiness & Liveness Probe Verification**

* Implemented readiness probes to:

  * Prevent traffic during slow model initialization
* Implemented liveness probes to:

  * Automatically recover unhealthy inference pods

This ensures **safe autoscaling and zero‑downtime behavior**.

---

## Observability

<img width="1008" height="539" alt="image" src="https://github.com/user-attachments/assets/4ec0e042-667d-493b-9ff8-3acbc78f8737" />

**IMAGE L – Azure Monitor**

* Cluster metrics collected via Azure Monitor
* Visibility into:

  * Node utilization
  * Pod health
  * Autoscaling events

<img width="1003" height="554" alt="image" src="https://github.com/user-attachments/assets/77f85b5e-2bdb-4a3d-bb77-fd72f1bd5dcd" />

**IMAGE M – Grafana Dashboard**

* Real‑time visualization of inference load
* CPU usage, pod count, and request behavior monitored

---

## GPU Readiness (Future Activation)

Although GPU quota approval is pending, the platform is **fully GPU‑ready**:

* GPU node pool already defined and autoscaled
* NVIDIA device plugin support planned
* Inference manifests compatible with GPU scheduling

Once quota is approved:

* GPU pool can be scaled up temporarily
* Heavy inference workloads can be validated
* GPU nodes can be scaled back to zero after testing

---

## Key Skills Demonstrated

* AKS provisioning with Terraform
* Cost‑aware cloud architecture design
* GPU scheduling & scale‑to‑zero strategy
* Kubernetes‑based LLM inference deployment
* Secure ingress design
* Horizontal Pod Autoscaling (HPA)
* Observability with Azure Monitor & Grafana

---

## Summary

This project demonstrates how to **build enterprise‑grade AI infrastructure on AKS** while respecting **real‑world constraints** such as cost, quota limits, and operational complexity.

It showcases a pragmatic, production‑ready approach to deploying LLM inference workloads that can **scale from zero to GPU‑accelerated workloads on demand**, without redesign or wasted cloud spend.
