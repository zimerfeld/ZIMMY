---
tags: [referencia, dados, zimmy-pet]
atualizado: 2026-06-20
---

# 🗂️ Glossário de Configs

Tipos de dado que descrevem o que aparece na tela. Ver [[Sistema - Pets]],
[[Sistema - Acessórios]] e [[Sistema - Persistência]].

## Config de Pet (`current`, `saved_pets[nome]`)
Cores (serializadas como `[r,g,b,a]`, ver `PET_COLOR_KEYS`):
`body_color`, `belly_color`, `ear_color`, `cheek_color`, `antenna_color`, `nose_color`.

Proporções (floats): `ear_dx`, `ear_y`, `ear_w`, `ear_h`, `eye_dx`, `eye_y`,
`eye_w`, `eye_h`, `body_w`, `body_h`, `belly_w`, `belly_h`.

Elementos/forma:
- `has_ears` (bool) + `ear_shape` (`round` | `pointy`)
- `has_antennae` (bool)
- `has_cheeks` (bool)
- `has_nose` (bool)
- `has_eyelashes` (bool)
- `mouth_style` (`smile` | `cat` | `open` | `line`)

> O **Default** (`_default_cfg()`) fixa essas chaves na carinha original; o aleatório
> (`_random_cfg()`) as sorteia. `_json_to_cfg()` parte do default, então arquivos
> antigos/parciais ganham as chaves novas automaticamente.

## Config de Acessório (`current_acc`, `saved_accessories[nome]`)
Cores (`ACC_COLOR_KEYS`): `hat_color`, `glasses_color`, `bow_color`, `scarf_color`.
Tipos:
- `hat`: `none` | `beanie` | `tophat` | `crown` | `cap`
- `glasses`: `none` | `round` | `square` | `star`
- `bow`: `none` | `head` | `neck`
- `scarf`: `none` | `present`

## Settings (`user://settings.json`)
`{ "anchor_x": int, "anchor_y": int }` — âncora (centro-inferior) da última posição.

## Constantes notáveis ([[zimmy.gd]])
`PET_BOX=200`, `PET_SCALE=0.75`, `PET_DRAW=150`, `HOP_HEADROOM=80`,
`MAX_W=640`, `RANDOM_PERIOD=9.0`, `ACTION_COOLDOWN=1.0`, `MAX_REPEAT=3`,
`COMPLAIN_COOLDOWN=1.5`.
