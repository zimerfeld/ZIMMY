---
tags: [meta, zimmy-pet]
atualizado: 2026-06-20
---

# 🧠 _Memória do Claude

Este cofre Obsidian é a **memória técnica** do projeto Zimmy Pet, criada e mantida
pelo Claude. Fica em `C:\GODOT\ZIMMY\OBSIDIAN\CLAUDE`.

## Convenções
- **Uma ideia por nota**, com frontmatter (`tags`, `atualizado`).
- Notas começam com prefixo de categoria: `Sistema - …`, `Fluxo - …`,
  `Entrada - …`, `Arquivo - …`.
- **Linkar liberalmente** com `[[wikilinks]]`. O hub é [[Home]].
- Referências a código usam `arquivo:linha` (ex.: `zimmy.gd:546`) — as linhas podem
  mudar; confirme antes de confiar.
- Tudo é em **português** (preferência do autor, Renato Zimerfeld).

## O que mora aqui
- **Sistemas**: subsistemas lógicos do app (o quê e por quê).
- **Fluxos**: sequências de execução (`_ready`, `_process`, salvar/carregar…).
- **Pontos de Entrada (endpoints)**: a superfície de interação do app — como este é
  um overlay de desktop (não um servidor web), os "endpoints" são os **eventos de
  input**, os **itens de menu** e as **funções de ação** públicas.
- **Arquivos-Chave**: uma nota por arquivo importante do repo.
- **Referências**: repositório, build/export, glossário.

## Manutenção
Ao mudar comportamento do app, atualizar a nota de sistema/fluxo afetada **e** o
[[Arquivo - README]] correspondente (o README é a fonte da verdade; o cofre o
espelha). Converter datas relativas em absolutas.

> Origem: cofre solicitado em 2026-06-20, populado a partir do estado atual de
> [[zimmy.gd]] (branch `feature/aleatorios`).
