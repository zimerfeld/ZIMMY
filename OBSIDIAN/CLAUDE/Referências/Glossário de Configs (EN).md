---
tags: [referencia, dados, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🗂️ Config Glossary

Data types that describe what appears on screen. See [[Sistema - Pets (EN)]],
[[Sistema - Acessórios (EN)]] and [[Sistema - Persistência (EN)]].

## Pet config (`current`, `saved_pets[name]`)
Colors (serialized as `[r,g,b,a]`, see `PET_COLOR_KEYS`):
`body_color`, `belly_color`, `ear_color`, `cheek_color`, `antenna_color`, `nose_color`,
`horn_color`.

Proportions (floats): `ear_dx`, `ear_y`, `ear_w`, `ear_h`, `eye_dx`, `eye_y`,
`eye_w`, `eye_h`, `body_w`, `body_h`, `belly_w`, `belly_h`.

Elements/shape (base):
- `has_ears` (bool) + `ear_shape` (`round` | `pointy`)
- `has_antennae` (bool)
- `has_cheeks` (bool)
- `has_nose` (bool)
- `has_eyelashes` (bool)
- `mouth_style` (`smile` | `cat` | `open` | `line` | `tongue` | `fang`)
- `body_shape` (`round` | `tall` | `wide` | `pear` | `chubby` | `slim`)
- `ear_shape` (`round` | `pointy` | `floppy`)

Extra geometric "skeleton" categories (all `none` when absent):
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
  animal archetype; `_apply_critter()` sets the shape keys, the color stays random

> The **Default** (`_default_cfg()`) pins these keys to the original face; the random
> generator (`_random_cfg()`) rolls them. `_json_to_cfg()` starts from the default, so old/partial
> files get the new keys automatically.

## Accessory config (`current_acc`, `saved_accessories[name]`)
Colors (`ACC_COLOR_KEYS`): `hat_color`, `glasses_color`, `bow_color`, `scarf_color`,
`necklace_color`, `earring_color`, `collar_color`, `headphone_color`, `monocle_color`,
`mustache_color`, `flower_color`, `badge_color`, `tie_color`, `sash_color`,
`mask_color`, `sticker_color`, `belt_color`, `backpack_color`.

Original types:
- `hat`: `none` | `beanie` | `tophat` | `crown` | `cap` | `wizard`
- `glasses`: `none` | `round` | `square` | `star` | `heart` | `sunglasses`
- `bow`: `none` | `head` | `neck`
- `scarf`: `none` | `present`

Extra geometric categories (all `none` when absent):
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

## Settings (`user://settings.json`)
`{ "anchor_x": int, "anchor_y": int, "pet": str, "acc": str, "show_acc": bool,
"lang": "pt"|"en", "status": bool }` — anchor (bottom-center) of the last position
**plus the active choice** of pet/accessory, accessory display, the **UI language** and the
**status bars** display (`status`, OFF by default). See
[[Sistema - Persistência (EN)]].

## i18n (`STRINGS` / `STRING_LISTS`)
`const` tables with `{ "pt": ..., "en": ... }` per key. `t(key)` returns the text and
`ta(key)` the list (mood/feed/pet/play) in the `lang` language. Covers menu, dialogs and speech.

## Notable constants ([[zimmy.gd (EN)]])
`PET_BOX=200`, `PET_SCALE=0.75`, `PET_DRAW=150`, `HOP_HEADROOM=80`,
`MAX_W=640`, `RANDOM_PERIOD=10.0`, `ACTION_COOLDOWN=1.0`, `MAX_REPEAT=3`,
`COMPLAIN_COOLDOWN=1.5`.
