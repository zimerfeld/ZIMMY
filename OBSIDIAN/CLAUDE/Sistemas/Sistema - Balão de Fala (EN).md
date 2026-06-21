---
tags: [sistema, fala, ui, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 💬 System - Speech Bubble

A `Label` (created in the [[Fluxo - Inicialização (EN)]]) with an outline, using the
**Godot default font** (it renders accents and colored emojis on the Compatibility
renderer — a `SystemFont` would make the text disappear).

## API
- `say(t)` (`zimmy.gd:904`) — sets the text, schedules clearing (`speech_clear=2.5s`) and
  calls `_relayout()`.
- In the [[Fluxo - Loop (_process) (EN)]], when `speech_clear` expires the text is cleared
  and the window shrinks.

## Sizing — in `_relayout()` ([[Sistema - Janela Overlay (EN)]])
- Measures the text with the real font; width grows only as needed.
- Above `MAX_W=640 px` it enables wrapping (`AUTOWRAP_WORD_SMART`) and computes the line count.
- The text band sits **right above the pet's body**:
  `speech.position.y = pet_y - SPEECH_GAP - band` (the `HOP_HEADROOM` is left over on top).
- Constants: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## Who speaks
Initial greeting; actions (`feed/pet/play/_react`); pet and accessory
generation/selection; saving/errors; and the bad-mood complaints
([[Sistema - Interação e Mau Humor (EN)]], list `MOOD_NEG`).

## Mirrors on the face
`say()` also deduces the emotion from the emoji and the face reflects it while the
speech lasts — see [[Sistema - Expressões Faciais (EN)]].
