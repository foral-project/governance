# Foral Governance

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![CI](https://github.com/foral-project/governance/actions/workflows/ci.yml/badge.svg)](https://github.com/foral-project/governance/actions/workflows/ci.yml)
[![OPA](https://img.shields.io/badge/OPA-CNCF%20Graduated-blueviolet.svg)](https://www.openpolicyagent.org/)

[Adopting Guide](ADOPTING.md) · [Architecture](ARCHITECTURE.md) · [OPA Policies](https://foral-project.github.io/governance/policies/) · [ADRs](docs/adr/)

---

Publishes **reusable workflows** and **OPA policies** that any GitHub organization can consume without forking. This is the enforcement layer for the [Foral Protocol](https://github.com/foral-project/protocol).

> **Do not fork this repository.** Consume via `uses:` or download policies via HTTP.

## Quick Start

### 1. Add a manifest to your repo

```yaml
# catalog-info.yaml
"@context": "https://foral-project.github.io/protocol/context/v1/catalog.jsonld"
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-project
  annotations:
    foral.dev/archetype: application
spec:
  type: service
  lifecycle: experimental
  owner: my-org
```

### 2. Add CI validation

```yaml
# .github/workflows/foral.yml
name: Foral Validation
on: [push, pull_request]
jobs:
  catalog:
    uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
  naming:
    uses: foral-project/governance/.github/workflows/validate-naming.yml@main
  commits:
    uses: foral-project/governance/.github/workflows/validate-conventional.yml@main
```

Done. CI validates against the [Foral Protocol](https://github.com/foral-project/protocol) automatically.

For more options (CLI, template, customization): **[ADOPTING.md](ADOPTING.md)**

## Reusable Workflows

| Workflow | Purpose |
|---|---|
| [`validate-catalog.yml`](.github/workflows/validate-catalog.yml) | JSON Schema (IETF Draft 2020-12) + OPA/Conftest |
| [`validate-naming.yml`](.github/workflows/validate-naming.yml) | RFC 1123 DNS Labels + kebab-case tags |
| [`validate-conventional.yml`](.github/workflows/validate-conventional.yml) | Conventional Commits 1.0.0 |

```yaml
# Pinned version:
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0.1.0

# Custom inputs:
uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
with:
  schema-url: "https://my-org.github.io/schemas/v1/catalog.schema.yaml"
  policies-source: "local"
```

## OPA Policies

| Policy | Live URL |
|---|---|
| Structural validation | [`catalog-info.rego`](https://foral-project.github.io/governance/policies/catalog-info.rego) |
| Naming conventions | [`naming.rego`](https://foral-project.github.io/governance/policies/naming.rego) |

```bash
# Download
curl -sfL https://foral-project.github.io/governance/policies/catalog-info.rego
curl -sfL https://foral-project.github.io/governance/policies/naming.rego

# Run locally
conftest test catalog-info.yaml --policy policies/
```

## Federation

| Component | Purpose |
|---|---|
| [`federation-registry.yaml`](federation-registry.yaml) | List of federated members |
| [`federation-check.yml`](.github/workflows/federation-check.yml) | Daily health check (06:00 UTC) |
| [`federation-admission.yml`](.github/workflows/federation-admission.yml) | Automatic gate for admission PRs |

New members join via **Pull Request** editing `federation-registry.yaml`.

## Documentation

| Doc | Content |
|---|---|
| [ADOPTING.md](ADOPTING.md) | Full adoption guide (CLI, template, manual) |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Detailed architecture (arc42) |
| [docs/adr/](docs/adr/) | Architecture Decision Records (Nygard) |

## Ecosystem

| Repo | Role |
|---|---|
| [protocol](https://github.com/foral-project/protocol) | Specification, schemas, JSON-LD contexts |
| [governance](https://github.com/foral-project/governance) | Reusable workflows, OPA policies (this repo) |
| [cli](https://github.com/foral-project/cli) | Validation and scaffolding CLI |
| [template](https://github.com/foral-project/template) | GitHub template for new projects |

## License

[Apache-2.0](LICENSE) — SPDX-License-Identifier: Apache-2.0
