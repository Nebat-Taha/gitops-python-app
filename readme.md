GitOps Automated Application Delivery Platform 
A production-grade, declarative GitOps deployment pipeline built using Kubernetes, ArgoCD, and GitHub Actions. This project demonstrates automated infrastructure bootstrapping, containerized application delivery, and synchronization tracking following modern DevSecOps standards.
🏗️ Architecture & Repository Structure
This repository acts as the GitOps Manifests (State of Truth) repository, decoupled from the application source code to ensure strict operational boundaries and auditability.
Plaintext
/
├── bootstrap/
│   ├── argocd-install.yaml    # Version-pinned official ArgoCD manifests
│   └── setup.sh               # Automated Day-0 cluster bootstrap script
├── base/
│   ├── deployment.yaml        # Declarative application workload definition
│   ├── service.yaml           # Cluster networking configuration
│   └── kustomization.yaml     # Kustomize environment overlay manager
└── README.md
🚀 Quick Start (Automated Bootstrap)
You can spin up the entire local Kubernetes environment, install ArgoCD via Server-Side Apply, and prepare the GitOps engine in under 5 minutes using the automated bootstrap framework.
Prerequisites
•	Docker Desktop (running and accessible)
•	Minikube (installed on your host)
•	Kubectl (CLI utility)
1. Clone the Repository
Bash
git clone https://github.com/<your-username>/gitops-manifests.git
cd gitops-manifests
2. Execute the Bootstrap Script
The setup script initializes Minikube with the Docker driver, validates the namespace configuration, and safely installs ArgoCD using high-reliability server-side application logic:
Bash
chmod +x bootstrap/setup.sh
./bootstrap/setup.sh
3. Access the ArgoCD Dashboard
Retrieve your automatically generated initial admin password:
Bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
Then, forward the local traffic to access the Web UI:
Bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
Open your browser and navigate to https://localhost:8080 (log in with username admin and your retrieved password).
🛠️ Key Technical Highlights
•	Infrastructure as Code (IaC): Eliminates manual cluster configuration by wrapping environment initialization into a reliable shell automation script (setup.sh).
•	Server-Side Application Management: Utilizes kubectl apply --server-side to efficiently bypass client-side payload restrictions when processing large enterprise-scale custom resource definitions (CRDs).
•	Pull-Based Continuous Deployment: ArgoCD continuously monitors this Git repository, automatically synchronizing live cluster states with declared version-controlled manifests to guarantee zero configuration drift.


