# 2. Core Platform Vision

Date: 2026-04-16
Status: Accepted

## Context

We require a centralized platform identity model that transcends individual applications and avoids coupling the governance framework to any specific GitHub username, organization, or legacy identifier.

## Decision

We establish the `idp-root` as the absolute legislative root of the ecosystem. The platform identity is not a hardcoded constant but a **runtime parameter** (`TENANT_ID`) injected via GitHub Variables, Terraform variables, or local `.env` files. This ensures the framework is portable: any developer can fork the repository, configure their own identity, and operate an independent ecosystem without modifying committed source files.

## Consequences

- Simplifies taxonomy globally by decoupling governance from tenant identity.
- Enables fork-and-configure adoption for ad-hoc usage by external developers.
- Removes environmental coupling from the root identity namespace.
