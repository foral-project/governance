# ADR 0009: Governance como Framework Instanciável

- **Status:** Aceito
- **Data:** 2026-04-20
- **Decisores:** gabrielbarbosel

## Contexto

O repositório `governance` inicialmente misturava dois papéis:

1. **Framework** — reusable workflows, reference policies (o que outros consomem)
2. **Instância** — federation registry, CI ativo (o que governa foral-project)

Analogia: ter o código-fonte do Kubernetes e um cluster de produção no mesmo lugar.

Quando um usuário quer adotar Foral, ele deveria **consumir** o framework,
não **forkar** o repositório.

## Opções Consideradas

### Opção A: Fork do governance

- Usuário faz fork do repo
- Mantém sua cópia com customizações
- **Rejeitado:** Viola o princípio de upstream. Forks divergem. Atualizações viram merge conflicts.

### Opção B: Governance como framework consumível ✅

- Workflows são `workflow_call` (reusable)
- Qualquer repo chama via `uses: foral-project/governance/.github/workflows/...@v0.1.0`
- Policies publicadas via GitHub Pages (HTTP GET)
- CLI instala e valida localmente

## Decisão

**Opção B.** O governance publica reusable workflows e policies.
Consumidores referenciam via `uses:` (CI) ou URLs (policies).
O repo governance é simultaneamente o framework E a primeira instância
(dogfooding via `ci.yml` que chama seus próprios reusable workflows).

## Consequências

### Positivas

- Zero fork necessário
- Versionamento via SemVer tags (`@v0.1.0`)
- Consumidores recebem updates ao mover a tag
- CLI resolve schemas e policies via HTTP (offline-capable com cache)
- Policies customizáveis sem alterar o framework

### Negativas

- Reusable workflows do GitHub Actions são restritos a repos públicos para cross-org
- Migração para GitLab/Gitea requer reimplementação de `workflow_call`
  (mas policies e schemas são HTTP — portáveis)

## Impacto nos Standards

Nenhum standard foi adicionado ou removido. O formato dos workflows mudou de
`on: push` para `on: workflow_call` — mudança interna, sem impacto na spec.
