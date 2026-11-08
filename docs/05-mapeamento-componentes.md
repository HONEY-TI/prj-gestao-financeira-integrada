---
name: mapeamento-componentes
description: Relação entre componentes originais e componentes da solução refatorada.
---

# Mapeamento de componentes

- `src/Domain` -> `src/Domain`: reaproveitado.
- `src/Application` -> `src/Application`: reaproveitado.
- `src/CrossCutting` -> `src/CrossCutting`: reaproveitado.
- `src/Infrastructure` -> `src/Infrastructure`: reaproveitado.
- `src/Repository` -> `src/Repository`: reaproveitado.
- `src/Repository.Mapping` -> `src/Repository.Mapping`: reaproveitado.
- `src/GlobalException` -> `src/GlobalException`: reaproveitado.
- `src/WebApi` -> `src/WebApi`: reaproveitado, com integração ao ServiceDefaults.
- `src/AngularApp` -> `src/AngularApp`: preservado na tecnologia original.
- `src/Migrations` -> `src/Migrations`: preservado, com configurações sanitizadas sem credenciais.
- `src/XunitTests` -> `src/XunitTests`: preservado; falhas atuais estão documentadas na validação.
- inexistente -> `src/Despesas.AppHost`: novo componente de orquestração.
- inexistente -> `src/Despesas.ServiceDefaults`: novo componente compartilhado de infraestrutura transversal.

Nenhuma funcionalidade de negócio foi criada para preencher lacunas.
