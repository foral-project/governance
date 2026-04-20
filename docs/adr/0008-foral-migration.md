# ADR 0008: Migração de idp-root para foral-project

- **Status:** Aceito
- **Data:** 2026-04-20
- **Decisores:** gabrielbarbosel

## Contexto

O projeto de governança federada foi iniciado sob o nome `idp-root` com foco
em Internal Developer Platform. Durante o refinamento arquitetural, identificamos
que o escopo real é mais amplo: um **protocolo de federação constitucional**
para governança de repositórios, inspirado nos forais medievais portugueses.

O nome `idp-root` era limitante e não refletia a natureza do projeto.

## Decisão

Migrar de `idp-root` para `foral-project` (GitHub Org) com separação em:

1. **protocol** — Especificação vendor-agnostic (schemas, templates, contexts)
2. **governance** — Framework instanciável (workflows, policies, registry)
3. **cli** — Ferramenta de linha de comando
4. **.github** — Org profile

## Consequências

### Positivas

- Nome alinhado com a metáfora constitucional do projeto
- Separação protocol/governance permite consumo independente
- Org pública (repos públicos) = CI ilimitado no GitHub Free
- Standards de mercado substituíram formatos inventados (18 standards rastreáveis)

### Negativas

- Submodules e referências do `idp-root` precisaram ser removidos
- ADRs 0001-0007 mantêm referências históricas ao contexto `idp-root`
- Git history da org anterior não foi preservado (fresh start)

## Standards Adotados na Migração

| # | Standard | Autoridade |
|---|---|---|
| 1 | JSON Schema Draft 2020-12 | IETF |
| 2 | JSON-LD 1.1 | W3C |
| 3 | Backstage catalog-info.yaml | CNCF (Incubating) |
| 4 | CloudEvents 1.0.3 | CNCF (Graduated) |
| 5 | OPA/Conftest | CNCF (Graduated) |
| 6 | SemVer 2.0.0 | semver.org |
| 7 | Conventional Commits 1.0.0 | conventionalcommits.org |
| 8 | RFC 1123 DNS Labels | IETF |
| 9 | POSIX Naming | IEEE |
| 10 | arc42 | arc42.org |
| 11 | ADR Nygard Format | De facto standard |
| 12 | Apache-2.0 | OSI |
| 13 | OpenTofu | Linux Foundation |
| 14 | release-please | Google (Apache-2.0) |
| 15 | GitHub Actions Reusable Workflows | GitHub |
| 16 | SPDX License Identifiers | Linux Foundation |
| 17 | RFC 7807 Problem Details | IETF |
| 18 | RFC-style Specification | IETF |
