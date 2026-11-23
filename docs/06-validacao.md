---
name: validacao
description: Comandos executados e resultados da validação da solução refatorada.
---

# Validação

## Executado

- `dotnet build`: sucesso; 0 erros.
- O `AppHost` foi ajustado para referenciar `Projects.AppServer` após a reorganização do antigo projeto `Server`.
- O bundle obrigatório do Aspire foi desativado no build local porque o `aspire setup` não concluiu no ambiente atual.

## Pendências

- O build ainda reporta avisos de segurança e compatibilidade em dependências herdadas, incluindo Aspire 13.6.4, Pomelo EF Core 9 com EF Core 10, MySqlConnector e `System.Security.Cryptography.Pkcs`.
- `aspire run` requer que o bundle seja instalado com sucesso; o executável da CLI está disponível, mas a extração do bundle excedeu o tempo disponível no ambiente.
- A execução integrada depende de configuração externa de banco, S3, JWT e certificados. Nenhum segredo foi copiado para esta pasta.
