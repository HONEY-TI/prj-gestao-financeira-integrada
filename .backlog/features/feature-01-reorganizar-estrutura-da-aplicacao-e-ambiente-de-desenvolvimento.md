---
name: feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento
file: feature-01-reorganizar-estrutura-da-aplicacao-e-ambiente-de-desenvolvimento.md
description: >
  Reorganização da estrutura da aplicação e do ambiente de desenvolvimento,
  incluindo a consolidação dos projetos atuais e a atualização dos testes.
---

## Contexto / Problema

O repositório mantém projetos com nomes e configurações antigas, além de scripts
de ambiente que não acompanham a estrutura atual da solução.

## Objetivo

Reorganizar a solução para os projetos `AppHost` e `Server`, atualizar o ambiente
de desenvolvimento e alinhar os testes e configurações à nova estrutura.

## Critérios de aceite

> Rascunho: revisar e completar durante a revisão da PR.

- [ ] A solução referencia a estrutura reorganizada sem dependências dos projetos antigos.
- [ ] O ambiente de desenvolvimento pode ser inicializado com os scripts atualizados.
- [ ] Os testes e configurações compilam e apontam para os projetos atuais.
