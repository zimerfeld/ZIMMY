---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, pets, zimmy-pet]
---

# 🐾 Sistema - Mascotas

> 🇧🇷 Lee esta página en portugués → [[🐾 Sistema - Pets]]
> 🇺🇸 Read this page in English → [[🐾 Sistema - Pets (EN)]]

Cada mascota es un **config** (Dictionary) consumido por `_draw()`. El mismo código genera
el Default, los aleatorios y los guardados. Esquema completo en
[[🗂️ Glossário de Configs (ES)]].

## 🔰 Default — `_default_cfg()` (`zimmy.gd:128`)
La carita original (naranja). **Siempre disponible y nunca eliminada.** Fija colores,
proporciones y elementos: `has_ears=true/round`, `has_cheeks=true`, sin antenas/nariz/
pestañas, `mouth_style="smile"`.

## 🎲 Aleatorio — `_random_cfg()`
Busca **estética equilibrada y colores alegres**, manteniendo el estilo "Zimmy":
- **Bichitos** — ~55% de las generaciones se convierten en un animal reconocible (`critter` ∈ {cat, dog,
  bunny, bear, frog, fox, mouse, pig}). `_apply_critter(cfg, kind)` sobrescribe las claves
  de **forma** (oreja/boca/bigote/cola/proporciones) y limpia los adornos de fantasía; el **color
  sigue siendo aleatorio**. El otro ~45% sigue combinaciones libres.
- **Colores** — matiz base (`hue`); los colores de acento (oreja/antena/nariz) vienen de un
  **esquema de armonía** sorteado: `analogous`/`complementary`/`triadic`/`monochrome`
  (`accent_hue`). Saturación/brillo en franjas vibrantes-pero-suaves (`body_s` 0.42–0.68,
  `body_v` 0.86–0.98) → evita tonos sucios/oscuros. Barriga = mismo matiz desaturado y
  claro (contraste cohesivo); mejilla = rosado cálido translúcido.
- **Geometría** — `body_shape` ∈ {`round`(2×), `tall`, `wide`, `pear`, `chubby`, `slim`}:
  el `_draw()` estira/aplana la silueta y, en el `pear`, dibuja un bulto inferior extra.
- **Proporciones** en franjas (`randf_range`).
- **Formas/elementos** (probabilidades): `has_ears` 85%, `ear_shape` round/pointy/floppy,
  `has_antennae` 40%, `has_cheeks` 70%, `has_nose` 60%, `has_eyelashes` 50%,
  `mouth_style` ∈ {smile, cat, open, line, tongue, fang}.
- **Categorías extra del "esqueleto"** (≈14, sorteadas **de forma independiente**, con
  `none` de mayor peso p/ no sobrecargar): `tail` (curl/puff/stub), `horn`
  (unicorn/devil/antlers + `horn_color`), `hair_tuft` (tuft/cowlick/mohawk),
  `eye_shape` (oval/tall/sleepy), `pupil_style` (big/cat/sparkle/heart), `eyebrow`
  (flat/raised/serious), `feet` (paws), `arms` (nubs), `belly_mark` (spot/heart),
  `whiskers` (short/long), `wings` (small), `freckles`, `body_pattern` (spots/stripes),
  `muzzle`. Cada una tiene su propio helper `_draw_*`; ver [[🎨 Sistema - Render (_draw) (ES)]].

## 📦 Estado
- `current` — mascota mostrada ahora.
- `saved_pets[nombre]` — mascotas guardadas (en memoria, con `Color`).

## 🛠️ Operaciones
- **Guardar**: `_open_save_dialog("pet", "save")` → `_on_save_confirmed` →
  `saved_pets[nombre]=current.duplicate(true)` → [[💾 Sistema - Persistência (ES)]].
- **Renombrar**: si la mascota mostrada ya está guardada, el elemento de menú pasa a "💾 Renombrar Pet"
  (mismo icono) → `_open_save_dialog("pet", "rename")` → `_do_rename` (cambia la clave,
  preserva el orden, regraba). Ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- **Elegir**: submenú "📂 Elegir pet" → `_on_pick_pet` (`Default`/guardados);
  desactiva solo la generación de mascotas. Ver [[🧭 Sistema - Menu de Contexto (ES)]].
- **Eliminar**: submenú "🗑️ Eliminar pet" → `_on_del_pet` → confirmación →
  `_on_delete_confirmed` (`saved_pets.erase`). El `Default` es **intocable**; tras eliminar,
  Zimmy **recarga siempre el `Default`**. Ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- **Generación continua**: ver [[🎲 Fluxo - Geração Aleatória (ES)]].

Dibujo de los elementos: [[🎨 Sistema - Render (_draw) (ES)]]. Los accesorios son una **capa
separada**: [[🎀 Sistema - Acessórios (ES)]].
