# GitOps Python Application

A containerized FastAPI application demonstrating an end-to-end GitOps delivery workflow using GitHub Actions, Docker Hub, Kubernetes, Argo CD, and Kustomize.

The application source and CI pipeline are maintained separately from the Kubernetes deployment configuration. This repository is responsible for building and publishing application images, while the [GitOps manifests repository](https://github.com/Nebat-Taha/gitops-manifests) holds the desired Kubernetes state consumed by Argo CD.

## Architecture

The project uses a two-repository model to separate application development from deployment configuration:

- **Application repository (this repository):** Contains the FastAPI source, Dockerfile, and GitHub Actions workflow.
- **Manifests repository:** Contains the Kubernetes Deployment and Service resources, Kustomize configuration, and local Argo CD bootstrap resources.

This separation keeps the application build process independent of cluster configuration. The CI pipeline does not deploy directly to Kubernetes; it publishes an image and updates the desired image version in Git. Argo CD is responsible for reconciling that state with the cluster.

## Key Capabilities

- **Automated container builds:** Builds a Docker image when changes are pushed to the `main` branch.
- **Commit-based image versioning:** Tags each image with the Git commit SHA that triggered the workflow, making the source revision associated with an image identifiable.
- **Approval-gated publication:** Separates image building from publishing through a GitHub Environment named `dev`, which can enforce reviewer approval.
- **Automated GitOps hand-off:** Updates the image reference in the manifests repository after the image is published.
- **Cross-repository authentication:** Uses an SSH deploy key to allow the workflow to update the manifests repository without relying on a personal account credential.

## CI and GitOps Workflow

1. A change is pushed to the application's `main` branch.
2. GitHub Actions builds the container image and saves it as a workflow artifact.
3. The publishing job retrieves the built image and uses the `dev` GitHub Environment. Required reviewers can be configured on that environment to gate publication.
4. Once approved, the image is published to Docker Hub using the source commit SHA as its tag.
5. The workflow checks out the manifests repository over SSH, updates the image tag in its Kustomize configuration, and commits the change.
6. Argo CD detects the updated desired state in the manifests repository and synchronizes the Kubernetes workload according to the Application's sync policy.

The separation of responsibilities is intentional: **GitHub Actions builds and publishes; Argo CD deploys.**


## Repository Structure

```text
gitops-python-app/
├── .github/
│   └── workflows/
│       └── ci-pipeline.yaml   # Image build, publication, and manifest update
├── src/
│   ├── app.py                 # FastAPI application and endpoints
│   └── requirements.txt       # Python dependency list
├── Dockerfile                 # Container image definition
└── README.md
```

## Technology Stack

| Technology | Role |
|---|---|
| Python / FastAPI | Application and HTTP endpoints |
| Docker | Container image packaging |
| GitHub Actions | CI workflow orchestration |
| Docker Hub | Container image registry |
| GitHub Environments | Approval control for image publication |
| SSH deploy key | Secure write access to the manifests repository |
| Kustomize | Updates the image reference in Kubernetes configuration |
| Argo CD | GitOps-based synchronization and deployment |
| Kubernetes / Minikube | Application runtime for the local demonstration |

## Related Repository

[Kubernetes manifests and Argo CD configuration — `gitops-manifests`](https://github.com/Nebat-Taha/gitops-manifests)

## Demo

[Watch the project walkthrough on YouTube](https://youtu.be/zAM_jwJR8T0)
