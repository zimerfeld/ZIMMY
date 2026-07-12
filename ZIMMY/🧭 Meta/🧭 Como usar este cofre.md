---
tipo: meta
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [meta, zimmy-pet]
---

# 🧭 Como usar este cofre

> 🇺🇸 Read this page in English → [[🧭 Como usar este cofre (EN)]]
> 🇪🇸 Lee esta página en español → [[🧭 Como usar este cofre (ES)]]

> Para **retomar o trabalho**, veja [[📌 Backlog]] (prioridades P0/P1/P2).

Este cofre Obsidian é a **memória técnica** do projeto Zimmy Pet, criada e mantida
pelo Claude. Fica em `C:\GODOT\ZIMMY\ZIMMY`.

## 📐 Convenções
- **Uma ideia por nota**, com frontmatter padrão (`tipo`, `projeto`, `lang`, `atualizado`, `tags`).
- Notas começam com **emoji + prefixo de categoria**: `🐾 Sistema - …`,
  `🎲 Fluxo - …`, `🚪 Entrada - …`, `📄 Arquivo - …`.
- **Ícones (emoji) por toda parte:** cada nota leva o mesmo emoji temático em **três
  lugares** — no **nome do arquivo** (aparece na árvore), no **título `#`** e em **cada
  subtítulo `##`** (este último escolhido pelo conteúdo da seção). As **pastas** também
  têm emoji-prefixo; a ordem no painel é definida pelo `sortspec.md` na raiz (plugin
  **custom-sort**), por **prioridade**: `🔑 Arquivos-Chave` (impacto) → `🧩 Sistemas`
  (reutilização) → `🔀 Fluxos` (uso) → `🚀 Operação` → `🚪 Pontos de Entrada` →
  `📚 Conhecimento` → `💼 Negócio` → `🧭 Meta`.
- **Par bilíngue:** cada nota PT `<emoji> Nome.md` tem um par `<emoji> Nome (EN).md`
  (tradução completa em inglês-US). Notas PT linkam nomes PT; notas EN linkam os pares `(EN)`.
- **Linkar liberalmente** com `[[wikilinks]]`. O hub é [[🏠 Home]]. Os `[[links]]` usam
  o **nome-base** (com o emoji); mover a nota entre pastas não quebra o link, mas
  **renomear o arquivo sim** — ao renomear, atualize os wikilinks juntos (PT e EN).
- Referências a código usam `arquivo:linha` (ex.: `zimmy.gd:546`) — as linhas podem
  mudar; confirme antes de confiar.
- Idioma-base do cofre em **português** (preferência do autor, Renato Zimerfeld), com
  espelho integral em inglês nos pares `(EN)`.

## 🏠 O que mora aqui
- **🔑 Arquivos-Chave**: uma nota por arquivo importante do repo (grande impacto se manipulado).
- **🧩 Sistemas**: subsistemas lógicos do app (o quê e por quê), reutilizados por várias partes.
- **🔀 Fluxos**: sequências de execução (`_ready`, `_process`, salvar/carregar…).
- **🚀 Operação**: runbooks — rodar no editor (Dev) e exportar/publicar o `.exe` (Prod).
- **🚪 Pontos de Entrada**: a superfície de interação do app — como este é
  um overlay de desktop (não um servidor web), os "endpoints" são os **eventos de
  input**, os **itens de menu** e as **funções de ação** públicas.
- **📚 Conhecimento**: repositório/branches e glossário de configs.
- **💼 Negócio**: adoção/métricas, divulgação, distribuição, itch.io, financiamento.
- **🧭 Meta**: esta nota (como usar o cofre).

## 🧹 Manutenção
Ao mudar comportamento do app, atualizar a nota de sistema/fluxo afetada **e** o
[[📄 Arquivo - README]] correspondente (o README é a fonte da verdade; o cofre o
espelha). Converter datas relativas em absolutas. Manter o par `(EN)` sincronizado.

> Origem: cofre solicitado em 2026-06-20, populado a partir do estado atual de
> [[📄 zimmy.gd]] (branch `feature/aleatorios`). Reestruturado para o padrão
> "Cofre de Neurônios v2" em 2026-07-04.
