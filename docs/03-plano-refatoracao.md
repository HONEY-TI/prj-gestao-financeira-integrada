---
name: plano-refatoracao
description: Plano incremental de organização da aplicação na solução Aspire.
---

# Plano de refatoração

## Mapeamento

- `src/WebApi` será preservado como projeto de API e receberá apenas a referência ao `ServiceDefaults`.
- `src/Application`, `src/Domain`, `src/CrossCutting`, `src/Infrastructure`, `src/Repository`, `src/Repository.Mapping` e `src/GlobalException` serão reaproveitados sem reescrita de regras.
- `src/AngularApp` será preservado como frontend Angular/Ionic.
- `src/XunitTests` será preservado como conjunto de testes.
- `src/Migrations` será preservado para os provedores já existentes.
- Novo `src/Despesas.AppHost` orquestrará a API e, quando aplicável, a dependência de infraestrutura explicitamente configurada.
- Novo `src/Despesas.ServiceDefaults` centralizará OpenTelemetry, health checks, resiliência e service discovery comuns.

## Etapas

1. Copiar apenas fontes e configurações relevantes para uma pasta isolada, excluindo `bin`, `obj`, `node_modules`, `dist`, `build` e credenciais.
2. Criar a solução .NET 10 com AppHost e ServiceDefaults.
3. Ajustar referências relativas dos projetos copiados.
4. Integrar a API ao ServiceDefaults e ao AppHost sem mover regras de negócio.
5. Preservar Angular, migrações e testes.
6. Restaurar, compilar e executar testes; registrar limitações reais.
