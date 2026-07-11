---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, acessorios, zimmy-pet]
---

# 🎀 Sistema - Accesorios

> 🇧🇷 Lee esta página en portugués → [[🎀 Sistema - Acessórios]]
> 🇺🇸 Read this page in English → [[🎀 Sistema - Acessórios (EN)]]

Capa **independiente de la mascota**, dibujada por encima. Guardar/cargar es independiente de
las mascotas (una mascota guardada no lleva accesorio y viceversa), así que puedes combinar
cualquier mascota con cualquier accesorio.

## 🏷️ Tipos (esquema en [[🗂️ Glossário de Configs (ES)]])
Originales:
- `hat`: none | beanie | tophat | crown | cap | wizard
- `glasses`: none | round | square | star | heart | sunglasses
- `bow`: none | head | neck
- `scarf`: none | present

Categorías extra (≈14, sorteadas **de forma independiente**, cada una con su color propio):
- `necklace` (pearls/pendant), `earrings` (studs/hoops), `collar` (plain/bell),
  `headphones` (present), `monocle` (present), `mustache` (curly/thin),
  `flower` (present), `badge` (star/heart), `tie` (necktie/bowtie), `sash` (present),
  `mask` (medical/ninja), `cheek_sticker` (star/heart), `belt` (plain/buckle),
  `backpack` (present).
- Colores en `ACC_COLOR_KEYS`: las 4 originales + `necklace_color`, `earring_color`,
  `collar_color`, `headphone_color`, `monocle_color`, `mustache_color`, `flower_color`,
  `badge_color`, `tie_color`, `sash_color`, `mask_color`, `sticker_color`, `belt_color`,
  `backpack_color`.

## 🔧 Funciones
- `_default_acc()` — todo `none` (el Default no lleva nada puesto).
- `_random_acc()` — sortea tipos y colores (con `none` de mayor peso en los extra).
- Dibujo: `_draw_accessories()` — originales (bufanda detrás → sombrero → gafas → lazo)
  y luego los extra, cada uno con su helper `_draw_*` (sash, collar, necklace, tie,
  badge, headphones, flower, earrings, monocle, mustache, mask, cheek_sticker).
  Ver [[🎨 Sistema - Render (_draw) (ES)]].

## 🎛️ Controles (3 independientes) — [[🧭 Sistema - Menu de Contexto (ES)]]
- **🎲 Generar accesorios** (`MI_RANDOM_ACC`) — generación continua propia
  ([[🎲 Fluxo - Geração Aleatória (ES)]]); activarlo también activa la visualización.
- **👓 Mostrar accesorios** (`MI_SHOW_ACC`, `show_accessories`, default **on**) —
  solo controla el dibujo (`if show_accessories` en el `_draw`).
- **🎀 Guardar Accesorio** / **🧳 Elegir accesorio** — guardar/cargar
  independientes. Desplegable con `Selecione...` (etiqueta) y `Nenhum` (limpia). Si el
  accesorio mostrado ya está guardado, "Guardar" se convierte en **"🎀 Renombrar Accesorio"**
  (mismo icono) → `_do_rename`. Ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- **🗑️ Eliminar accesorio** (`_on_del_acc`) — elimina permanentemente un accesorio guardado
  (confirmación → `_on_delete_confirmed` → `saved_accessories.erase`). `Nenhum` es
  **intocable**; tras eliminar, vuelve **siempre** a `Nenhum`. Ver [[💾 Fluxo - Salvar e Carregar (ES)]].

## 📦 Estado
`current_acc`, `saved_accessories[nombre]`, `acc_menu_ids`, `acc_del_ids`.
Persistencia en `user://accessories.json` — [[💾 Sistema - Persistência (ES)]].
