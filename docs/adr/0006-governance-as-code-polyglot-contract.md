# 6. Governance-as-Code (Polyglot Contract)

Date: 2026-04-16
Status: Accepted

## Context

Configuration files defining our organizational rules (e.g., `meta-rules.yaml`) typically suffer from proprietary, invented keys (like `rule:` or `format:`). This creates parsing bottlenecks because they are not natively understood by continuous integration tools (Linters) or generative AI Agents.

## Decision

We adopt the **Polyglot Contract** via JSON Schema / OpenAPI taxonomy for all declarative governance files.

All configuration structures will natively employ standardized validation keys:

- `description`: The philosophical and logical context (For AI and Human interpretation).
- `pattern`: Strict Regular Expression (Regex) boundaries (For CI/CD Machine validation).
- `examples`: Arrays of valid contextual inputs (For immediate Human reference).
- `const` / `enum`: Immutable baseline flags.

## Consequences

- Linters and CI/CD tools can natively ingest and natively validate `.github/governance/meta-rules.yaml` without custom scripting.
- AI Agents can holistically map intent (`description`) while being tightly constrained by programmatic output limits (`pattern`).
- Eradicates custom declarative scripting logic in favor of industry enterprise standardization.
