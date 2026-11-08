---
name: inventario
description: Inventário da aplicação original usado como base para a refatoração Aspire.
---

# Inventário

## Aplicação

- API ASP.NET Core em `src/WebApi`, compilada para `net10.0`.
- Camadas existentes: Domain, CrossCutting, Repository, Repository.Mapping, Infrastructure, Application e GlobalException.
- Frontend Angular/Ionic em `src/AngularApp`, com Capacitor para Android e iOS.
- Testes xUnit em `src/XunitTests`.

## Persistência e integrações

- Entity Framework Core com provedores InMemory, SQL Server, MySQL e Oracle.
- Migrações e seeders separados em `src/Migrations`.
- Integração com Amazon S3 para imagens.
- Envio de e-mail presente na infraestrutura.
- JWT para autenticação e autorização.
- Health checks e Health Checks UI configurados na API.

## Configuração e infraestrutura

- Configurações em `appsettings*.json` da API e dos projetos de migração.
- Dockerfiles e docker-compose existentes no repositório original.
- Certificados locais existentes; nenhum segredo será copiado para a solução refatorada.
- A aplicação já usa .NET 10, portanto a migração de framework não exige alteração de target.

## Dependências principais

- `WebApi` referencia `Application`.
- `Application` referencia CrossCutting, Domain, Infrastructure e Repository.
- Infrastructure referencia Domain e Repository.Mapping.
- Repository referencia Domain e Infrastructure.
- Migrations referencia Application, Infrastructure, Repository e DataSeeders.
- Angular é integrado à API por configuração SPA e proxy de desenvolvimento.

## Limitações identificadas

- Não há um AppHost Aspire na aplicação original.
- A CLI/template Aspire não está instalada no ambiente atual.
- Os arquivos de contexto do agente são placeholders e não acrescentam regras de negócio.
- A topologia de banco é selecionável por configuração/código; nenhum banco será adicionado ao AppHost sem evidência de necessidade.
