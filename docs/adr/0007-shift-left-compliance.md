# 7. Shift-Left Compliance (Git-Native Governance)

Date: 2026-04-16
Status: Accepted

## Context

Centralized CI/CD linters executed solely on the server create a slow feedback loop. Conversely, securely tying linters to specific IDE settings (e.g., `.vscode`) alienates developers using alternative editors and blatantly violates platform agnostic principles.

## Decision

We adopt the **Pre-Commit Framework** as the absolute Shift-Left compliance enforcer.

- **Git-Native:** Compliance is mathematically bound to the version control lifecycle (`git commit`), acting independently of any text editor or local IDE environment.
- **The Bootstrap Contract:** A `Makefile` ensures developers can seamlessly synchronize and instantiate the Global Hook Registry (`.pre-commit-config.yaml`) locally via minimal commands.
- **Dev/Prod Parity:** The exact local validation sequence (`pre-commit run --all-files`) is mirrored flawlessly in the centralized Continuous Integration platform (`meta-compliance.yml`).

## Consequences

- Prevents malformed syntax (e.g., Markdown MD032 violations, invalid YAML) from ever entering the Git source tree.
- Dramatically reduces cloud compute billing overhead by failing fast locally.
- Completely decouples systemic governance from individual developer environment preferences.
