# Adotando o Foral Protocol

Tempo estimado: **5 minutos** para validação básica, **10 minutos** para federação completa.

## Pré-requisitos

Nenhum. Se quiser validação local, instale o CLI:

```bash
# go install
go install github.com/foral-project/cli@latest

# binário direto (Linux/macOS)
curl -sfL https://foral-project.github.io/protocol/install.sh | sh
```

---

## Opção 1: Via CLI (recomendado)

```bash
foral init my-project
```

Interativo:
```
? Nome do projeto: my-project
? Archetype: application
? Owner: my-org
? Lifecycle: experimental
? CI platform: github

✅ Criado:
  my-project/catalog-info.yaml
  my-project/.github/workflows/foral.yml
  my-project/.gitignore
```

Pronto. O CI já valida contra o Foral Protocol automaticamente.

---

## Opção 2: Via Template (GitHub)

1. Acesse [foral-project/template](https://github.com/foral-project/template)
2. Clique **"Use this template"** → **"Create a new repository"**
3. Edite `catalog-info.yaml` com os dados do seu projeto

---

## Opção 3: Manual (qualquer Git host)

### Passo 1: Adicione `catalog-info.yaml` na raiz do repo

```yaml
"@context": "https://foral-project.github.io/protocol/context/v1/catalog.jsonld"
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-project           # RFC 1123 DNS label
  description: "Descrição do projeto."
  annotations:
    foral.dev/archetype: application
  tags:
    - my-tag
spec:
  type: service
  lifecycle: experimental      # experimental | production | deprecated
  owner: my-org                # RFC 1123 DNS label
```

### Passo 2: Adicione CI (GitHub Actions)

Crie `.github/workflows/foral.yml`:

```yaml
name: Foral Validation
on: [push, pull_request]

jobs:
  catalog:
    uses: foral-project/governance/.github/workflows/validate-catalog.yml@main

  naming:
    uses: foral-project/governance/.github/workflows/validate-naming.yml@main

  commits:
    uses: foral-project/governance/.github/workflows/validate-conventional.yml@main
```

### Passo 3: Valide localmente

```bash
foral validate
```

Output:
```
✅ JSON Schema     catalog-info.yaml válido
✅ OPA Policies    catalog-info.yaml compliant (18/18 rules)
✅ Naming          metadata.name é DNS label válido (RFC 1123)
✅ Tags            Todas kebab-case
```

---

## Federação (opcional)

Para registrar seu repo em uma federação existente:

1. Abra um **Pull Request** no `federation-registry.yaml` da governance:

```yaml
spec:
  locations:
    - type: url
      target: "https://github.com/my-org/my-project/blob/main/catalog-info.yaml"
      version: "v1.0.0"
```

2. O CI automaticamente:
   - Detecta o novo membro (diff contra base)
   - Fetch `catalog-info.yaml` do seu repo
   - Valida schema + OPA policies
   - Label: `federation-approved` ou `federation-rejected`

---

## Customização

### Policies customizadas

Baixe as policies de referência e estenda:

```bash
mkdir policies/
curl -sfL https://foral-project.github.io/governance/policies/catalog-info.rego -o policies/catalog-info.rego
curl -sfL https://foral-project.github.io/governance/policies/naming.rego -o policies/naming.rego

# Adicione suas próprias rules:
echo 'package foral.custom
deny[msg] {
    not input.metadata.annotations["my-org.dev/team"]
    msg := "Annotation my-org.dev/team é obrigatória."
}' > policies/custom.rego
```

Depois, use `policies-source: local` no workflow:

```yaml
jobs:
  catalog:
    uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
    with:
      policies-source: "local"
```

### Protocol URL customizado

Se hospedar schemas em outro lugar:

```yaml
jobs:
  catalog:
    uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0.1.0
    with:
      schema-url: "https://my-org.github.io/my-protocol/schemas/v1/catalog-info.schema.yaml"
```

---

## Versionamento

Todas as interfaces do Foral são versionadas via SemVer:

```yaml
# Pinado na versão exata (produção):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0.1.0

# Latest minor (recebe patches):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@v0

# Latest (edge — não recomendado para produção):
uses: foral-project/governance/.github/workflows/validate-catalog.yml@main
```

---

## Referências

- [Protocol Specification](https://github.com/foral-project/protocol/blob/main/PROTOCOL.md)
- [JSON Schemas](https://foral-project.github.io/protocol/schemas/v1/)
- [OPA Policies](https://foral-project.github.io/governance/policies/)
- [CLI Documentation](https://github.com/foral-project/cli)
