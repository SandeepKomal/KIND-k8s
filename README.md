# KIND-k8s

A practical **Kubernetes in Docker (Kind)** lab for learning local Kubernetes, multi-node clusters, image workflows, networking, security, and CI/CD integration.

[![Validate](https://github.com/SandeepKomal/KIND-k8s/actions/workflows/validate.yml/badge.svg)](https://github.com/SandeepKomal/KIND-k8s/actions/workflows/validate.yml)
[![GitHub stars](https://img.shields.io/github/stars/SandeepKomal/KIND-k8s?style=flat)](https://github.com/SandeepKomal/KIND-k8s/stargazers)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## What you will learn

- Create single-node and multi-node Kind clusters
- Configure control-plane and worker nodes
- Load local container images into Kind
- Deploy a sample application with Kubernetes manifests
- Expose services for local testing
- Add basic RBAC, NetworkPolicy, and Pod Security controls
- Validate manifests in CI without requiring a live cluster
- Use Kind as a lightweight Kubernetes environment for CI/CD experiments

> **Kind is for development and testing.** The examples in this repository are intentionally designed for local labs and CI environments, not production clusters.

## Repository structure

```text
.
├── .github/workflows/
│   └── validate.yml              # YAML + Kubernetes manifest validation
├── examples/
│   ├── app/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── security/
│       ├── namespace.yaml
│       ├── network-policy.yaml
│       └── rbac.yaml
├── kind/
│   ├── single-node.yaml
│   └── multi-node.yaml
├── scripts/
│   ├── create-cluster.sh
│   ├── delete-cluster.sh
│   ├── load-image.sh
│   └── validate.sh
├── kind.md
├── CONTRIBUTING.md
└── README.md
```

## Prerequisites

Install:

- Docker
- kubectl
- Kind

Check that they are available:

```bash
docker version
kubectl version --client
kind version
```

See [kind.md](kind.md) for Ubuntu installation notes.

## Create a cluster

### Single-node

```bash
./scripts/create-cluster.sh single
```

### Multi-node

```bash
./scripts/create-cluster.sh multi
```

Verify:

```bash
kubectl cluster-info --context kind-kind
kubectl get nodes -o wide
```

## Deploy the demo application

```bash
kubectl apply -f examples/app/
kubectl -n kind-demo get deploy,pods,svc
```

For local access:

```bash
kubectl -n kind-demo port-forward svc/sample-app 8080:80
```

Then open:

```text
http://127.0.0.1:8080
```

## Load a local image into Kind

After building an image locally:

```bash
docker build -t kind-demo:dev .
./scripts/load-image.sh kind-demo:dev
```

When a deployment references a locally loaded image, use an immutable or development tag and avoid forcing a registry pull:

```yaml
image: kind-demo:dev
imagePullPolicy: IfNotPresent
```

## Security examples

The repository includes intentionally small examples for:

- **RBAC**: namespace-scoped service account permissions
- **NetworkPolicy**: default-deny ingress with explicit application access
- **Pod Security**: namespace labels for restricted workloads

These are learning examples. Test them in a disposable Kind cluster before adapting them elsewhere.

## Validation

Run locally:

```bash
./scripts/validate.sh
```

The GitHub Actions workflow validates YAML and Kubernetes manifests on pull requests and pushes.

## Troubleshooting

### Docker socket permission denied

Add your user to the Docker group, then start a new login session:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker run --rm hello-world
```

Do **not** use `chmod 666 /var/run/docker.sock`; that weakens the host's Docker socket permissions.

### Cluster is stuck or unstable

Check:

```bash
docker ps
kind get clusters
kubectl get nodes
kubectl get pods -A
```

Kind node logs can be inspected with:

```bash
docker logs kind-control-plane
```

### WSL2

Kind works with Docker Desktop's WSL2 integration. Verify Docker is available from the WSL environment before creating the cluster.

## Delete the cluster

```bash
./scripts/delete-cluster.sh
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Roadmap

- Ingress examples
- Local registry integration
- Helm example
- GitHub Actions CI deployment into an ephemeral Kind cluster
- Kyverno policy examples
- Prometheus/Grafana observability lab
- Multi-architecture image workflows

## ⭐

If this lab helps you learn or build Kubernetes automation, starring the repository helps other engineers discover it.

