# Foral OPA Policy — Validação de naming conventions
#
# Standard: OPA/Conftest (CNCF Graduated)
# Execução: conftest test catalog-info.yaml --policy policies/
#
# Valida que metadata.name segue RFC 1123 DNS Label.
# Valida que spec.owner segue o mesmo padrão.

package foral.naming

# metadata.name deve ser DNS label válido (RFC 1123)
deny[msg] {
    name := input.metadata.name
    not re_match(`^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$`, name)
    msg := sprintf("metadata.name '%s' não é um DNS label válido (RFC 1123). Use: lowercase, hyphens, sem underscores.", [name])
}

# metadata.name não pode exceder 63 caracteres (limite RFC 1123)
deny[msg] {
    name := input.metadata.name
    count(name) > 63
    msg := sprintf("metadata.name '%s' excede 63 caracteres (limite RFC 1123).", [name])
}

# metadata.name não pode começar ou terminar com hyphen
deny[msg] {
    name := input.metadata.name
    startswith(name, "-")
    msg := sprintf("metadata.name '%s' não pode começar com hyphen.", [name])
}

deny[msg] {
    name := input.metadata.name
    endswith(name, "-")
    msg := sprintf("metadata.name '%s' não pode terminar com hyphen.", [name])
}

# spec.owner deve ser DNS label válido (RFC 1123)
deny[msg] {
    input.spec.owner
    owner := input.spec.owner
    not re_match(`^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$`, owner)
    msg := sprintf("spec.owner '%s' não é um DNS label válido (RFC 1123).", [owner])
}

# Tags (se existirem) devem ser kebab-case
deny[msg] {
    input.metadata.tags
    tag := input.metadata.tags[_]
    not re_match(`^[a-z0-9][a-z0-9-]*[a-z0-9]$`, tag)
    not re_match(`^[a-z0-9]$`, tag)
    msg := sprintf("metadata.tags contém '%s' que não é kebab-case válido.", [tag])
}
