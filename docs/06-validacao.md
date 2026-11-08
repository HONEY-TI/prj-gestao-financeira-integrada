---
name: validacao
description: Comandos executados e resultados da validação da solução refatorada.
---

# Validação

## Executado

- `dotnet --info`: sucesso; SDK 10.0.403.
- `dotnet restore DespesasRefatorado.slnx`: sucesso, com avisos de vulnerabilidades herdadas.
- `dotnet build src/Despesas.AppHost/Despesas.AppHost.csproj --no-restore`: sucesso, 0 erros.
- `dotnet build DespesasRefatorado.slnx --no-restore`: falha somente ao compilar `XunitTests` por chamadas antigas da API do AutoMapper 16; o AppHost e os projetos de aplicação compilam.

## Pendências

- `dotnet test` precisa de uma atualização compatível dos testes para a API atual do AutoMapper. Essa mudança não foi feita automaticamente para não alterar o comportamento esperado dos testes sem uma decisão de compatibilidade.
- `aspire run` não foi executado porque a CLI/template Aspire não está instalada no ambiente; o AppHost foi validado por build.
- A execução integrada depende de configuração externa de banco, S3, JWT e certificados. Nenhum segredo foi copiado para esta pasta.
- O restore reporta vulnerabilidades em dependências herdadas (`MySqlConnector`, `System.Security.Cryptography.Pkcs` e OpenTelemetry). A atualização dessas versões ficou fora do escopo conservador desta etapa.
