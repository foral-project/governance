# Foral OPA Policy — Validação de catalog-info.yaml
#
# Standard: OPA/Conftest (CNCF Graduated)
# Execução: conftest test catalog-info.yaml --policy policies/
#
# Cada rule `deny[msg]` bloqueia o CI se a condição for verdadeira.
# Mensagens em português para clareza no output do CI.

package foral.catalog

# @context JSON-LD é obrigatório (W3C Recommendation)
deny[msg] {
    not input["@context"]
    msg := "catalog-info.yaml: campo '@context' (JSON-LD) é obrigatório."
}

# @context deve apontar para o protocol Foral
deny[msg] {
    ctx := input["@context"]
    not startswith(ctx, "https://foral-project.github.io/protocol/context/")
    msg := sprintf("catalog-info.yaml: '@context' '%s' não aponta para o Foral Protocol.", [ctx])
}

# apiVersion é obrigatório
deny[msg] {
    not input.apiVersion
    msg := "catalog-info.yaml: campo 'apiVersion' é obrigatório."
}

# apiVersion deve ser valor Backstage válido
deny[msg] {
    allowed := {"backstage.io/v1alpha1", "backstage.io/v1beta1"}
    not allowed[input.apiVersion]
    msg := sprintf("catalog-info.yaml: apiVersion '%s' inválido. Válidos: backstage.io/v1alpha1, backstage.io/v1beta1.", [input.apiVersion])
}

# kind é obrigatório
deny[msg] {
    not input.kind
    msg := "catalog-info.yaml: campo 'kind' é obrigatório."
}

# kind deve ser valor Backstage válido
deny[msg] {
    allowed := {"Component", "API", "Resource", "System", "Domain", "Group", "User", "Template", "Location"}
    not allowed[input.kind]
    msg := sprintf("catalog-info.yaml: kind '%s' inválido.", [input.kind])
}

# metadata é obrigatório
deny[msg] {
    not input.metadata
    msg := "catalog-info.yaml: campo 'metadata' é obrigatório."
}

# metadata.name é obrigatório
deny[msg] {
    input.metadata
    not input.metadata.name
    msg := "catalog-info.yaml: campo 'metadata.name' é obrigatório."
}

# spec é obrigatório
deny[msg] {
    not input.spec
    msg := "catalog-info.yaml: campo 'spec' é obrigatório."
}

# spec.lifecycle é obrigatório
deny[msg] {
    input.spec
    not input.spec.lifecycle
    msg := "catalog-info.yaml: campo 'spec.lifecycle' é obrigatório."
}

# spec.lifecycle deve ser valor válido
deny[msg] {
    input.spec
    input.spec.lifecycle
    allowed := {"experimental", "production", "deprecated"}
    not allowed[input.spec.lifecycle]
    msg := sprintf("catalog-info.yaml: spec.lifecycle '%s' inválido. Válidos: experimental, production, deprecated.", [input.spec.lifecycle])
}

# spec.owner é obrigatório
deny[msg] {
    input.spec
    not input.spec.owner
    msg := "catalog-info.yaml: campo 'spec.owner' é obrigatório."
}

# spec.type é obrigatório
deny[msg] {
    input.spec
    not input.spec.type
    msg := "catalog-info.yaml: campo 'spec.type' é obrigatório."
}
