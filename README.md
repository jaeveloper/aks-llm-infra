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

**IMAGE B – `kubectl get pods -A`**

* System components running on CPU node pool
* Ollama inference workloads deployed and healthy
* No GPU nodes running during cost‑optimized testing

---

## LLM Deployment

**IMAGE D – Create Namespace & Apply Deployment/Service**

* Dedicated `llm` namespace created
* Ollama deployed as a Kubernetes Deployment
* Resource requests and limits defined
* Persistent volume mounted for model storage

---

## Model Management

**IMAGE E – Pulling a CPU‑Safe Model into Ollama Pod**

* Quantized, CPU‑safe model (`tinyllama`) pulled into the pod
* Model artifacts persisted via Kubernetes PVC
* Ensures models survive pod restarts and scaling events

---

## Internal Inference Validation

**IMAGE F – Testing `/api/tags` from Test Client**

> "Deployed an LLM inference service on AKS, validated internal service discovery, and successfully served model metadata via REST API."

* Verified internal connectivity
* Confirmed Ollama REST API reachable within cluster

---

## External Access via Ingress

**IMAGE G – NGINX Ingress Installed via Helm**

* NGINX Ingress Controller deployed using Helm
* Azure Public LoadBalancer provisioned
* Stable entry point into the cluster

> "Exposed Kubernetes‑hosted LLM inference service via NGINX Ingress on Azure AKS, enabling secure HTTP access to internal model‑serving workloads while preserving GPU isolation and scalability."

---

## External Connectivity Test

**IMAGE H – External API Invocation via Public IP**

* REST requests sent to the public LoadBalancer IP
* Verified successful inference responses from outside the cluster

---

## LLM Interaction

**IMAGE I – Interacting with the LLM**

* Sent multiple inference requests to the model
* Confirmed stable responses under repeated calls
* Demonstrated real‑time LLM interaction over HTTP

---

## Autoscaling Behavior

**IMAGE J – HPA Scaling from 1 to 3 Replicas**

> "We deployed a CPU‑based LLM inference service on AKS using Ollama. The deployment uses Kubernetes HPA based on CPU utilization, allowing the system to scale horizontally under inference load."

* Sustained inference traffic triggered HPA
* Pods scaled from **1 → 3 replicas**
* Traffic distributed via NGINX Ingress

---

## Health Probes & Stability

**IMAGE K – Readiness & Liveness Probe Verification**

* Implemented readiness probes to:

  * Prevent traffic during slow model initialization
* Implemented liveness probes to:

  * Automatically recover unhealthy inference pods

This ensures **safe autoscaling and zero‑downtime behavior**.

---

## Observability

**IMAGE L – Azure Monitor**

* Cluster metrics collected via Azure Monitor
* Visibility into:

  * Node utilization
  * Pod health
  * Autoscaling events

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
