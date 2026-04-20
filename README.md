<div align="center">

# ⚖️ Foral Governance

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![CI](https://github.com/foral-project/governance/actions/workflows/ci.yml/badge.svg)](https://github.com/foral-project/governance/actions/workflows/ci.yml)
[![OPA](https://img.shields.io/badge/OPA-CNCF%20Graduated-blueviolet.svg)](https://www.openpolicyagent.org/)
[![Policies Live](https://img.shields.io/badge/Policies-Live%20↗-brightgreen)](https://foral-project.github.io/governance/policies/)

Framework de governança federada instanciável. Publica **reusable workflows** e **OPA policies**
que qualquer organização consome sem fork.

[Guia de Adoção](ADOPTING.md) ·
[Arquitetura](ARCHITECTURE.md) ·
[OPA Policies](https://foral-project.github.io/governance/policies/) ·
[ADRs](docs/adr/)

</div>

---

> **Não faça fork deste repositório.** Consuma via `uses:` ou baixe policies via HTTP.

## Quick Start (5 minutos)

### 1. Adicione um manifesto ao seu repo

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

### 2. Adicione validação CI

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

**Pronto.** O CI valida contra o [Foral Protocol](https://github.com/foral-project/protocol) automaticamente.

Para mais opções (CLI, template, customização): **[ADOPTING.md](ADOPTING.md)**

## Reusable Workflows

Todos os workflows são parametrizáveis e versionados:

| Workflow | Propósito |
|---|---|
| [`validate-catalog.yml`](.github/workflows/validate-catalog.yml) | JSON Schema (IETF Draft 2020-12) + OPA/Conftest |
| [`validate-naming.yml`](.github/workflows/validate-naming.yml) | RFC 1123 DNS Labels + kebab-case tags |
| [`validate-conventional.yml`](.github/workflows/validate-conventional.yml) | Conventional Commits 1.0.0 |

```yaml
# Consumo com versão pinada:
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0.1.0

# Consumo com inputs customizados:
uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
with:
  schema-url: "https://my-org.github.io/schemas/v1/catalog.schema.yaml"
  policies-source: "local"
```

## OPA Policies

Políticas de referência disponíveis via HTTP (GitHub Pages):

| Policy | URL Live |
|---|---|
| Structural validation | [`catalog-info.rego`](https://foral-project.github.io/governance/policies/catalog-info.rego) |
| Naming conventions | [`naming.rego`](https://foral-project.github.io/governance/policies/naming.rego) |

```bash
# Download para uso local
curl -sfL https://foral-project.github.io/governance/policies/catalog-info.rego
curl -sfL https://foral-project.github.io/governance/policies/naming.rego

# Executar localmente
conftest test catalog-info.yaml --policy policies/
```

## Federation

Este repo gerencia a federação da org `foral-project`:

| Componente | Propósito |
|---|---|
| [`federation-registry.yaml`](federation-registry.yaml) | Lista de membros federados |
| [`federation-check.yml`](.github/workflows/federation-check.yml) | Health check diário (06:00 UTC) |
| [`federation-admission.yml`](.github/workflows/federation-admission.yml) | Gate automático para PRs de admissão |

Novos membros entram via **Pull Request** editando o `federation-registry.yaml`.

## Documentação

| Doc | Conteúdo |
|---|---|
| [ADOPTING.md](ADOPTING.md) | Guia de adoção completo (CLI, template, manual) |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Arquitetura detalhada (arc42) |
| [docs/adr/](docs/adr/) | 9 Architecture Decision Records (Nygard) |

## Ecossistema

| Repo | Papel |
|---|---|
| 📜 **[protocol](https://github.com/foral-project/protocol)** | Especificação, schemas, JSON-LD contexts |
| ⚖️ **[governance](https://github.com/foral-project/governance)** | Reusable workflows, OPA policies (este repo) |
| 🔧 **[cli](https://github.com/foral-project/cli)** | Validação e scaffold via terminal |
| 📦 **[template](https://github.com/foral-project/template)** | GitHub template para novos repos |

## Licença

[Apache-2.0](LICENSE) — SPDX-License-Identifier: Apache-2.0
