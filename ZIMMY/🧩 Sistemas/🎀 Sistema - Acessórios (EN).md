---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, acessorios, zimmy-pet]
---

# 🎀 System - Accessories

> 🇧🇷 Leia esta página em português → [[🎀 Sistema - Acessórios]]
> 🇪🇸 Lee esta página en español → [[🎀 Sistema - Acessórios (ES)]]

A **pet-independent** layer, drawn on top. Saving/loading is separate from the
pets (a saved pet does not carry an accessory and vice versa), so you can combine any
pet with any accessory.

## 🏷️ Types (schema in [[🗂️ Glossário de Configs (EN)]])
Originals:
- `hat`: none | beanie | tophat | crown | cap | wizard
- `glasses`: none | round | square | star | heart | sunglasses
- `bow`: none | head | neck
- `scarf`: none | present

Extra categories (≈14, rolled **independently**, each with its own color):
- `necklace` (pearls/pendant), `earrings` (studs/hoops), `collar` (plain/bell),
  `headphones` (present), `monocle` (present), `mustache` (curly/thin),
  `flower` (present), `badge` (star/heart), `tie` (necktie/bowtie), `sash` (present),
  `mask` (medical/ninja), `cheek_sticker` (star/heart), `belt` (plain/buckle),
  `backpack` (present).
- Colors in `ACC_COLOR_KEYS`: the 4 originals + `necklace_color`, `earring_color`,
  `collar_color`, `headphone_color`, `monocle_color`, `mustache_color`, `flower_color`,
  `badge_color`, `tie_color`, `sash_color`, `mask_color`, `sticker_color`, `belt_color`,
  `backpack_color`.

## 🔧 Functions
- `_default_acc()` — everything `none` (the Default wears nothing).
- `_random_acc()` — rolls types and colors (with `none` weighted higher on the extras).
- Drawing: `_draw_accessories()` — originals (scarf behind → hat → glasses → bow)
  and then the extras, each with its own `_draw_*` helper (sash, collar, necklace, tie,
  badge, headphones, flower, earrings, monocle, mustache, mask, cheek_sticker).
  See [[🎨 Sistema - Render (_draw) (EN)]].

## 🎛️ Controls (3 independent) — [[🧭 Sistema - Menu de Contexto (EN)]]
- **🎲 Generate accessories** (`MI_RANDOM_ACC`) — its own continuous generation
  ([[🎲 Fluxo - Geração Aleatória (EN)]]); turning it on also turns on the display.
- **👓 Show accessories** (`MI_SHOW_ACC`, `show_accessories`, default **on**) —
  controls only the drawing (`if show_accessories` in `_draw`).
- **🎀 Save Accessory** / **🧳 Choose accessory** — independent save/load.
  Dropdown with `Selecione...` (label) and `Nenhum` (clears). If the displayed
  accessory is already saved, "Save" becomes **"🎀 Rename Accessory"** (same icon) →
  `_do_rename`. See [[💾 Fluxo - Salvar e Carregar (EN)]].
- **🗑️ Delete accessory** (`_on_del_acc`) — permanently removes a saved accessory
  (confirmation → `_on_delete_confirmed` → `saved_accessories.erase`). `Nenhum` is
  **untouchable**; after deleting, it **always** returns to `Nenhum`. See [[💾 Fluxo - Salvar e Carregar (EN)]].

## 📦 State
`current_acc`, `saved_accessories[name]`, `acc_menu_ids`, `acc_del_ids`.
Persistence in `user://accessories.json` — [[💾 Sistema - Persistência (EN)]].
