---
name: arquitetura-destino
description: Arquitetura alvo da solução isolada com .NET Aspire.
---

# Arquitetura de destino

## Topologia

```text
Despesas.AppHost
└── webapi (src/WebApi)
    └── Despesas.ServiceDefaults
        ├── OpenTelemetry
        ├── health checks
        ├── service discovery
        └── HTTP resilience
```

O AppHost não cria bancos, filas ou caches porque a aplicação original não possui um único recurso externo ativo no fluxo principal. Os provedores de banco e as migrações continuam disponíveis nos projetos reaproveitados.

## Responsabilidades

- AppHost compõe processos e endpoints externos.
- ServiceDefaults concentra telemetria, saúde e padrões HTTP comuns.
- WebApi mantém controllers, autenticação, middleware, SPA e composição das dependências existentes.
- As camadas de domínio, aplicação, persistência e migrações mantêm suas responsabilidades originais.
