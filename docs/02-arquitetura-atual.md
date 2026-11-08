---
name: arquitetura-atual
description: Arquitetura e fluxos observados na aplicação original.
---

# Arquitetura atual

## Fluxo de execução

O ponto de entrada é `WebApi/Program.cs`. Ele registra CORS, controllers, versionamento/Swagger, o contexto de dados escolhido, JWT, criptografia, AutoMapper, S3, repositórios, serviços, cross-cutting e health checks. Depois configura middleware de exceção, HTTPS, cultura, CORS, arquivos estáticos, autenticação, autorização e endpoints.

## Camadas

- Domain contém entidades e extensões de domínio.
- Repository e Repository.Mapping encapsulam acesso e mapeamento de dados.
- Infrastructure concentra contexto, provedores de banco, S3 e e-mail.
- Application contém DTOs, contratos, autenticação e regras de aplicação.
- WebApi expõe controllers e configura o pipeline HTTP.
- AngularApp consome a API e é servido como SPA pela API quando publicado.

## Persistência

O código mantém métodos de registro para Oracle, SQL Server, MySQL e InMemory. No `Program.cs` original, o modo ativo é InMemory; os demais estão disponíveis como chamadas comentadas. As connection strings ficam fora do AppHost original, em configuração da API.

## Autenticação

O fluxo usa configuração de assinatura e bearer JWT. Controllers e serviços de aplicação trabalham com os claims do token para identificar o usuário. A autorização é registrada na API.

## Frontend

O frontend é Angular/Ionic e deve permanecer nessa tecnologia. O projeto também contém configurações Capacitor para Android e iOS. A API possui integração SPA para desenvolvimento e publicação.

## Testes

Os testes xUnit cobrem domínio, configuração de dependências, infraestrutura, repositórios e implementações de aplicação. Os testes referenciam os projetos originais e serão copiados para a solução isolada com os caminhos ajustados.
