---
name: reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento
pr: 1
title: "PR(#1)-Reorganizar estrutura da aplicação e ambiente de desenvolvimento"
branch: feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento
base: develop
extends: feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento
status: open
---

## 📋 Descrição

Implementação da **Reorganizar estrutura da aplicação e ambiente de desenvolvimento** via feature branch `feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento`, com commits atômicos e semânticos por arquivo.

Feature relacionada: `.backlog/features/feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md`

---

## 📊 Estatísticas

| Métrica | Valor |
| --- | --- |
| 🌿 Branch de origem | `feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento` |
| 🎯 Branch de destino | `develop` |
| 📝 Total de commits | 143 |
| 📁 Arquivos alterados | 110 |
| ➕ Linhas adicionadas | 653 |
| ➖ Linhas removidas | 632 |

---

## 📦 Repositórios/branches atualizados

- **[prj-gestao-financeira-integrada](https://github.com/HONEY-TI/prj-gestao-financeira-integrada)** — branch [`feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento`](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/tree/feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento)
  - Commits: 142 (excluindo o commit inicial vazio)
  - Arquivos alterados: 110 — reorganização de projetos, ambiente, configurações e testes

---

## Checklist

- [x] Commits separados por arquivo
- [x] Referência da PR incluída nos commits de conteúdo
- [x] Alterações revisadas e enviadas para a branch
- [ ] Revisão funcional
- [ ] Validação em ambiente Linux/jail

---

## 📝 Commits

- fix(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - daeb55b
- test(raiz): prj gestao financeira integrada `prj-gestao-financeira-integrada.slnx` - ca8cf0d
- feat(Server/wwwroot): .gitkeep `Server/wwwroot/.gitKeep` - c9136a6
- test(Server): generate coverage report `Server/generate_coverage_report.sh` - bc0c23c
- feat(Server/certificate): gencert `Server/certificate/gencert.sh` - cfea573
- security(Server): appsettings `Server/appsettings.json` - 0497032
- security(Server): appsettings.development `Server/appsettings.Development.json` - 471e6fd
- feat(Server): server `Server/Server.http` - 8d5f64a
- feat(Server): server `Server/Server.csproj` - bf8ac13
- feat(Server/Properties): launchsettings `Server/Properties/launchSettings.json` - 5678be4
- test(Server): program `Server/Program.cs` - 6210e86
- feat(Server/Options): healthcheckoptions `Server/Options/HealthCheckOptions.cs` - e31b939
- feat(Server): extensions `Server/Extensions.cs` - 087bc06
- refactor(Server/Controllers): usuariocontroller `Server/Controllers/UsuarioController.cs` - 06d5dba
- refactor(Server/Controllers): saldocontroller `Server/Controllers/SaldoController.cs` - 05c5db5
- refactor(Server/Controllers): receitacontroller `Server/Controllers/ReceitaController.cs` - 7fad063
- refactor(Server/Controllers): lancamentocontroller `Server/Controllers/LancamentoController.cs` - 0214988
- refactor(Server/Controllers): imagemperfilusuariocontroller `Server/Controllers/ImagemPerfilUsuarioController.cs` - 9e2659d
- refactor(Server/Controllers): graficoscontroller `Server/Controllers/GraficosController.cs` - eb00164
- refactor(Server/Controllers): despesacontroller `Server/Controllers/DespesaController.cs` - 2d8ced7
- refactor(Server/Controllers): categoriacontroller `Server/Controllers/CategoriaController.cs` - 0c9a4c4
- refactor(Server/Controllers): authcontroller `Server/Controllers/AuthController.cs` - 4c54423
- refactor(Server/Controllers): acessocontroller `Server/Controllers/AcessoController.cs` - 9b63dc5
- refactor(Server/Controllers/Abstractions): unitcontrollerbase `Server/Controllers/Abstractions/UnitControllerBase.cs` - c0fd72c
- refactor(Server/CommonDependenceInject): swaggerapiversioningdependenceinject `Server/CommonDependenceInject/Swaggerapiversioningdependenceinject.cs` - b22a221
- feat(Server/CommonDependenceInject): supportculturesdependenceinject `Server/CommonDependenceInject/SupportCulturesDependenceInject.cs` - 0903a25
- feat(Server/CommonDependenceInject): healthcheckdependencyinject `Server/CommonDependenceInject/HealthCheckDependencyInject.cs` - fc1b365
- feat(Server/CommonDependenceInject): autorizationdependenceinject `Server/CommonDependenceInject/AutorizationDependenceInject.cs` - 5ea03aa
- test(Server): applicationbuilderextensions `Server/ApplicationBuilderExtensions.cs` - f4087ce
- test(Server): .editorconfig `Server/.editorconfig` - c5eb521
- refactor(AppHost/resources): serverhealthresources `AppHost/resources/ServerHealthResources.cs` - 0201248
- feat(AppHost/resources): endpointresource `AppHost/resources/EndpointResource.cs` - 806b22a
- feat(AppHost/resources): endpointhealthcheck `AppHost/resources/EndpointHealthCheck.cs` - efe50bc
- feat(AppHost): appsettings `AppHost/appsettings.json` - 24a1e6b
- feat(AppHost): appsettings.development `AppHost/appsettings.Development.json` - a625230
- feat(AppHost/Properties): launchsettings `AppHost/Properties/launchSettings.json` - 1504b96
- security(AppHost): apphost `AppHost/AppHost.csproj` - ddf2da6
- feat(AppHost): apphost `AppHost/AppHost.cs` - 00af958
- feat(raiz): .gitignore `.gitignore.codex` - 487f2b0
- test(raiz): .dockerignore `.dockerignore` - 51a349a
- security(.devcontainer/scripts): setup dev certs `.devcontainer/scripts/setup-dev-certs.sh` - 8cc7784
- feat(.devcontainer/scripts): setup antigravity `.devcontainer/scripts/setup-antigravity.sh` - feb90cd
- feat(.devcontainer/scripts): docker entrypoint `.devcontainer/scripts/docker-entrypoint.sh` - e60a032
- feat(.devcontainer/scripts): aspire certs `.devcontainer/scripts/aspire-certs.sh` - fcc1dab
- test(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - 7d410fb
- test(.backlog/features): feature 01 reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/features/feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - 5aba5d3
- chore(xUnit.Test): xunit.test.csproj `xUnit.Test/xUnit.Test.csproj.bck` - 80c1e9d
- fix(xUnit.Test): xunit.test `xUnit.Test/xUnit.Test.csproj` - 2fe216a
- test(xUnit.Test): coverage report `xUnit.Test/coverage_report.ps1` - a9143ae
- fix(xUnit.Test/Repository/UnitOfWork): unitofworktest `xUnit.Test/Repository/UnitOfWork/UnitOfWorkTest.cs` - 09b033c
- fix(xUnit.Test/Repository/Persistency/Implementations): usuariorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/UsuarioRepositorioImplTest.cs` - e55f08f
- fix(xUnit.Test/Repository/Persistency/Implementations): saldorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/SaldoRepositorioImplTest.cs` - 0b9b32c
- fix(xUnit.Test/Repository/Persistency/Implementations): receitarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/ReceitaRepositorioImplTest.cs` - e5c37a8
- fix(xUnit.Test/Repository/Persistency/Implementations): lancamentorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/LancamentoRepositorioImplTest.cs` - 70e2502
- fix(xUnit.Test/Repository/Persistency/Implementations): graficorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/GraficoRepositorioImplTest.cs` - d62bb6a
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): saldorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/SaldoRepositorioFixture.cs` - af6405f
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): lancamentorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/LancamentoRepositorioFixture.cs` - f0a026a
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): graficorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/GraficoRepositorioFixture.cs` - b857f3d
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): acessorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/AcessoRepositorioFixture.cs` - ce6dd3d
- fix(xUnit.Test/Repository/Persistency/Implementations): despesarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/DespesaRepositorioImplTest.cs` - 5991a49
- test(xUnit.Test/Repository/Persistency/Implementations): categoriarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/CategoriaRepositorioImplTest.cs` - 5f0f71d
- fix(xUnit.Test/Repository/Persistency/Implementations): acessorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/AcessoRepositorioImplTest.cs` - 5923e22
- fix(xUnit.Test/Repository/Persistency/Generic): genericrepositoriotest `xUnit.Test/Repository/Persistency/Generic/GenericRepositorioTest.cs` - 6a0b6d9
- fix(xUnit.Test/Repository/Mapping): usuariomaptest `xUnit.Test/Repository/Mapping/UsuarioMapTest.cs` - 997e8cf
- fix(xUnit.Test/Repository/Mapping): receitamaptest `xUnit.Test/Repository/Mapping/ReceitaMapTest.cs` - 70b741c
- fix(xUnit.Test/Repository/Mapping): lancamentomaptest `xUnit.Test/Repository/Mapping/LancamentoMapTest.cs` - e76209d
- fix(xUnit.Test/Repository/Mapping): imagemperfilusuariomaptest `xUnit.Test/Repository/Mapping/ImagemPerfilUsuarioMapTest.cs` - 50f868f
- fix(xUnit.Test/Repository/Mapping): despesamaptest `xUnit.Test/Repository/Mapping/DespesaMapTest.cs` - 24d58c0
- fix(xUnit.Test/Repository/Mapping): categoriamaptest `xUnit.Test/Repository/Mapping/CategoriaMapTest.cs` - 4f73e24
- fix(xUnit.Test/Repository/Mapping): acessomaptest `xUnit.Test/Repository/Mapping/AcessoMapTest.cs` - bef24b5
- fix(xUnit.Test/Infrastructure): amazons3buckettest `xUnit.Test/Infrastructure/AmazonS3BucketTest.cs` - f69ed2f
- fix(xUnit.Test/CommonDependenceInject): automapperinjectdependencetest `xUnit.Test/CommonDependenceInject/AutoMapperInjectDependenceTest.cs` - 1c018e7
- feat(xUnit.Test/Application/Implementations): usuariobusinessimpltest `xUnit.Test/Application/Implementations/UsuarioBusinessImplTest.cs` - 088fa0b
- feat(xUnit.Test/Application/Implementations): receitabusinessimpltest `xUnit.Test/Application/Implementations/ReceitaBusinessImplTest.cs` - d5130d6
- feat(xUnit.Test/Application/Implementations): lancamentobusinessimpltest `xUnit.Test/Application/Implementations/LancamentoBusinessImplTest.cs` - 80dd41a
- feat(xUnit.Test/Application/Implementations): imagemperfilusuariobusinessimpltest `xUnit.Test/Application/Implementations/ImagemPerfilUsuarioBusinessImplTest.cs` - d99a917
- feat(xUnit.Test/Application/Implementations): despesabusinessimpltest `xUnit.Test/Application/Implementations/DespesaBusinessImplTest.cs` - 2352f55
- feat(xUnit.Test/Application/Implementations): categoriabusinessimpltest `xUnit.Test/Application/Implementations/CategoriaBusinessImplTest.cs` - 17dada5
- feat(xUnit.Test/Application/Implementations): acessobusinessimpltest `xUnit.Test/Application/Implementations/AcessoBusinessImplTest.cs` - 94c4146
- feat(xUnit.Test/Application/Generic): genericbusinesstest `xUnit.Test/Application/Generic/GenericBusinessTest.cs` - a4d705f
- fix(xUnit.Test/Application/Dtos): usuariodtotest `xUnit.Test/Application/Dtos/UsuarioDtoTest.cs` - 2868c29
- fix(xUnit.Test/Application/Dtos): receitadtotest `xUnit.Test/Application/Dtos/ReceitaDtoTest.cs` - db80ea2
- test(xUnit.Test/Application/Dtos): lancamentodtotest `xUnit.Test/Application/Dtos/LancamentoDtoTest.cs` - bf8e8ef
- test(xUnit.Test/Application/Dtos): imagemperfilusuariodtotest `xUnit.Test/Application/Dtos/ImagemPerfilUsuarioDtoTest.cs` - b663f59
- fix(xUnit.Test/Application/Dtos): despesadtotest `xUnit.Test/Application/Dtos/DespesaDtoTest.cs` - a681154
- test(xUnit.Test/Application/Dtos): changepassworddtotest `xUnit.Test/Application/Dtos/ChangePasswordDtoTest.cs` - 48dffac
- feat(xUnit.Test/Application/Dtos): categoriadtotest `xUnit.Test/Application/Dtos/CategoriaDtoTest.cs` - fda71db
- test(xUnit.Test/Application/Dtos): acessodtotest `xUnit.Test/Application/Dtos/AcessoDtoTest.cs` - e7e2e25
- fix(xUnit.Test/Application/Authentication): tokenconfigurationtest `xUnit.Test/Application/Authentication/TokenConfigurationTest.cs` - 28a6668
- fix(xUnit.Test/Application/Authentication): signingconfigurationstest `xUnit.Test/Application/Authentication/SigningConfigurationsTest.cs` - c94d26a
- feat(xUnit.Test/Api/Controllers): usuariocontrollertest `xUnit.Test/Api/Controllers/UsuarioControllerTest.cs` - 1c2fabc
- feat(xUnit.Test/Api/Controllers): receitacontrollertest `xUnit.Test/Api/Controllers/ReceitaControllerTest.cs` - 9cbcf4a
- feat(xUnit.Test/Api/Controllers): imagemperfilusuariocontrollertest `xUnit.Test/Api/Controllers/ImagemPerfilUsuarioControllerTest.cs` - 1185683
- feat(xUnit.Test/Api/Controllers): despesacontrollertest `xUnit.Test/Api/Controllers/DespesaControllerTest.cs` - b164f2b
- chore(prj-estacio-despesas-pessoais.Server/wwwroot): .gitkeep `prj-estacio-despesas-pessoais.Server/wwwroot/.gitKeep` - bfa7778
- chore(prj-estacio-despesas-pessoais.Server): prj estacio despesas pessoais.server `prj-estacio-despesas-pessoais.Server/prj-estacio-despesas-pessoais.Server.http` - fb1a8be
- chore(prj-estacio-despesas-pessoais.Server): prj estacio despesas pessoais.server `prj-estacio-despesas-pessoais.Server/prj-estacio-despesas-pessoais.Server.csproj` - 3bfdc7b
- chore(prj-estacio-despesas-pessoais.Server): generate coverage report `prj-estacio-despesas-pessoais.Server/generate_coverage_report.sh` - e80195b
- chore(prj-estacio-despesas-pessoais.Server/certificate): gencert `prj-estacio-despesas-pessoais.Server/certificate/gencert.sh` - 321e675
- chore(prj-estacio-despesas-pessoais.Server): appsettings `prj-estacio-despesas-pessoais.Server/appsettings.json` - 4a2488d
- chore(prj-estacio-despesas-pessoais.Server): appsettings.development `prj-estacio-despesas-pessoais.Server/appsettings.Development.json` - 19c7861
- chore(prj-estacio-despesas-pessoais.Server): webapi `prj-estacio-despesas-pessoais.Server/WebApi.csproj` - 70e0804
- chore(prj-estacio-despesas-pessoais.Server/Properties): launchsettings `prj-estacio-despesas-pessoais.Server/Properties/launchSettings.json` - 927db17
- chore(prj-estacio-despesas-pessoais.Server): program `prj-estacio-despesas-pessoais.Server/Program.cs` - 08c1f79
- chore(prj-estacio-despesas-pessoais.Server/Options): healthcheckoptions `prj-estacio-despesas-pessoais.Server/Options/HealthCheckOptions.cs` - b4e039f
- chore(prj-estacio-despesas-pessoais.Server): extensions `prj-estacio-despesas-pessoais.Server/Extensions.cs` - b52ccbc
- chore(prj-estacio-despesas-pessoais.Server/Controllers): usuariocontroller `prj-estacio-despesas-pessoais.Server/Controllers/UsuarioController.cs` - 9bc5e19
- chore(prj-estacio-despesas-pessoais.Server/Controllers): saldocontroller `prj-estacio-despesas-pessoais.Server/Controllers/SaldoController.cs` - e585f34
- chore(prj-estacio-despesas-pessoais.Server/Controllers): receitacontroller `prj-estacio-despesas-pessoais.Server/Controllers/ReceitaController.cs` - c9de26d
- chore(prj-estacio-despesas-pessoais.Server/Controllers): lancamentocontroller `prj-estacio-despesas-pessoais.Server/Controllers/LancamentoController.cs` - 0918010
- chore(prj-estacio-despesas-pessoais.Server/Controllers): imagemperfilusuariocontroller `prj-estacio-despesas-pessoais.Server/Controllers/ImagemPerfilUsuarioController.cs` - 2e6f677
- chore(prj-estacio-despesas-pessoais.Server/Controllers): graficoscontroller `prj-estacio-despesas-pessoais.Server/Controllers/GraficosController.cs` - 20d64da
- chore(prj-estacio-despesas-pessoais.Server/Controllers): despesacontroller `prj-estacio-despesas-pessoais.Server/Controllers/DespesaController.cs` - 7a7f231
- chore(prj-estacio-despesas-pessoais.Server/Controllers): categoriacontroller `prj-estacio-despesas-pessoais.Server/Controllers/CategoriaController.cs` - 24790de
- chore(prj-estacio-despesas-pessoais.Server/Controllers): authcontroller `prj-estacio-despesas-pessoais.Server/Controllers/AuthController.cs` - 727d2fb
- chore(prj-estacio-despesas-pessoais.Server/Controllers): acessocontroller `prj-estacio-despesas-pessoais.Server/Controllers/AcessoController.cs` - 1466349
- chore(prj-estacio-despesas-pessoais.Server/Controllers/Abstractions): unitcontrollerbase `prj-estacio-despesas-pessoais.Server/Controllers/Abstractions/UnitControllerBase.cs` - f391388
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): swaggerapiversioningdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/Swaggerapiversioningdependenceinject.cs` - fb25ea8
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): supportculturesdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/SupportCulturesDependenceInject.cs` - ed0a4af
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): healthcheckdependencyinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/HealthCheckDependencyInject.cs` - c4b02db
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): autorizationdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/AutorizationDependenceInject.cs` - 616c2c6
- chore(prj-estacio-despesas-pessoais.Server): applicationbuilderextensions `prj-estacio-despesas-pessoais.Server/ApplicationBuilderExtensions.cs` - 9e0521c
- chore(prj-estacio-despesas-pessoais.Server): .editorconfig `prj-estacio-despesas-pessoais.Server/.editorconfig` - d2d44aa
- chore(prj-estacio-despesas-pessoais.AppHost): prj estacio despesas pessoais.apphost `prj-estacio-despesas-pessoais.AppHost/prj-estacio-despesas-pessoais.AppHost.csproj` - 8a29abb
- chore(prj-estacio-despesas-pessoais.AppHost): appsettings `prj-estacio-despesas-pessoais.AppHost/appsettings.json` - 4dab6db
- chore(prj-estacio-despesas-pessoais.AppHost): appsettings.development `prj-estacio-despesas-pessoais.AppHost/appsettings.Development.json` - 0b8409c
- chore(prj-estacio-despesas-pessoais.AppHost/Properties): launchsettings `prj-estacio-despesas-pessoais.AppHost/Properties/launchSettings.json` - fd3e8f2
- chore(prj-estacio-despesas-pessoais.AppHost): apphost `prj-estacio-despesas-pessoais.AppHost/AppHost.cs` - df3dcb0
- refactor(migrations/MySqlServer): migrations.mysqlserver `migrations/MySqlServer/Migrations.MySqlServer.csproj` - 9b23dc6
- chore(frontend): proxy   copy.conf `frontend/proxy - Copy.conf.cjs` - 896e745
- fix(raiz): aspire.config `aspire.config.json` - 570b5db
- refactor(raiz): .gitmodules `.gitmodules` - 3dd54d3
- fix(raiz): .gitignore `.gitignore` - 06b5c20
- fix(raiz): .gitattributes `.gitattributes` - ab24373
- fix(.docker): dockerfile `.docker/Dockerfile.api` - 13740b9
- chore(.devcontainer/scripts): start ssh `.devcontainer/scripts/start-ssh.sh` - 5355ed7
- chore(.devcontainer/scripts): setup ssh `.devcontainer/scripts/setup-ssh.sh` - 26f416b
- refactor(.devcontainer/scripts): setup codex `.devcontainer/scripts/setup-codex.sh` - 4715a92
- test(.devcontainer): docker compose `.devcontainer/docker-compose.yml` - 55874b3
- fix(.devcontainer): devcontainer `.devcontainer/devcontainer.json` - 8fde2e8
- fix(.devcontainer): aspire.config `.devcontainer/aspire.config.json` - 1c7082e
- fix(.devcontainer): dockerfile `.devcontainer/Dockerfile, prj-estacio-despesas-pessoais.slnx` - c589ec6

A PR permanece aberta para revisão e não foi mesclada.
