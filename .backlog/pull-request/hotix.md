---
name: hotix
pr: 2
title: "PR(#2)-hotfix - corrigir ambiente e integração com Redis"
branch: feature/hotix
base: develop
extends: feature-02-hotix
status: open
---

## 📋 Descrição

Implementação do **hotfix - corrigir ambiente e integração com Redis** via feature branch
`feature/hotix`, com commits atômicos e semânticos por arquivo.

As alterações corrigem o ambiente Dev Container/Docker, configuram certificados TLS para o
Redis e integram o AppHost/AppServer com Redis externo ou gerenciado pelo Aspire.

Feature relacionada: `.backlog/features/feature-02-hotix.md`

---

## 📊 Estatísticas

| Métrica | Valor |
| --- | --- |
| 🌿 Branch de origem | `feature/hotix` |
| 🎯 Branch de destino | `develop` |
| 📝 Total de commits | 69 de conteúdo (70 incluindo o commit inicial) |
| 📁 Arquivos alterados | 53 |
| ➕ Linhas adicionadas | 1952 |
| ➖ Linhas removidas | 4945 |

---

## 📦 Repositórios/branches atualizados

- **[HONEY-TI/prj-gestao-financeira-integrada](https://github.com/HONEY-TI/prj-gestao-financeira-integrada)** — branch [`feature/hotix`](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/tree/feature/hotix)
  - Commits: 69 de conteúdo
  - Arquivos alterados: 53
  - Commit publicado: [342d995](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/commit/342d99542dc4bbb3dd8887d7707359c59097fb12)

## Checklist

- [x] Commits separados por arquivo
- [x] Referência da PR incluída nos commits de conteúdo
- [x] Alterações revisadas e enviadas para a branch
- [ ] Revisão funcional
- [ ] Validação em ambiente Linux/jail

## 📝 Commits

- chore(frontend): remover artefato gerado `frontend/obj\\Debug/\\package.g.props` - d9dd643
- feat(raiz): warn frontend `warn-frontend.md` - 6ff2b64
- fix(.devcontainer/setup): setup codex.v1 `.devcontainer/setup/setup-codex.v1.sh` - 21a8e6f
- test(xUnit.Test): xunit.test `xUnit.Test/xUnit.Test.csproj` - 2fac0d6
- refactor(src/Repository): repository `src/Repository/Repository.csproj` - 57c49fa
- fix(src/Repository/CommonDependenceInject): repositorydependenceinject `src/Repository/CommonDependenceInject/RepositoryDependenceInject.cs` - 6e8bab7
- fix(src/Repository.Mapping): repository.mapping `src/Repository.Mapping/Repository.Mapping.csproj` - cb6e258
- fix(src/Infrastructure): infrastructure `src/Infrastructure/Infrastructure.csproj` - f8be917
- feat(src/Infrastructure/CommonDependenceInject): sqlservicesinjectdependence `src/Infrastructure/CommonDependenceInject/SqlServicesInjectDependence.cs` - b0ec2d9
- fix(raiz): prj gestao financeira integrada `prj-gestao-financeira-integrada.slnx` - c4884a9
- chore(migrations/Oracle): appsettings `migrations/Oracle/appsettings.json` - ff66a9d
- chore(migrations/Oracle/Migrations/Application): registercontextmodelsnapshot `migrations/Oracle/Migrations/Application/RegisterContextModelSnapshot.cs` - 128b22e
- fix(migrations/Oracle): migrations.oracle `migrations/Oracle/Migrations.Oracle.csproj` - c5043c0
- chore(migrations/Oracle/Migrations.Application): 20250928171456 initial `migrations/Oracle/Migrations.Application/20250928171456_Initial.cs` - 12d48ba
- chore(migrations/Oracle/Migrations.Application): 20250928171456 initial.designer `migrations/Oracle/Migrations.Application/20250928171456_Initial.Designer.cs` - 555cd38
- chore(migrations/MySqlServer/Migrations/Application): registercontextmodelsnapshot `migrations/MySqlServer/Migrations/Application/RegisterContextModelSnapshot.cs` - 5bd6cef
- refactor(migrations/MySqlServer): migrations.mysqlserver `migrations/MySqlServer/Migrations.MySqlServer.csproj` - 9585da1
- chore(migrations/MySqlServer/Migrations.Application): 20260711040245 initial `migrations/MySqlServer/Migrations.Application/20260711040245_Initial.cs` - 1f4dc57
- chore(migrations/MySqlServer/Migrations.Application): 20260711040245 initial.designer `migrations/MySqlServer/Migrations.Application/20260711040245_Initial.Designer.cs` - 354d020
- chore(migrations/MsSqlServer/Migrations/Application): registercontextmodelsnapshot `migrations/MsSqlServer/Migrations/Application/RegisterContextModelSnapshot.cs` - cbca168
- refactor(migrations/MsSqlServer): migrations.mssqlserver `migrations/MsSqlServer/Migrations.MsSqlServer.csproj` - e3504c8
- chore(migrations/MsSqlServer/Migrations.Application): 20250923144212 initial `migrations/MsSqlServer/Migrations.Application/20250923144212_Initial.cs` - aa1cc03
- chore(migrations/MsSqlServer/Migrations.Application): 20250923144212 initial.designer `migrations/MsSqlServer/Migrations.Application/20250923144212_Initial.Designer.cs` - b11f810
- feat(migrations/DataSeeders/Seeders): dataseederreceita `migrations/DataSeeders/Seeders/DataSeederReceita.cs` - cefc9e7
- feat(migrations/DataSeeders/Seeders): dataseederdespesa `migrations/DataSeeders/Seeders/DataSeederDespesa.cs` - f8f9412
- fix(migrations/DataSeeders/Implementations): seederexceptionhandler `migrations/DataSeeders/Implementations/SeederExceptionHandler.cs` - ce1754c
- fix(frontend): package `frontend/package.json` - 0428732
- chore(AppServer/certificate): gencert `AppServer/certificate/gencert.sh` - 1fd0e16
- security(AppServer): appsettings.development `AppServer/appsettings.Development.json` - 29fe18b
- fix(AppServer/CommonDependenceInject): healthcheckdependencyinject `AppServer/CommonDependenceInject/HealthCheckDependencyInject.cs` - c5f4b79
- fix(AppServer): appserver `AppServer/AppServer.csproj` - 5e4ba91
- fix(AppHost/resources): redisresources `AppHost/resources/RedisResources.cs` - 59765eb
- security(AppHost): appsettings.development `AppHost/appsettings.Development.json` - 3f9925d
- fix(AppHost/Properties): launchsettings `AppHost/Properties/launchSettings.json` - ac777f3
- fix(AppHost): apphost `AppHost/AppHost.csproj` - 84717c5
- fix(AppHost): apphost `AppHost/AppHost.cs` - d198c87
- fix(raiz): .gitignore `.gitignore` - 7510af9
- fix(.devcontainer/setup): setup codex `.devcontainer/setup/setup-codex.sh` - 38b31a7
- fix(.devcontainer/scripts): dotnetrun `.devcontainer/scripts/dotnetrun` - 6b1bc53
- fix(.devcontainer): docker entrypoint `.devcontainer/docker-entrypoint.sh` - d0ad971
- test(.devcontainer): docker compose `.devcontainer/docker-compose.yml` - 192c11b
- fix(.devcontainer): devcontainer `.devcontainer/devcontainer.json` - 87d8713
- fix(.devcontainer): dockerfile `.devcontainer/Dockerfile` - d564d1a
- docs(backlog): sincronizar métricas da PR hotfix `.backlog/pull-request/hotix.md` - a84cab3
- docs(backlog): detalhar título e corpo do hotfix `.backlog/pull-request/hotix.md` - 012c970
- docs(backlog): marcar PR hotix como aberta `.backlog/pull-request/hotix.md` - a9578f5
- docs(backlog): atualizar métricas da PR hotix `.backlog/pull-request/hotix.md` - 82f81da
- feat(redis): implementar recursos Redis externo e gerenciado `AppHost/resources/RedisResources.cs` - 342d995
- chore(docker): adicionar regras locais de contexto `.docker/.dockerignore` - ac68dc3
- feat(devcontainer): adicionar inicialização do shell `.devcontainer/setup/setup-shell.sh` - 081379a
- feat(devcontainer): manter variante legada de certificados `.devcontainer/setup/setup-dev-certs.v1.sh` - f6d9665
- docs(backlog): registrar documentação da PR hotix `.backlog/pull-request/hotix.md` - f275792
- docs(backlog): registrar feature hotix `.backlog/features/feature-02-hotix.md` - a0409ae
- fix(config): remover variável Redis da configuração base `AppServer/appsettings.json` - 20a1ecb
- fix(config): remover variável Redis duplicada `AppServer/appsettings.Development.json` - 2976f03
- feat(redis): adicionar suporte DotNetEnv ao AppServer `AppServer/AppServer.csproj` - d42f342
- fix(config): definir conexão Redis do AppHost `AppHost/appsettings.Development.json` - 4ca0b0c
- feat(redis): adicionar suporte DotNetEnv ao AppHost `AppHost/AppHost.csproj` - a4bd96f
- feat(redis): usar cache externo no AppHost `AppHost/AppHost.cs` - 143827f
- chore(docker): organizar arquivos ignorados no build `.dockerignore` - 7b90ff8
- fix(devcontainer): atualizar tarefas de inicialização `.devcontainer/setup/start.sh` - fe80d27
- feat(devcontainer): configurar certificados TLS do Redis `.devcontainer/setup/setup-dev-certs.sh` - 2ee5c3e
- fix(devcontainer): ajustar abertura do navegador do Codex `.devcontainer/setup/setup-codex.sh` - aaaf872
- fix(docker): sincronizar permissões e acesso ao Docker `.devcontainer/docker-entrypoint.sh` - 6df2995
- fix(docker): conectar ambiente ao Redis externo `.devcontainer/docker-compose.yml` - b38fdb1
- fix(config): configurar recursos do devcontainer `.devcontainer/devcontainer.json` - 053f7cb
- fix(docker): ajustar imagem e troca automática de usuário `.devcontainer/Dockerfile` - 2774abc
- fix(config): configurar conexão Redis do ambiente `.devcontainer/.env.example` - 05fb318
