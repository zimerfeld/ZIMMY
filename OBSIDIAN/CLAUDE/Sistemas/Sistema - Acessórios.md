---
tags: [sistema, acessorios, zimmy-pet]
atualizado: 2026-06-20
---

# 🎀 Sistema - Acessórios

Camada **independente do pet**, desenhada por cima. Salvar/carregar é separado dos
pets (um pet salvo não leva acessório e vice-versa), então dá para combinar qualquer
pet com qualquer acessório.

## Tipos (esquema em [[Glossário de Configs]])
- `hat`: none | beanie | tophat | crown | cap
- `glasses`: none | round | square | star
- `bow`: none | head | neck
- `scarf`: none | present
- + cores `hat_color/glasses_color/bow_color/scarf_color` (`ACC_COLOR_KEYS`).

## Funções
- `_default_acc()` (`zimmy.gd:177`) — tudo `none` (o Default não veste nada).
- `_random_acc()` (`zimmy.gd:186`) — sorteia tipos e cores.
- Desenho: `_draw_accessories()` (`zimmy.gd:707`) — ordem: cachecol (atrás) →
  chapéu → óculos (alinhados aos olhos) → laço. Ver [[Sistema - Render (_draw)]].

## Controles (3 independentes) — [[Sistema - Menu de Contexto]]
- **🎲 Gerar acessórios** (`MI_RANDOM_ACC`) — geração contínua própria
  ([[Fluxo - Geração Aleatória]]); ligar também liga a exibição.
- **👓 Mostrar acessórios** (`MI_SHOW_ACC`, `show_accessories`, default **on**) —
  só controla o desenho (`if show_accessories` no `_draw`).
- **🎀 Salvar Acessório** / **🧳 Escolher acessório** — salvar/carregar
  independentes. Dropdown com `Selecione...` (rótulo) e `Nenhum` (limpa).

## Estado
`current_acc`, `saved_accessories[nome]`, `acc_menu_ids`.
Persistência em `user://accessories.json` — [[Sistema - Persistência]].
