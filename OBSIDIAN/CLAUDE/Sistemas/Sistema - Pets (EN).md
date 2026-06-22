---
tags: [sistema, pets, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🐾 System - Pets

Each pet is a **config** (Dictionary) consumed by `_draw()`. The same code generates the
Default, the random ones and the saved ones. Full schema in [[Glossário de Configs (EN)]].

## Default — `_default_cfg()` (`zimmy.gd:128`)
The original little face (orange). **Always available and never removed.** It fixes colors,
proportions and elements: `has_ears=true/round`, `has_cheeks=true`, no antennae/nose/
eyelashes, `mouth_style="smile"`.

## Random — `_random_cfg()`
Aims for **balanced aesthetics and cheerful colors**, keeping the "Zimmy" style:
- **Critters** — ~55% of rolls become a recognizable animal (`critter` ∈ {cat, dog,
  bunny, bear, frog, fox, mouse, pig}). `_apply_critter(cfg, kind)` overrides the **shape**
  keys (ear/mouth/whiskers/tail/proportions) and clears fancy adornments; the **color
  stays random**. The other ~45% remain free combinatorial creatures.
- **Colors** — base hue (`hue`); the accent colors (ear/antenna/nose) come from a
  **harmony scheme** that is rolled: `analogous`/`complementary`/`triadic`/`monochrome`
  (`accent_hue`). Saturation/brightness in vibrant-yet-soft ranges (`body_s` 0.42–0.68,
  `body_v` 0.86–0.98) → avoids muddy/dark tones. Belly = same desaturated and
  light hue (cohesive contrast); cheek = warm translucent pink.
- **Geometry** — `body_shape` ∈ {`round`(2×), `tall`, `wide`, `pear`, `chubby`, `slim`}:
  `_draw()` stretches/flattens the silhouette and, in `pear`, draws an extra lower bulge.
- **Proportions** in ranges (`randf_range`).
- **Shapes/elements** (probabilities): `has_ears` 85%, `ear_shape` round/pointy/floppy,
  `has_antennae` 40%, `has_cheeks` 70%, `has_nose` 60%, `has_eyelashes` 50%,
  `mouth_style` ∈ {smile, cat, open, line, tongue, fang}.
- **Extra "skeleton" categories** (≈14, rolled **independently**, with
  `none` weighted higher so it does not get overloaded): `tail` (curl/puff/stub), `horn`
  (unicorn/devil/antlers + `horn_color`), `hair_tuft` (tuft/cowlick/mohawk),
  `eye_shape` (oval/tall/sleepy), `pupil_style` (big/cat/sparkle/heart), `eyebrow`
  (flat/raised/serious), `feet` (paws), `arms` (nubs), `belly_mark` (spot/heart),
  `whiskers` (short/long), `wings` (small), `freckles`, `body_pattern` (spots/stripes),
  `muzzle`. Each has its own `_draw_*` helper; see [[Sistema - Render (_draw) (EN)]].

## State
- `current` — the pet displayed now.
- `saved_pets[name]` — saved pets (in memory, with `Color`).

## Operations
- **Save**: `_open_save_dialog("pet", "save")` → `_on_save_confirmed` →
  `saved_pets[name]=current.duplicate(true)` → [[Sistema - Persistência (EN)]].
- **Rename**: if the displayed pet is already saved, the menu item becomes "💾 Rename Pet"
  (same icon) → `_open_save_dialog("pet", "rename")` → `_do_rename` (swaps the key,
  preserves the order, rewrites). See [[Fluxo - Salvar e Carregar (EN)]].
- **Choose**: submenu "📂 Choose pet" → `_on_pick_pet` (`Default`/saved);
  turns off only the pet generation. See [[Sistema - Menu de Contexto (EN)]].
- **Delete**: submenu "🗑️ Delete pet" → `_on_del_pet` → confirmation →
  `_on_delete_confirmed` (`saved_pets.erase`). The `Default` is **untouchable**; after deleting,
  Zimmy **always reloads the `Default`**. See [[Fluxo - Salvar e Carregar (EN)]].
- **Continuous generation**: see [[Fluxo - Geração Aleatória (EN)]].

Drawing of the elements: [[Sistema - Render (_draw) (EN)]]. Accessories are a **separate
layer**: [[Sistema - Acessórios (EN)]].
