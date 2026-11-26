---
name: hotix
pr: 2
title: "PR(#2)-hotix"
branch: feature/hotix
base: develop
extends: feature-02-hotix
status: open
---

## 📋 Descrição

Implementação da **hotix** via feature branch `feature/hotix`, com commits atômicos e
semânticos por arquivo.

As alterações corrigem o ambiente Dev Container/Docker, configuram certificados TLS para o
Redis e integram o AppHost/AppServer com Redis externo ou gerenciado pelo Aspire.

Feature relacionada: `.backlog/features/feature-02-hotix.md`

---

## 📊 Estatísticas

| Métrica | Valor |
| --- | --- |
| 🌿 Branch de origem | `feature/hotix` |
| 🎯 Branch de destino | `develop` |
| 📝 Total de commits | 21 de conteúdo (22 incluindo o commit inicial) |
| 📁 Arquivos alterados | 21 |
| ➕ Linhas adicionadas | 871 |
| ➖ Linhas removidas | 165 |

---

## 📦 Repositórios/branches atualizados

- **[HONEY-TI/prj-gestao-financeira-integrada](https://github.com/HONEY-TI/prj-gestao-financeira-integrada)** — branch [`feature/hotix`](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/tree/feature/hotix)
  - Commits: 21 de conteúdo
  - Arquivos alterados: 21
  - Commit publicado: [342d995](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/commit/342d99542dc4bbb3dd8887d7707359c59097fb12)

## Checklist

- [x] Commits separados por arquivo
- [x] Referência da PR incluída nos commits de conteúdo
- [x] Alterações revisadas e enviadas para a branch
- [ ] Revisão funcional
- [ ] Validação em ambiente Linux/jail

## 📝 Commits

- feat(redis): implementar recursos Redis externo e gerenciado `AppHost/resources/RedisResources.cs` - 342d995
- chore(docker): adicionar regras locais de contexto `.docker/.dockerignore` - ac68dc3
- feat(devcontainer): adicionar inicialização do shell `.devcontainer/setup/setup-shell.sh` - 081379a
- feat(devcontainer): manter variante legada de certificados `.devcontainer/setup/setup-dev-certs.v1.sh` - f6d9665
- docs(backlog): registrar documentação da PR hotix `.backlog/pull-request/hotix.md` - f2757925
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
