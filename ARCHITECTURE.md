# Foral Governance — Architecture Documentation

> **Formato:** arc42 (arc42.org)
> **Escopo:** Somente a camada de governance. O protocolo está documentado em
> [PROTOCOL.md](https://github.com/foral-project/protocol/blob/main/PROTOCOL.md).

---

## §1 Introduction and Goals

### 1.1 Requirements Overview

O Foral Governance é um **framework instanciável** que publica reusable workflows
e OPA policies para enforcement do
[Foral Protocol](https://github.com/foral-project/protocol).

**Modelo de consumo:** qualquer organização consome via `uses:` (workflow_call)
e HTTP (policies via GitHub Pages). **Zero fork necessário.**

**Responsabilidades:**

- Publicar reusable workflows de validação (schema, naming, commits)
- Publicar OPA policies de referência (catalog-info, naming)
- Manter o `federation-registry.yaml` com a lista de membros
- Executar dogfooding via `ci.yml` (consome seus próprios workflows)
- Documentar decisões arquiteturais via ADRs (formato Nygard)

### 1.2 Quality Goals

| Prioridade | Qualidade (ISO 25010) | Cenário |
|---|---|---|
| 1 | **Reliability** | Toda validação falha de forma explícita — zero falsos positivos silenciosos |
| 2 | **Maintainability** | Adicionar nova policy OPA requer zero mudanças em workflows |
| 3 | **Portability** | Migração para GitLab/Gitea requer apenas reescrita de workflows (~1 dia) |
| 4 | **Security** | Cross-repo validation via GitHub App tokens (short-lived, least privilege) |

### 1.3 Stakeholders

| Papel | Expectativa |
|---|---|
| **Owner** | Governança automatizada, zero toil manual |
| **Consumidores** | Workflows prontos para uso, policies extensíveis |
| **Membros federados** | CI feedback claro, templates prontos para bootstrapping |
| **Contribuidores** | Documentação completa, ADRs para decisões |

---

## §3 Context and Scope

### 3.1 Business Context

```
┌──────────────────────────────────────────────────────────────┐
│                    foral-project (GitHub Org)                  │
│                                                                │
│  ┌──────────┐  ┌─────────────┐  ┌──────┐  ┌──────────────┐  │
│  │ protocol │  │ governance  │  │ cli  │  │ template     │  │
│  │ (spec)   │  │ (framework) │  │(tool)│  │ (scaffold)   │  │
│  └────┬─────┘  └──────┬──────┘  └──┬───┘  └──────────────┘  │
│       │               │            │                          │
└───────┼───────────────┼────────────┼──────────────────────────┘
        │               │            │
        │  HTTP (schemas)│ uses:     │ foral init
        ▼               ▼            ▼
    ┌─────────────────────────────────────┐
    │       Consumidor (qualquer org)      │
    │                                      │
    │  catalog-info.yaml                   │
    │  .github/workflows/foral.yml         │
    └─────────────────────────────────────┘
```

### 3.2 Framework vs Instance

Este repositório é **simultaneamente** o framework e a primeira instância:

| Papel | O que faz |
|---|---|
| **Framework** | Publica reusable workflows e policies (consumidos por terceiros) |
| **Instância** | Gerencia `federation-registry.yaml` e executa `ci.yml` (dogfooding) |

Consumidores **nunca** precisam entender a instância. Consomem apenas o framework.

### 3.3 Technical Context

| Interface | Tecnologia | Protocolo |
|---|---|---|
| Schema resolution | GitHub Pages → HTTPS | HTTP GET |
| Workflow consumption | GitHub Actions `workflow_call` | GitHub API |
| Cross-repo validation | GitHub App → Installation token | GitHub REST API v3 |
| Policy execution | Conftest (OPA) | CLI local + CI |
| Policy distribution | GitHub Pages → HTTPS | HTTP GET |
| Registry storage | Git (YAML file) | Git push/PR |

---

## §5 Building Block View

### 5.1 Level 1 — Top-Level Decomposition

```
governance/
├── .github/workflows/               ← CI gates + reusable workflows
│   ├── validate-catalog.yml         ← [REUSABLE] JSON Schema + OPA
│   ├── validate-naming.yml          ← [REUSABLE] RFC 1123 check
│   ├── validate-conventional.yml    ← [REUSABLE] Conventional Commits
│   ├── federation-check.yml         ← [CALLABLE] Health check diário
│   ├── federation-admission.yml     ← [INTERNAL] Gate de admissão via PR
│   ├── on-protocol-change.yml       ← [INTERNAL] Re-valida ao receber dispatch
│   ├── release-please.yml           ← [INTERNAL] Auto tag + CHANGELOG
│   └── ci.yml                       ← [INTERNAL] Dogfooding
├── policies/                        ← OPA/Conftest (CNCF Graduated)
│   ├── catalog-info.rego            ← Structural validation
│   └── naming.rego                  ← RFC 1123 naming validation
├── docs/adr/                        ← Architecture Decision Records (Nygard)
├── federation-registry.yaml         ← Backstage catalog locations
├── catalog-info.yaml                ← Self-describing manifest (Backstage)
├── ADOPTING.md                      ← Guia de adoção para consumidores
├── ARCHITECTURE.md                  ← Este documento (arc42)
├── LICENSE                          ← Apache-2.0
└── README.md
```

### 5.2 Reusable Workflows (framework público)

| Workflow | Trigger | Inputs | Ação |
|---|---|---|---|
| `validate-catalog.yml` | `workflow_call` | schema-url, catalog-file, registry-file, policies-source, conftest-version | Schema + OPA validation |
| `validate-naming.yml` | `workflow_call` | catalog-file, policies-source, conftest-version | RFC 1123 + kebab-case |
| `validate-conventional.yml` | `workflow_call` | (nenhum) | commitlint |
| `federation-check.yml` | `workflow_call` + schedule | (nenhum) | Health check de membros |

### 5.3 Internal Workflows (instância foral-project)

| Workflow | Trigger | Ação |
|---|---|---|
| `ci.yml` | push/PR | Dogfooding: chama os 3 reusable workflows acima |
| `federation-admission.yml` | PR (federation-registry.yaml) | Gate automático + auto-labeling |
| `on-protocol-change.yml` | repository_dispatch | Re-valida ao receber release do protocol |
| `release-please.yml` | push (main) | Auto tag + CHANGELOG |

### 5.4 OPA Policies

| Policy | Package | Rules |
|---|---|---|
| `catalog-info.rego` | `foral.catalog` | @context obrigatório, apiVersion válido, kind válido, spec.lifecycle válido, spec.owner obrigatório |
| `naming.rego` | `foral.naming` | metadata.name DNS label (RFC 1123), max 63 chars, spec.owner DNS label, tags kebab-case |

---

## §6 Runtime View

### 6.1 Consumer Workflow (externo via uses:)

```
Consumidor cria .github/workflows/foral.yml
  → uses: foral-project/governance/...validate-catalog.yml@main
    → GitHub Actions resolve o reusable workflow
    → Checkout do repo DO CONSUMIDOR
    → Download schema do protocol (GitHub Pages)
    → ajv validate catalog-info.yaml
    → conftest test catalog-info.yaml (policies baixadas via HTTP)
    → Report pass/fail no PR do CONSUMIDOR
```

### 6.2 Federation Admission Flow (PRs no governance)

```
Novo membro → PR editando federation-registry.yaml
                │
                ├─ 1. Diff detecta URLs novas
                ├─ 2. Fetch catalog-info.yaml do membro (GitHub App token)
                ├─ 3. Validate schema + OPA policies
                ├─ 4. Label: federation-approved ou federation-rejected
                └─ 5. Report no PR
```

### 6.3 Cross-Repo Dispatch (Protocol → Governance)

```
Protocol: feat commit → release-please → tag v0.2.0
                          │
                          └─ repository_dispatch (CloudEvents 1.0.3)
                              → Governance: on-protocol-change.yml
                              → Re-run federation-check
```

---

## §7 Deployment View

| Componente | Deploy | Custo |
|---|---|---|
| CI Workflows | GitHub Actions (public repo = ilimitado) | Free |
| Schema hosting | GitHub Pages (protocol repo) | Free |
| Policy hosting | GitHub Pages (governance repo) | Free |
| Cross-repo auth | GitHub App (`foral-validator`) | Free |

### 7.1 GitHub App: `foral-validator`

- **Permissões:** `contents: read` em repos da org
- **Tokens:** Short-lived, auto-rotated via `actions/create-github-app-token`
- **Escopo:** Instalado na org `foral-project`
- **Secrets:** `FORAL_APP_ID` + `FORAL_APP_PRIVATE_KEY` (Org-level)

---

## §8 Crosscutting Concepts

### 8.1 Naming Conventions

Todas as convenções de naming são definidas no
[Foral Protocol, §5](https://github.com/foral-project/protocol/blob/main/PROTOCOL.md#5-naming-conventions).

A governance **aplica** essas convenções via OPA policies e CI workflows.
A governance **não define** convenções — apenas as enforça.

### 8.2 Security

| Aspecto | Implementação |
|---|---|
| Secrets | GitHub Org Secrets (SCREAMING_SNAKE_CASE, POSIX) |
| Cross-repo auth | GitHub App tokens (short-lived, least privilege) |
| Branch protection | `main` protegido, PRs obrigatórios, status checks required |
| Supply chain | Pinned Action versions (`@vN`) |

### 8.3 Versionamento

Todos os reusable workflows e policies são versionados via SemVer:

```yaml
# Pinado na versão exata (produção):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0.1.0

# Latest minor (recebe patches):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0

# Latest (edge):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
```

---

## §10 Quality Requirements

### 10.1 Quality Tree (ISO 25010)

| Atributo | Sub-atributo | Métrica |
|---|---|---|
| Reliability | Fault tolerance | Zero validações silenciosamente ignoradas |
| Maintainability | Modularity | Nova policy = 1 arquivo `.rego`, zero mudanças em workflows |
| Portability | Adaptability | Migração de CI platform em < 1 dia útil |
| Security | Confidentiality | Zero secrets em plain text, zero PATs de longa duração |

### 10.2 Quality Scenarios

| # | Cenário | Resposta esperada |
|---|---|---|
| Q1 | Consumidor externo quer adotar Foral | 2 arquivos + push. CI valida em < 2 min |
| Q2 | Nova policy OPA necessária | 1 arquivo `.rego`, zero mudanças em workflows |
| Q3 | GitHub Actions fica offline | Validação local via `foral validate` continua |
| Q4 | Migração para GitLab CI | Reescrever workflows (4 arquivos, < 1 dia). Policies e schemas são portáveis |

---

## §11 Risks and Technical Debt

| Risco | Impacto | Prob. | Mitigação |
|---|---|---|---|
| GitHub muda pricing | Recursos free reduzidos | Baixo | Protocol é Git puro (portável), governance requer apenas reescrita de workflows |
| Reusable workflows cross-org | Requer repos públicos | N/A | Repos já são públicos |
| OPA policies conflitantes | Consumidor estende com rules incompatíveis | Médio | Namespaces por org (`foral.*` vs `my-org.*`) |

---

## §12 Glossary

| Termo | Definição |
|---|---|
| **Foral** | Carta medieval portuguesa que concedia autonomia a municípios dentro de limites da Coroa. Metáfora do projeto. |
| **Protocol** | Camada vendor-agnostic: schemas, templates, JSON-LD contexts, naming rules. |
| **Governance** | Camada vendor-specific: CI workflows, OPA policies, federation registry. |
| **Framework** | O governance como produto consumível (reusable workflows + policies). |
| **Instance** | Uma organização usando o framework para governar seus repos. |
| **Member** | Repositório federado que declara conformidade com o protocolo. |
| **Registry** | Arquivo YAML que lista todos os membros da federação. |
| **Archetype** | Classificação funcional: protocol, governance, infrastructure, application, bot. |
| **DNS Label** | String RFC 1123: `[a-z0-9-]`, max 63 chars. |
| **OPA** | Open Policy Agent — engine de policies (CNCF Graduated). |
| **Conftest** | CLI para executar OPA policies contra dados estruturados. |
| **Backstage** | Plataforma de developer portal (CNCF Incubating). |

---

## ADRs

Decisões arquiteturais são registradas em [`docs/adr/`](docs/adr/) usando
o formato Nygard (de facto standard, ~15 anos de adoção).

| ADR | Título |
|---|---|
| [0001](docs/adr/0001-adr-standardization.md) | ADR Standardization |
| [0002](docs/adr/0002-core-platform-vision.md) | Core Platform Vision |
| [0003](docs/adr/0003-data-topography-and-zero-trust.md) | Data Topography and Zero Trust |
| [0004](docs/adr/0004-master-nomenclature-table.md) | Master Nomenclature Table |
| [0005](docs/adr/0005-repository-topology-and-separation-of-concerns.md) | Repository Topology and Separation of Concerns |
| [0006](docs/adr/0006-governance-as-code-polyglot-contract.md) | Governance as Code Polyglot Contract |
| [0007](docs/adr/0007-shift-left-compliance.md) | Shift-Left Compliance |
| [0008](docs/adr/0008-foral-migration.md) | Migração idp-root → foral-project |
| [0009](docs/adr/0009-governance-as-framework.md) | Governance como Framework Instanciável |
