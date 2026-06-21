---
tags: [sistema, acessorios, zimmy-pet]
atualizado: 2026-06-21
---

# 🎀 Sistema - Acessórios

Camada **independente do pet**, desenhada por cima. Salvar/carregar é separado dos
pets (um pet salvo não leva acessório e vice-versa), então dá para combinar qualquer
pet com qualquer acessório.

## Tipos (esquema em [[Glossário de Configs]])
Originais:
- `hat`: none | beanie | tophat | crown | cap
- `glasses`: none | round | square | star
- `bow`: none | head | neck
- `scarf`: none | present

Categorias extras (≈12, sorteadas **de forma independente**, cada uma com cor própria):
- `necklace` (pearls/pendant), `earrings` (studs/hoops), `collar` (plain/bell),
  `headphones` (present), `monocle` (present), `mustache` (curly/thin),
  `flower` (present), `badge` (star/heart), `tie` (necktie/bowtie), `sash` (present),
  `mask` (medical/ninja), `cheek_sticker` (star/heart).
- Cores em `ACC_COLOR_KEYS`: as 4 originais + `necklace_color`, `earring_color`,
  `collar_color`, `headphone_color`, `monocle_color`, `mustache_color`, `flower_color`,
  `badge_color`, `tie_color`, `sash_color`, `mask_color`, `sticker_color`.

## Funções
- `_default_acc()` — tudo `none` (o Default não veste nada).
- `_random_acc()` — sorteia tipos e cores (com `none` de peso maior nas extras).
- Desenho: `_draw_accessories()` — originais (cachecol atrás → chapéu → óculos → laço)
  e então as extras, cada uma com seu helper `_draw_*` (sash, collar, necklace, tie,
  badge, headphones, flower, earrings, monocle, mustache, mask, cheek_sticker).
  Ver [[Sistema - Render (_draw)]].

## Controles (3 independentes) — [[Sistema - Menu de Contexto]]
- **🎲 Gerar acessórios** (`MI_RANDOM_ACC`) — geração contínua própria
  ([[Fluxo - Geração Aleatória]]); ligar também liga a exibição.
- **👓 Mostrar acessórios** (`MI_SHOW_ACC`, `show_accessories`, default **on**) —
  só controla o desenho (`if show_accessories` no `_draw`).
- **🎀 Salvar Acessório** / **🧳 Escolher acessório** — salvar/carregar
  independentes. Dropdown com `Selecione...` (rótulo) e `Nenhum` (limpa). Se o acessório
  exibido já está salvo, "Salvar" vira **"🎀 Renomear Acessório"** (mesmo ícone) →
  `_do_rename`. Ver [[Fluxo - Salvar e Carregar]].
- **🗑️ Excluir acessório** (`_on_del_acc`) — remove permanentemente um acessório salvo
  (confirmação → `_on_delete_confirmed` → `saved_accessories.erase`). `Nenhum` é
  **intocável**; após excluir, volta **sempre** a `Nenhum`. Ver [[Fluxo - Salvar e Carregar]].

## Estado
`current_acc`, `saved_accessories[nome]`, `acc_menu_ids`, `acc_del_ids`.
Persistência em `user://accessories.json` — [[Sistema - Persistência]].
