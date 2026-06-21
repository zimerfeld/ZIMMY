---
tags: [sistema, expressao, rosto, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 😶‍🌫️ System - Facial Expressions

While the pet speaks, **the face mirrors the emotion of the sentence's emoji**. Added in
2026-06-20.

## How it works
- `say(t)` calls `_expression_from_text(t)` and stores it in `expression`.
- `_expression_from_text` (`zimmy.gd`) scans the sentence for known emojis, in
  priority order, and returns the expression (or `"neutral"`).
- In the [[Sistema - Render (_draw) (EN)]], if there is speech (`speech.text != ""`) and
  `expression != "neutral"`, the default face is **replaced** by
  `_draw_expression(expr, ...)` (eyes + mouth + extras). Otherwise, it draws the normal
  face (eyes following the cursor + mouth from the config + eyelashes).
- When the speech is cleared in the [[Fluxo - Loop (_process) (EN)]], `expression` returns to `"neutral"`.

## Emoji → expression map
| Expression | Triggers | Face |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | ∩ eyes, blush, big smile |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | wide eyes + sparkle, open mouth |
| `angry` | 😠 😤 😡 💢 | \ / eyebrows, narrow eyes, ∩ mouth |
| `sad` | 😢 😞 😭 🥺 | / \ eyebrows, downward gaze, tear |
| `disgust` | 🤢 🤮 😖 | crooked eye, wavy mouth, little tongue |
| `indifferent` | 😑 🙄 😒 🫤 | eyes as dashes, straight mouth |
| `sleepy` | 😴 💤 🥱 | ∪ eyes, little mouth |

## Synergy
The [[Sistema - Interação e Mau Humor (EN)|bad mood]] sentences (`MOOD_NEG`) use
🤢/😠/😤/😢/😞/😑/🙄/😴 — so **insisting on an action** makes the face angry/disgusted/
sad/indifferent, not just the text. The normal actions (`feed`🦴😋, `pet`🥰, `play`🎾🚀)
trigger happy/excited.

> ⚠️ A new drawing on the face → updating [[tools - make_icon.py (EN)]] is **not**
> necessary (the icon uses only the default happy face), but changes to the **neutral**
> face do require it. See [[Sistema - Render (_draw) (EN)]].
