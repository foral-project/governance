# 1. Architecture Decision Records

Date: 2026-04-16
Status: Accepted

## Context

Before any infrastructure is deployed or repository initialized, we must encode our architectural choices to maintain strict historical logic.

## Decision

We adopt the Nygard ADR standard.

- Format: `NNNN-short-title-in-kebab-case.md`.
- Sections: Title, Date, Status, Context, Decision, Consequences.

### Philosophical Constraint: Archetype Over Instance

All ADRs and global architecture documents must legally trace to **Architectural Archetypes** (e.g., "Edge Interface", "Operational Repository") rather than hardcoded infrastructure instances or specific public vendor trademarks. The Meta-Repository (`.github`) must remain completely abstract and instance agnostic to protect logic against documentation decay.

## Consequences

- Imposes strict immutability on conceptual shifts.
