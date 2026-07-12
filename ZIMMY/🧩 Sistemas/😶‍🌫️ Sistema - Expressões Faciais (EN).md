---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [sistema, expressao, rosto, zimmy-pet]
---

# 😶‍🌫️ System - Facial Expressions

> 🇪🇸 Lee esta página en español → [[😶‍🌫️ Sistema - Expressões Faciais (ES)]]

While the pet speaks, **the face mirrors the emotion of the sentence's emoji**. Added in
2026-06-20.

## 🔍 How it works
- `say(t)` stores the speech; when shown, the pump computes `expression` via
  `_expression_from_text(t)` (scans the sentence for known emojis, in priority order, and
  returns the expression or `"neutral"`).
- **Face priority** in the [[🎨 Sistema - Render (_draw) (EN)]]:
  `react_expr` (hover/shake reaction) **>** speech emoji **>** zeroed need **>** neutral.
  The first non-neutral becomes `_draw_expression(expr, ...)` (eyes + mouth + extras); the
  neutral face draws eyes following the cursor + mouth from the config + eyelashes.
- When the speech/reaction clears in the [[🔁 Fluxo - Loop (_process) (EN)]], `expression` returns to `"neutral"`.

## 🗺️ Emoji → expression map
| Expression | Triggers | Face |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | ∩ eyes, blush, big smile |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | wide eyes + sparkle, open mouth |
| `angry` | 😠 😤 😡 💢 | \ / eyebrows, narrow eyes, ∩ mouth |
| `sad` | 😢 😞 😭 🥺 | / \ eyebrows, downward gaze, tear |
| `disgust` | 🤢 🤮 😖 | crooked eye, wavy mouth, little tongue |
| `indifferent` | 😑 🙄 😒 🫤 | eyes as dashes, straight mouth |
| `sleepy` | 😴 💤 🥱 | ∪ eyes, little mouth |

## 😖 Need faces (no speech) — via `_need_expression()`
When a need bar hits zero, the **idle face** changes (same `_draw_expression`):
| Expression | Trigger | Face |
|---|---|---|
| `hungry` | `stat_feed=0` | sad eyes, **wide-open mouth** + little tongue |
| `needy` | `stat_pet=0` | **crying** (two tears), sad mouth |
| `bored` | `stat_play=0` | **closed eyes** (—), droopy brow, straight mouth |
See [[📊 Sistema - Necessidades (EN)]].

## 🖱️ Mouse reactions (no menu) — `react_expr` + eye click
Reactions triggered straight from the cursor (see [[🚪 Entrada - Eventos de Input (EN)]] and
[[✨ Sistema - Animação (EN)]]), with a temporary `react_expr` expression (top priority):
| Reaction | Trigger | Face |
|---|---|---|
| `happy`/`excited` | **hover** — cursor enters the pet | happy/excited expression for ~1.1s |
| `dizzy` | **shake** the mouse fast near the pet | **spiral** eyes (@_@) + wavy mouth |
| `nausea` | same (random) | half-lidded eyes + **green cheeks** + wavy mouth |
| `scared` | same (random) | **wide** eyes (tiny pupil) + high brows + sweat drop |

**Eye click:** clicking on an eye closes that eye (`eye_closed_l`/`eye_closed_r`, a ∪ arc)
and keeps it shut **while the cursor stays over it** — reopens on leaving (ellipse hit-test
in logical space; pupil drawn by `_draw_pupil`, only for the open eye).

## 🤝 Synergy
The [[😤 Sistema - Interação e Mau Humor (EN)|bad mood]] sentences (`MOOD_NEG`) use
🤢/😠/😤/😢/😞/😑/🙄/😴 — so **insisting on an action** makes the face angry/disgusted/
sad/indifferent, not just the text. The normal actions (`feed`🦴😋, `pet`🥰, `play`🎾🚀)
trigger happy/excited.

> ⚠️ A new drawing on the face → updating [[📄 tools - make_icon.py (EN)]] is **not**
> necessary (the icon uses only the default happy face), but changes to the **neutral**
> face do require it. See [[🎨 Sistema - Render (_draw) (EN)]].
