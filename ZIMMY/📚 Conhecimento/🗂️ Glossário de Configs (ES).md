---
tipo: conhecimento
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [referencia, dados, zimmy-pet]
---

# 🗂️ Glossário de Configs

> 🇧🇷 Lee esta página en portugués → [[🗂️ Glossário de Configs]]
> 🇺🇸 Read this page in English → [[🗂️ Glossário de Configs (EN)]]

Tipos de dato que describen lo que aparece en la pantalla. Ver [[🐾 Sistema - Pets (ES)]],
[[🎀 Sistema - Acessórios (ES)]] y [[💾 Sistema - Persistência (ES)]].

## 🐾 Config de Pet (`current`, `saved_pets[nome]`)
Colores (serializados como `[r,g,b,a]`, ver `PET_COLOR_KEYS`):
`body_color`, `belly_color`, `ear_color`, `cheek_color`, `antenna_color`, `nose_color`,
`horn_color`.

Proporciones (floats): `ear_dx`, `ear_y`, `ear_w`, `ear_h`, `eye_dx`, `eye_y`,
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

Categorías geométricas extra del "esqueleto" (todas con `none` cuando están ausentes):
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
  arquetipo de bicho; `_apply_critter()` define las claves de forma, el color sigue siendo aleatorio

> El **Default** (`_default_cfg()`) fija esas claves en la carita original; el aleatorio
> (`_random_cfg()`) las sortea. `_json_to_cfg()` parte del default, así que los archivos
> antiguos/parciales obtienen las claves nuevas automáticamente.

## 🎀 Config de Acessório (`current_acc`, `saved_accessories[nome]`)
Colores (`ACC_COLOR_KEYS`): `hat_color`, `glasses_color`, `bow_color`, `scarf_color`,
`necklace_color`, `earring_color`, `collar_color`, `headphone_color`, `monocle_color`,
`mustache_color`, `flower_color`, `badge_color`, `tie_color`, `sash_color`,
`mask_color`, `sticker_color`, `belt_color`, `backpack_color`.

Tipos originales:
- `hat`: `none` | `beanie` | `tophat` | `crown` | `cap` | `wizard`
- `glasses`: `none` | `round` | `square` | `star` | `heart` | `sunglasses`
- `bow`: `none` | `head` | `neck`
- `scarf`: `none` | `present`

Categorías geométricas extra (todas con `none` cuando están ausentes):
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
"lang": "pt"|"en", "status": bool, "wa_sound": bool, "gmail_sound": bool }` — ancla
(centro-inferior) de la última posición **+ elección activa** de pet/accesorio, visualización de
accesorios, **idioma de la UI**, visualización de las **barras de estado** (`status`, OFF por defecto)
y las **alertas de sonido** de los submenús 💬 WhatsApp / 📧 E-mails (`wa_sound` / `gmail_sound`,
ON por defecto). Ver [[💾 Sistema - Persistência (ES)]].

## 🌐 i18n (`STRINGS` / `STRING_LISTS`)
Tablas `const` con `{ "pt": ..., "en": ... }` por clave. `t(key)` devuelve el texto y
`ta(key)` la lista (mood/feed/pet/play) en el idioma `lang`. Cubre menú, diálogos y textos de habla.

## 🔢 Constantes notables ([[📄 zimmy.gd (ES)]])
`PET_BOX=200`, `PET_SCALE=0.75`, `PET_DRAW=150`, `HOP_HEADROOM=80`,
`MAX_W=300`, `RANDOM_PERIOD=30.0`, `ACTION_COOLDOWN=1.0`, `MAX_REPEAT=3`,
`COMPLAIN_COOLDOWN=1.5`.
</content>
