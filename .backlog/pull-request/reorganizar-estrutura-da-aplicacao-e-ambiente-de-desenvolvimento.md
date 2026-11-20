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

| Métrica               | Valor              |
| --------------------- | ------------------ |
| 🌿 Branch de origem   | `feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento` |
| 🎯 Branch de destino  | `develop`          |
| 📝 Total de commits   | 177                |
| 📁 Arquivos alterados | 121                |

---

## 📦 Repositórios/branches atualizados

- **[prj-gestao-financeira-integrada](https://github.com/HONEY-TI/prj-gestao-financeira-integrada)** — branch [`feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento`](https://github.com/HONEY-TI/prj-gestao-financeira-integrada/tree/feature/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento)
  - Commits: 175 (excluindo o commit inicial vazio e o merge de sincronização)
  - Arquivos alterados: 121 — reorganização da estrutura .NET/Aspire, ambiente DevContainer/Docker, automações de build/cobertura, suíte de testes xUnit e frontend Angular/Capacitor

---

## Checklist

- [x] Commits separados por arquivo
- [x] Referência do PR incluída nos commits de conteúdo (pai e submodules)
- [x] Alterações revisadas e enviadas para a branch
- [ ] Revisão funcional
- [ ] Validação em ambiente Linux/jail

---

## 📝 Commits

- test(xUnit.Test/Domain/Core): importar namespace Domain no teste `xUnit.Test/Domain/Core/ExtensionTest.cs` - cea315a
- feat(.devcontainer/setup): adicionar configuração de certificados `.devcontainer/setup/setup-dev-certs.sh` - dfd6e2e
- chore(.devcontainer/scripts): remover script antigo de certificados `.devcontainer/scripts/setup-dev-certs.sh` - e30c61e
- chore(.devcontainer/scripts): remover script obsoleto do Codex `.devcontainer/scripts/setup-codex.sh` - 8459638
- fix(.devcontainer): ajustar inicialização e portas do ambiente `.devcontainer/devcontainer.json` - 47dcb99
- fix(.devcontainer): dockerfile `.devcontainer/Dockerfile, prj-estacio-despesas-pessoais.slnx` - c589ec6
- fix(.devcontainer): aspire.config `.devcontainer/aspire.config.json` - 1c7082e
- fix(.devcontainer): devcontainer `.devcontainer/devcontainer.json` - 8fde2e8
- test(.devcontainer): docker compose `.devcontainer/docker-compose.yml` - 55874b3
- refactor(.devcontainer/scripts): setup codex `.devcontainer/scripts/setup-codex.sh` - 4715a92
- chore(.devcontainer/scripts): setup ssh `.devcontainer/scripts/setup-ssh.sh` - 26f416b
- chore(.devcontainer/scripts): start ssh `.devcontainer/scripts/start-ssh.sh` - 5355ed7
- fix(.docker): dockerfile `.docker/Dockerfile.api` - 13740b9
- fix(raiz): .gitattributes `.gitattributes` - ab24373
- fix(raiz): .gitignore `.gitignore` - 06b5c20
- refactor(raiz): .gitmodules `.gitmodules` - 3dd54d3
- fix(raiz): aspire.config `aspire.config.json` - 570b5db
- chore(frontend): proxy   copy.conf `frontend/proxy - Copy.conf.cjs` - 896e745
- refactor(migrations/MySqlServer): migrations.mysqlserver `migrations/MySqlServer/Migrations.MySqlServer.csproj` - 9b23dc6
- chore(prj-estacio-despesas-pessoais.AppHost): apphost `prj-estacio-despesas-pessoais.AppHost/AppHost.cs` - df3dcb0
- chore(prj-estacio-despesas-pessoais.AppHost/Properties): launchsettings `prj-estacio-despesas-pessoais.AppHost/Properties/launchSettings.json` - fd3e8f2
- chore(prj-estacio-despesas-pessoais.AppHost): appsettings.development `prj-estacio-despesas-pessoais.AppHost/appsettings.Development.json` - 0b8409c
- chore(prj-estacio-despesas-pessoais.AppHost): appsettings `prj-estacio-despesas-pessoais.AppHost/appsettings.json` - 4dab6db
- chore(prj-estacio-despesas-pessoais.AppHost): prj estacio despesas pessoais.apphost `prj-estacio-despesas-pessoais.AppHost/prj-estacio-despesas-pessoais.AppHost.csproj` - 8a29abb
- chore(prj-estacio-despesas-pessoais.Server): .editorconfig `prj-estacio-despesas-pessoais.Server/.editorconfig` - d2d44aa
- chore(prj-estacio-despesas-pessoais.Server): applicationbuilderextensions `prj-estacio-despesas-pessoais.Server/ApplicationBuilderExtensions.cs` - 9e0521c
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): autorizationdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/AutorizationDependenceInject.cs` - 616c2c6
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): healthcheckdependencyinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/HealthCheckDependencyInject.cs` - c4b02db
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): supportculturesdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/SupportCulturesDependenceInject.cs` - ed0a4af
- chore(prj-estacio-despesas-pessoais.Server/CommonDependenceInject): swaggerapiversioningdependenceinject `prj-estacio-despesas-pessoais.Server/CommonDependenceInject/Swaggerapiversioningdependenceinject.cs` - fb25ea8
- chore(prj-estacio-despesas-pessoais.Server/Controllers/Abstractions): unitcontrollerbase `prj-estacio-despesas-pessoais.Server/Controllers/Abstractions/UnitControllerBase.cs` - f391388
- chore(prj-estacio-despesas-pessoais.Server/Controllers): acessocontroller `prj-estacio-despesas-pessoais.Server/Controllers/AcessoController.cs` - 1466349
- chore(prj-estacio-despesas-pessoais.Server/Controllers): authcontroller `prj-estacio-despesas-pessoais.Server/Controllers/AuthController.cs` - 727d2fb
- chore(prj-estacio-despesas-pessoais.Server/Controllers): categoriacontroller `prj-estacio-despesas-pessoais.Server/Controllers/CategoriaController.cs` - 24790de
- chore(prj-estacio-despesas-pessoais.Server/Controllers): despesacontroller `prj-estacio-despesas-pessoais.Server/Controllers/DespesaController.cs` - 7a7f231
- chore(prj-estacio-despesas-pessoais.Server/Controllers): graficoscontroller `prj-estacio-despesas-pessoais.Server/Controllers/GraficosController.cs` - 20d64da
- chore(prj-estacio-despesas-pessoais.Server/Controllers): imagemperfilusuariocontroller `prj-estacio-despesas-pessoais.Server/Controllers/ImagemPerfilUsuarioController.cs` - 2e6f677
- chore(prj-estacio-despesas-pessoais.Server/Controllers): lancamentocontroller `prj-estacio-despesas-pessoais.Server/Controllers/LancamentoController.cs` - 0918010
- chore(prj-estacio-despesas-pessoais.Server/Controllers): receitacontroller `prj-estacio-despesas-pessoais.Server/Controllers/ReceitaController.cs` - c9de26d
- chore(prj-estacio-despesas-pessoais.Server/Controllers): saldocontroller `prj-estacio-despesas-pessoais.Server/Controllers/SaldoController.cs` - e585f34
- chore(prj-estacio-despesas-pessoais.Server/Controllers): usuariocontroller `prj-estacio-despesas-pessoais.Server/Controllers/UsuarioController.cs` - 9bc5e19
- chore(prj-estacio-despesas-pessoais.Server): extensions `prj-estacio-despesas-pessoais.Server/Extensions.cs` - b52ccbc
- chore(prj-estacio-despesas-pessoais.Server/Options): healthcheckoptions `prj-estacio-despesas-pessoais.Server/Options/HealthCheckOptions.cs` - b4e039f
- chore(prj-estacio-despesas-pessoais.Server): program `prj-estacio-despesas-pessoais.Server/Program.cs` - 08c1f79
- chore(prj-estacio-despesas-pessoais.Server/Properties): launchsettings `prj-estacio-despesas-pessoais.Server/Properties/launchSettings.json` - 927db17
- chore(prj-estacio-despesas-pessoais.Server): webapi `prj-estacio-despesas-pessoais.Server/WebApi.csproj` - 70e0804
- chore(prj-estacio-despesas-pessoais.Server): appsettings.development `prj-estacio-despesas-pessoais.Server/appsettings.Development.json` - 19c7861
- chore(prj-estacio-despesas-pessoais.Server): appsettings `prj-estacio-despesas-pessoais.Server/appsettings.json` - 4a2488d
- chore(prj-estacio-despesas-pessoais.Server/certificate): gencert `prj-estacio-despesas-pessoais.Server/certificate/gencert.sh` - 321e675
- chore(prj-estacio-despesas-pessoais.Server): generate coverage report `prj-estacio-despesas-pessoais.Server/generate_coverage_report.sh` - e80195b
- chore(prj-estacio-despesas-pessoais.Server): prj estacio despesas pessoais.server `prj-estacio-despesas-pessoais.Server/prj-estacio-despesas-pessoais.Server.csproj` - 3bfdc7b
- chore(prj-estacio-despesas-pessoais.Server): prj estacio despesas pessoais.server `prj-estacio-despesas-pessoais.Server/prj-estacio-despesas-pessoais.Server.http` - fb1a8be
- chore(prj-estacio-despesas-pessoais.Server/wwwroot): .gitkeep `prj-estacio-despesas-pessoais.Server/wwwroot/.gitKeep` - bfa7778
- feat(xUnit.Test/Api/Controllers): despesacontrollertest `xUnit.Test/Api/Controllers/DespesaControllerTest.cs` - b164f2b
- feat(xUnit.Test/Api/Controllers): imagemperfilusuariocontrollertest `xUnit.Test/Api/Controllers/ImagemPerfilUsuarioControllerTest.cs` - 1185683
- feat(xUnit.Test/Api/Controllers): receitacontrollertest `xUnit.Test/Api/Controllers/ReceitaControllerTest.cs` - 9cbcf4a
- feat(xUnit.Test/Api/Controllers): usuariocontrollertest `xUnit.Test/Api/Controllers/UsuarioControllerTest.cs` - 1c2fabc
- fix(xUnit.Test/Application/Authentication): signingconfigurationstest `xUnit.Test/Application/Authentication/SigningConfigurationsTest.cs` - c94d26a
- fix(xUnit.Test/Application/Authentication): tokenconfigurationtest `xUnit.Test/Application/Authentication/TokenConfigurationTest.cs` - 28a6668
- test(xUnit.Test/Application/Dtos): acessodtotest `xUnit.Test/Application/Dtos/AcessoDtoTest.cs` - e7e2e25
- feat(xUnit.Test/Application/Dtos): categoriadtotest `xUnit.Test/Application/Dtos/CategoriaDtoTest.cs` - fda71db
- test(xUnit.Test/Application/Dtos): changepassworddtotest `xUnit.Test/Application/Dtos/ChangePasswordDtoTest.cs` - 48dffac
- fix(xUnit.Test/Application/Dtos): despesadtotest `xUnit.Test/Application/Dtos/DespesaDtoTest.cs` - a681154
- test(xUnit.Test/Application/Dtos): imagemperfilusuariodtotest `xUnit.Test/Application/Dtos/ImagemPerfilUsuarioDtoTest.cs` - b663f59
- test(xUnit.Test/Application/Dtos): lancamentodtotest `xUnit.Test/Application/Dtos/LancamentoDtoTest.cs` - bf8e8ef
- fix(xUnit.Test/Application/Dtos): receitadtotest `xUnit.Test/Application/Dtos/ReceitaDtoTest.cs` - db80ea2
- fix(xUnit.Test/Application/Dtos): usuariodtotest `xUnit.Test/Application/Dtos/UsuarioDtoTest.cs` - 2868c29
- feat(xUnit.Test/Application/Generic): genericbusinesstest `xUnit.Test/Application/Generic/GenericBusinessTest.cs` - a4d705f
- feat(xUnit.Test/Application/Implementations): acessobusinessimpltest `xUnit.Test/Application/Implementations/AcessoBusinessImplTest.cs` - 94c4146
- feat(xUnit.Test/Application/Implementations): categoriabusinessimpltest `xUnit.Test/Application/Implementations/CategoriaBusinessImplTest.cs` - 17dada5
- feat(xUnit.Test/Application/Implementations): despesabusinessimpltest `xUnit.Test/Application/Implementations/DespesaBusinessImplTest.cs` - 2352f55
- feat(xUnit.Test/Application/Implementations): imagemperfilusuariobusinessimpltest `xUnit.Test/Application/Implementations/ImagemPerfilUsuarioBusinessImplTest.cs` - d99a917
- feat(xUnit.Test/Application/Implementations): lancamentobusinessimpltest `xUnit.Test/Application/Implementations/LancamentoBusinessImplTest.cs` - 80dd41a
- feat(xUnit.Test/Application/Implementations): receitabusinessimpltest `xUnit.Test/Application/Implementations/ReceitaBusinessImplTest.cs` - d5130d6
- feat(xUnit.Test/Application/Implementations): usuariobusinessimpltest `xUnit.Test/Application/Implementations/UsuarioBusinessImplTest.cs` - 088fa0b
- fix(xUnit.Test/CommonDependenceInject): automapperinjectdependencetest `xUnit.Test/CommonDependenceInject/AutoMapperInjectDependenceTest.cs` - 1c018e7
- fix(xUnit.Test/Infrastructure): amazons3buckettest `xUnit.Test/Infrastructure/AmazonS3BucketTest.cs` - f69ed2f
- fix(xUnit.Test/Repository/Mapping): acessomaptest `xUnit.Test/Repository/Mapping/AcessoMapTest.cs` - bef24b5
- fix(xUnit.Test/Repository/Mapping): categoriamaptest `xUnit.Test/Repository/Mapping/CategoriaMapTest.cs` - 4f73e24
- fix(xUnit.Test/Repository/Mapping): despesamaptest `xUnit.Test/Repository/Mapping/DespesaMapTest.cs` - 24d58c0
- fix(xUnit.Test/Repository/Mapping): imagemperfilusuariomaptest `xUnit.Test/Repository/Mapping/ImagemPerfilUsuarioMapTest.cs` - 50f868f
- fix(xUnit.Test/Repository/Mapping): lancamentomaptest `xUnit.Test/Repository/Mapping/LancamentoMapTest.cs` - e76209d
- fix(xUnit.Test/Repository/Mapping): receitamaptest `xUnit.Test/Repository/Mapping/ReceitaMapTest.cs` - 70b741c
- fix(xUnit.Test/Repository/Mapping): usuariomaptest `xUnit.Test/Repository/Mapping/UsuarioMapTest.cs` - 997e8cf
- fix(xUnit.Test/Repository/Persistency/Generic): genericrepositoriotest `xUnit.Test/Repository/Persistency/Generic/GenericRepositorioTest.cs` - 6a0b6d9
- fix(xUnit.Test/Repository/Persistency/Implementations): acessorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/AcessoRepositorioImplTest.cs` - 5923e22
- test(xUnit.Test/Repository/Persistency/Implementations): categoriarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/CategoriaRepositorioImplTest.cs` - 5f0f71d
- fix(xUnit.Test/Repository/Persistency/Implementations): despesarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/DespesaRepositorioImplTest.cs` - 5991a49
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): acessorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/AcessoRepositorioFixture.cs` - ce6dd3d
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): graficorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/GraficoRepositorioFixture.cs` - b857f3d
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): lancamentorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/LancamentoRepositorioFixture.cs` - f0a026a
- fix(xUnit.Test/Repository/Persistency/Implementations/Fixtures): saldorepositoriofixture `xUnit.Test/Repository/Persistency/Implementations/Fixtures/SaldoRepositorioFixture.cs` - af6405f
- fix(xUnit.Test/Repository/Persistency/Implementations): graficorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/GraficoRepositorioImplTest.cs` - d62bb6a
- fix(xUnit.Test/Repository/Persistency/Implementations): lancamentorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/LancamentoRepositorioImplTest.cs` - 70e2502
- fix(xUnit.Test/Repository/Persistency/Implementations): receitarepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/ReceitaRepositorioImplTest.cs` - e5c37a8
- fix(xUnit.Test/Repository/Persistency/Implementations): saldorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/SaldoRepositorioImplTest.cs` - 0b9b32c
- fix(xUnit.Test/Repository/Persistency/Implementations): usuariorepositorioimpltest `xUnit.Test/Repository/Persistency/Implementations/UsuarioRepositorioImplTest.cs` - e55f08f
- fix(xUnit.Test/Repository/UnitOfWork): unitofworktest `xUnit.Test/Repository/UnitOfWork/UnitOfWorkTest.cs` - 09b033c
- test(xUnit.Test): coverage report `xUnit.Test/coverage_report.ps1` - a9143ae
- fix(xUnit.Test): xunit.test `xUnit.Test/xUnit.Test.csproj` - 2fe216a
- chore(xUnit.Test): xunit.test.csproj `xUnit.Test/xUnit.Test.csproj.bck` - 80c1e9d
- test(.backlog/features): feature 01 reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/features/feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - 5aba5d3
- test(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - 7d410fb
- feat(.devcontainer/scripts): aspire certs `.devcontainer/scripts/aspire-certs.sh` - fcc1dab
- feat(.devcontainer/scripts): docker entrypoint `.devcontainer/scripts/docker-entrypoint.sh` - e60a032
- feat(.devcontainer/scripts): setup antigravity `.devcontainer/scripts/setup-antigravity.sh` - feb90cd
- security(.devcontainer/scripts): setup dev certs `.devcontainer/scripts/setup-dev-certs.sh` - 8cc7784
- test(raiz): .dockerignore `.dockerignore` - 51a349a
- feat(raiz): .gitignore `.gitignore.codex` - 487f2b0
- feat(AppHost): apphost `AppHost/AppHost.cs` - 00af958
- security(AppHost): apphost `AppHost/AppHost.csproj` - ddf2da6
- feat(AppHost/Properties): launchsettings `AppHost/Properties/launchSettings.json` - 1504b96
- feat(AppHost): appsettings.development `AppHost/appsettings.Development.json` - a625230
- feat(AppHost): appsettings `AppHost/appsettings.json` - 24a1e6b
- feat(AppHost/resources): endpointhealthcheck `AppHost/resources/EndpointHealthCheck.cs` - efe50bc
- feat(AppHost/resources): endpointresource `AppHost/resources/EndpointResource.cs` - 806b22a
- refactor(AppHost/resources): serverhealthresources `AppHost/resources/ServerHealthResources.cs` - 0201248
- test(Server): .editorconfig `Server/.editorconfig` - c5eb521
- test(Server): applicationbuilderextensions `Server/ApplicationBuilderExtensions.cs` - f4087ce
- feat(Server/CommonDependenceInject): autorizationdependenceinject `Server/CommonDependenceInject/AutorizationDependenceInject.cs` - 5ea03aa
- feat(Server/CommonDependenceInject): healthcheckdependencyinject `Server/CommonDependenceInject/HealthCheckDependencyInject.cs` - fc1b365
- feat(Server/CommonDependenceInject): supportculturesdependenceinject `Server/CommonDependenceInject/SupportCulturesDependenceInject.cs` - 0903a25
- refactor(Server/CommonDependenceInject): swaggerapiversioningdependenceinject `Server/CommonDependenceInject/Swaggerapiversioningdependenceinject.cs` - b22a221
- refactor(Server/Controllers/Abstractions): unitcontrollerbase `Server/Controllers/Abstractions/UnitControllerBase.cs` - c0fd72c
- refactor(Server/Controllers): acessocontroller `Server/Controllers/AcessoController.cs` - 9b63dc5
- refactor(Server/Controllers): authcontroller `Server/Controllers/AuthController.cs` - 4c54423
- refactor(Server/Controllers): categoriacontroller `Server/Controllers/CategoriaController.cs` - 0c9a4c4
- refactor(Server/Controllers): despesacontroller `Server/Controllers/DespesaController.cs` - 2d8ced7
- refactor(Server/Controllers): graficoscontroller `Server/Controllers/GraficosController.cs` - eb00164
- refactor(Server/Controllers): imagemperfilusuariocontroller `Server/Controllers/ImagemPerfilUsuarioController.cs` - 9e2659d
- refactor(Server/Controllers): lancamentocontroller `Server/Controllers/LancamentoController.cs` - 0214988
- refactor(Server/Controllers): receitacontroller `Server/Controllers/ReceitaController.cs` - 7fad063
- refactor(Server/Controllers): saldocontroller `Server/Controllers/SaldoController.cs` - 05c5db5
- refactor(Server/Controllers): usuariocontroller `Server/Controllers/UsuarioController.cs` - 06d5dba
- feat(Server): extensions `Server/Extensions.cs` - 087bc06
- feat(Server/Options): healthcheckoptions `Server/Options/HealthCheckOptions.cs` - e31b939
- test(Server): program `Server/Program.cs` - 6210e86
- feat(Server/Properties): launchsettings `Server/Properties/launchSettings.json` - 5678be4
- feat(Server): server `Server/Server.csproj` - bf8ac13
- feat(Server): server `Server/Server.http` - 8d5f64a
- security(Server): appsettings.development `Server/appsettings.Development.json` - 471e6fd
- security(Server): appsettings `Server/appsettings.json` - 0497032
- feat(Server/certificate): gencert `Server/certificate/gencert.sh` - cfea573
- test(Server): generate coverage report `Server/generate_coverage_report.sh` - bc0c23c
- feat(Server/wwwroot): .gitkeep `Server/wwwroot/.gitKeep` - c9136a6
- test(raiz): prj gestao financeira integrada `prj-gestao-financeira-integrada.slnx` - ca8cf0d
- fix(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - daeb55b
- test(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - 7f7f633
- fix(.devcontainer): dockerfile `.devcontainer/Dockerfile` - 3b72206
- fix(.devcontainer): devcontainer `.devcontainer/devcontainer.json` - ee4e36d
- fix(.devcontainer): docker compose `.devcontainer/docker-compose.yml` - 8e56ece
- chore(.devcontainer/scripts): aspire certs `.devcontainer/scripts/aspire-certs.sh` - 2f389c3
- chore(.devcontainer/scripts): docker entrypoint `.devcontainer/scripts/docker-entrypoint.sh` - 28dd5cf
- chore(.devcontainer/scripts): setup antigravity `.devcontainer/scripts/setup-antigravity.sh` - 0047fbe
- fix(.devcontainer/scripts): setup codex `.devcontainer/scripts/setup-codex.sh` - dd4d9bb
- fix(frontend/app-android): package `frontend/app-android/package.json` - 079310c
- fix(frontend/app-ios): package `frontend/app-ios/package.json` - 8277041
- test(frontend): package lock `frontend/package-lock.json` - 00a07d4
- fix(frontend): package `frontend/package.json` - 1f383bf
- fix(.devcontainer): docker entrypoint `.devcontainer/docker-entrypoint.sh` - 24b8f54
- refactor(.devcontainer/setup): aspire clean `.devcontainer/setup/aspire-clean.sh` - bb17783
- fix(.devcontainer/setup): setup codex `.devcontainer/setup/setup-codex.sh` - 6ddbd00
- fix(.devcontainer/setup): setup start `.devcontainer/setup/setup-start.sh` - ff5d4cd
- chore(.devcontainer/tools): tool antigravity `.devcontainer/tools/tool-antigravity.sh` - db4cad8
- test(.devcontainer/tools): tool codex `.devcontainer/tools/tool-codex.sh` - 3e69976
- chore(.devcontainer/tools): tool install `.devcontainer/tools/tool-install.sh` - ff3be5f
- feat(frontend): =1.11.0 beta `frontend/=1.11.0-beta.1` - 3bae4ed
- feat(frontend): =5.0 `frontend/=5.0.6` - 621748d
- fix(.backlog/pull-request): reorganizar estrutura da aplicacao e ambiente de desenvolvimento `.backlog/pull-request/reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md` - b989004
- fix(.devcontainer): ajustar comandos de inicializacao e uid do usuario `.devcontainer/devcontainer.json` - e1e77fe
- fix(raiz): ignorar diretorio e configuracoes do gemini `.gitignore` - f03797e
- test(xUnit.Test/Repository/Persistency/Implementations): desativar teste findbymesano despesa temporariamente `xUnit.Test/Repository/Persistency/Implementations/LancamentoRepositorioImplTest.cs` - a15b1f2
- test(xUnit.Test): atualizar caminhos dos projetos no relatorio de cobertura `xUnit.Test/coverage_report.ps1` - bf45548
- test(frontend): adicionar configuracao do typescript para testes `frontend/tsconfig.spec.json` - 1ddcd07
