# 4. Master Nomenclature Table

Date: 2026-04-16
Status: Accepted

## Context

The legacy 5-Drawer rule forced unnecessary regional scoping onto purely logical code boundaries (e.g., GitHub Actions pipelines). We need distinct rules for distinct spatial boundaries.

## Decision

Adopt the Master Nomenclature Table natively. All nomenclature and topology rules are strictly validated via **IETF JSON Schema (Draft 2020-12)** semantics, completely abandoning "Loose YAML" structures.

### The Standard Ruleset

- **Tenant Identity:** `{Tenant}` (injected at runtime via `vars.TENANT_ID` or `var.tenant_id`). Never hardcoded in committed files.
- **Repositories:** `{Context}-{Type}`.
- **Compute/Hot Cloud Infra:** `{Type}-{Identity}-{Context}-{Env}-{Region}`.
- **Storage/Hot Cloud Infra:** `{Type}-{Identity}-{Context}-{Env}-{Region}`.
- **GitHub Workflows (`.yml` files):** `{Action}-{Target}.yml` or `{Event}-{Pipeline}.yml`.

### Architectural Axioms

1. **The Tenant Purge:** Cloud resources must be decoupled from the global tenant root. `{Identity}` is exclusively the bounded Domain logic (e.g., `telegram` or `core`).
2. **The Type Authority:** The `{Type}` drawer must never leak cloud provider names (like `oci` or `aws`). It must strictly use hardware/software abstractions from the internal Cloud Resource Taxonomy defined in `dictionary.yaml` (e.g., `vm`, `vcn`, `bkt`).
3. **The Parameterization Principle:** The `{Tenant}` drawer exists at the cloud account/project level and is injected via runtime configuration. It is never embedded into resource names or committed governance files.

## Consequences

- Isolates the rigorous 5-drawer schema exclusively for deployed hyperscaler resources.
- Dramatically simplifies CI/CD pipeline declarations.
- Reduces pipeline complexity by separating Infrastructure Repository boundaries from pure Application Repository logic.
- Enables the full nomenclature system to work for any tenant without source modifications.
