# 5. Repository Topology and Separation of Concerns

Date: 2026-04-16
Status: Accepted

## Context

Centralized mono-repos scale poorly. Conversely, unchecked decentralization lacks standardisation.

## Decision

We divide all ecosystem capabilities into three strict repositories, explicitly following the **OpenGitOps Framework & CNCF Team Topologies** taxonomy:

1. **Platform Repository:** The Platform Repository (`.github` singleton) governs platform schemas, ADRs, and policies via Governance-as-Code. Zero cloud deployment capability.
2. **Infrastructure Repository:** Infrastructure Repositories (CI/CD execution environments) hold the infrastructure as code (IaC), secrets, and reusable deployment pipelines. They handle infrastructure deployments securely.
3. **Application Repository:** Application Repositories generate pure business logic code. They output explicit state (`project-manifest.yaml`) but NEVER possess direct cloud deployment keys.

## Consequences

- Absolute separation of concerns. Developers focus exclusively on business workloads while DevOps iterates exclusively on the Automation mechanics.
