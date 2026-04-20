# Foral Governance

Framework de governança federada instanciável. Publica **reusable workflows** e **OPA policies** que qualquer organização consome sem fork.

**Não faça fork deste repositório.** Consuma via `uses:` ou baixe policies via HTTP.

## Quick Start (5 minutos)

### 1. Adicione um manifesto ao seu repo

```yaml
# catalog-info.yaml
"@context": "https://foral-project.github.io/protocol/context/v1/catalog.jsonld"
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-project
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

**Pronto.** O CI valida contra o Foral Protocol automaticamente.

Para mais opções: [ADOPTING.md](ADOPTING.md)

## Reusable Workflows

| Workflow | Propósito | Consumo |
|---|---|---|
| `validate-catalog.yml` | Valida catalog-info.yaml (schema + OPA) | `uses: foral-project/governance/.github/workflows/validate-catalog.yml@main` |
| `validate-naming.yml` | Valida naming (RFC 1123) | `uses: foral-project/governance/.github/workflows/validate-naming.yml@main` |
| `validate-conventional.yml` | Valida commits (Conventional Commits 1.0.0) | `uses: foral-project/governance/.github/workflows/validate-conventional.yml@main` |

Todas aceitam inputs parametrizáveis. Veja os defaults em cada workflow.

## OPA Policies

Políticas de referência disponíveis via HTTP:

```bash
# Download direto (para uso local ou CI customizado)
curl -sfL https://foral-project.github.io/governance/policies/catalog-info.rego
curl -sfL https://foral-project.github.io/governance/policies/naming.rego
```

## Federation

Este repo gerencia a federação da org `foral-project`:

- `federation-registry.yaml` — Lista de membros federados
- `federation-check.yml` — Health check diário (06:00 UTC)
- `federation-admission.yml` — Gate automático para PRs de admissão

## Documentação

- [ADOPTING.md](ADOPTING.md) — Guia de adoção completo
- [ARCHITECTURE.md](ARCHITECTURE.md) — Arquitetura (arc42)
- [docs/adr/](docs/adr/) — Architecture Decision Records (9)

## Referências

- [Foral Protocol](https://github.com/foral-project/protocol)
- [Foral CLI](https://github.com/foral-project/cli)
- [Foral Template](https://github.com/foral-project/template)

## Licença

Apache-2.0
