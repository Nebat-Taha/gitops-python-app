# GitOps Automated Application Delivery Platform

A production-grade, declarative GitOps deployment pipeline built using **Kubernetes**, **ArgoCD**, and **GitHub Actions**. This project demonstrates automated infrastructure bootstrapping, secure cross-repository integration, and continuous synchronization tracking following modern DevSecOps standards.

---

## 🏗️ Architecture & Repository Structure

This repository acts as the **GitOps Manifests** (State of Truth) repository, decoupled from the application source code (`gitops-python-app`) to ensure strict operational boundaries, version control auditing, and clean separation of concerns.

```text
/
├── bootstrap/
│   ├── argocd-install.yaml    # Version-pinned official ArgoCD manifests
│   └── setup.sh               # Automated Day-0 cluster bootstrap script
├── base/
│   ├── deployment.yaml        # Declarative application workload definition
│   ├── service.yaml           # Cluster networking configuration
│   └── kustomization.yaml     # Kustomize environment overlay manager
└── README.md
````
🚀 Quick Start (Automated Bootstrap)
You can spin up the entire local Kubernetes environment, install ArgoCD via Server-Side Apply, and prepare the GitOps engine in under 5 minutes using the automated bootstrap framework.
Prerequisites
•	Docker Desktop (running and accessible)
•	Minikube (installed on your host)
•	Kubectl (CLI utility)

1. Clone the Repository

```text
Bash
git clone https://github.com/<your-username>/gitops-manifests.git
cd gitops-manifests
````
2. Execute the Bootstrap Script
The setup script initializes Minikube with the Docker driver, validates the namespace configuration, and safely installs ArgoCD using high-reliability server-side application logic:
```text
Bash
chmod +x bootstrap/setup.sh
./bootstrap/setup.sh
````
3. Access the ArgoCD Dashboard
Retrieve your automatically generated initial admin password:
```text
Bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
````
Then, forward the local traffic to access the Web UI:

```text
Bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
````
Open your browser and navigate to https://localhost:8080 (log in with username admin and your retrieved password).
🛠️ Key Technical Highlights
•	Infrastructure as Code (IaC): Eliminates manual cluster configuration by wrapping environment initialization into a reliable shell automation script (setup.sh).
•	Server-Side Application Management: Utilizes kubectl apply --server-side to efficiently bypass client-side payload restrictions when processing large enterprise-scale custom resource definitions (CRDs).
•	Pull-Based Continuous Deployment: ArgoCD continuously monitors this Git repository, automatically synchronizing live cluster states with declared version-controlled manifests to guarantee zero configuration drift.

🔄 Cross-Repository GitOps Workflow
This project implements a decoupled two-repository pattern to manage application lifecycles securely:

1. The Application Repo (gitops-python-app): Contains the source code, unit tests, and the CI workflow (GitHub Actions). When code is pushed here, CI builds an immutable Docker image, tags it with a unique commit SHA, and pushes it to the image registry.

2. The Automated Hand-Off: To update live environments securely without exposing global user credentials, the CI pipeline authenticates via SSH to automatically commit and push the updated image tag into this manifest repository (gitops-manifests).

3. The Sync Engine (ArgoCD): Continuously monitors this repository. Upon detecting the new tag commit, ArgoCD pulls the updated manifest and automatically rolls out the pods in the Kubernetes cluster.
