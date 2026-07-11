---
tipo: conhecimento
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [referencia, dados, zimmy-pet]
---

# 🗂️ Glossário de Configs

> 🇺🇸 Read this page in English → [[🗂️ Glossário de Configs (EN)]]
> 🇪🇸 Lee esta página en español → [[🗂️ Glossário de Configs (ES)]]

Tipos de dado que descrevem o que aparece na tela. Ver [[🐾 Sistema - Pets]],
[[🎀 Sistema - Acessórios]] e [[💾 Sistema - Persistência]].

## 🐾 Config de Pet (`current`, `saved_pets[nome]`)
Cores (serializadas como `[r,g,b,a]`, ver `PET_COLOR_KEYS`):
`body_color`, `belly_color`, `ear_color`, `cheek_color`, `antenna_color`, `nose_color`,
`horn_color`.

Proporções (floats): `ear_dx`, `ear_y`, `ear_w`, `ear_h`, `eye_dx`, `eye_y`,
`eye_w`, `eye_h`, `body_w`, `body_h`, `belly_w`, `belly_h`.

Elementos/forma (base):
- `has_ears` (bool) + `ear_shape` (`round` | `pointy`)
- `has_antennae` (bool)
- `has_cheeks` (bool)
- `has_nose` (bool)
- `has_eyelashes` (bool)
- `mouth_style` (`smile` | `cat` | `open` | `line`)
- `body_shape` (`round` | `tall` | `wide` | `pear` | `chubby` | `slim`)
- `ear_shape` (`round` | `pointy` | `floppy`)
- `mouth_style` (`smile` | `cat` | `open` | `line` | `tongue` | `fang`)

Categorias geométricas extras do "esqueleto" (todas com `none` quando ausentes):
- `tail` (`none` | `curl` | `puff` | `stub`)
- `horn` (`none` | `unicorn` | `devil` | `antlers`) + `horn_color`
- `hair_tuft` (`none` | `tuft` | `cowlick` | `mohawk`)
- `eye_shape` (`round` | `oval` | `tall` | `sleepy`)
- `pupil_style` (`round` | `big` | `cat` | `sparkle` | `heart`)
- `eyebrow` (`none` | `flat` | `raised` | `serious`)
- `feet` (`none` | `paws`)
- `arms` (`none` | `nubs`)
- `belly_mark` (`none` | `spot` | `heart`)
- `whiskers` (`none` | `short` | `long`)
- `wings` (`none` | `small`)
- `freckles` (`none` | `freckles`)
- `body_pattern` (`none` | `spots` | `stripes`)
- `muzzle` (`none` | `round`)
- `critter` (`none` | `cat` | `dog` | `bunny` | `bear` | `frog` | `fox` | `mouse` | `pig`) —
  arquétipo de bicho; `_apply_critter()` define as chaves de forma, a cor segue aleatória

> O **Default** (`_default_cfg()`) fixa essas chaves na carinha original; o aleatório
> (`_random_cfg()`) as sorteia. `_json_to_cfg()` parte do default, então arquivos
> antigos/parciais ganham as chaves novas automaticamente.

## 🎀 Config de Acessório (`current_acc`, `saved_accessories[nome]`)
Cores (`ACC_COLOR_KEYS`): `hat_color`, `glasses_color`, `bow_color`, `scarf_color`,
`necklace_color`, `earring_color`, `collar_color`, `headphone_color`, `monocle_color`,
`mustache_color`, `flower_color`, `badge_color`, `tie_color`, `sash_color`,
`mask_color`, `sticker_color`, `belt_color`, `backpack_color`.

Tipos originais:
- `hat`: `none` | `beanie` | `tophat` | `crown` | `cap` | `wizard`
- `glasses`: `none` | `round` | `square` | `star` | `heart` | `sunglasses`
- `bow`: `none` | `head` | `neck`
- `scarf`: `none` | `present`

Categorias geométricas extras (todas com `none` quando ausentes):
- `necklace` (`pearls` | `pendant`)
- `earrings` (`studs` | `hoops`)
- `collar` (`plain` | `bell`)
- `headphones` (`present`)
- `monocle` (`present`)
- `mustache` (`curly` | `thin`)
- `flower` (`present`)
- `badge` (`star` | `heart`)
- `tie` (`necktie` | `bowtie`)
- `sash` (`present`)
- `mask` (`medical` | `ninja`)
- `cheek_sticker` (`star` | `heart`)
- `belt` (`plain` | `buckle`)
- `backpack` (`present`)

## ⚙️ Settings (`user://settings.json`)
`{ "anchor_x": int, "anchor_y": int, "pet": str, "acc": str, "show_acc": bool,
"lang": "pt"|"en", "status": bool, "wa_sound": bool, "gmail_sound": bool }` — âncora
(centro-inferior) da última posição **+ escolha ativa** de pet/acessório, exibição de
acessórios, **idioma da UI**, exibição das **barras de status** (`status`, OFF por padrão)
e os **alertas de som** dos submenus 💬 WhatsApp / 📧 E-mails (`wa_sound` / `gmail_sound`,
ON por padrão). Ver [[💾 Sistema - Persistência]].

## 🌐 i18n (`STRINGS` / `STRING_LISTS`)
Tabelas `const` com `{ "pt": ..., "en": ... }` por chave. `t(key)` devolve o texto e
`ta(key)` a lista (mood/feed/pet/play) no idioma `lang`. Cobre menu, diálogos e falas.

## 🔢 Constantes notáveis ([[📄 zimmy.gd]])
`PET_BOX=200`, `PET_SCALE=0.75`, `PET_DRAW=150`, `HOP_HEADROOM=80`,
`MAX_W=300`, `RANDOM_PERIOD=30.0`, `ACTION_COOLDOWN=1.0`, `MAX_REPEAT=3`,
`COMPLAIN_COOLDOWN=1.5`.
