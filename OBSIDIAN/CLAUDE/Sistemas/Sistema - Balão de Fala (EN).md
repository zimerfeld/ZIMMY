---
tags: [sistema, fala, ui, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 💬 System - Speech Bubble

A `Label` (created in the [[Fluxo - Inicialização (EN)]]) with an outline, using the
**Godot default font** (it renders accents and colored emojis on the Compatibility
renderer — a `SystemFont` would make the text disappear).

## API
- `say(msg, hold := 2.5)` — sets the text, schedules clearing (`speech_clear = hold`) and
  calls `_relayout()`. Shows **immediately** (pet interactions, selection, save/errors).
- `notify(msg)` — **notification queue** for automations/e-mails: enqueues into
  `notify_queue`, and the [[Fluxo - Loop (_process) (EN)]] releases the next one every
  `NOTIFY_GAP = 5s` (`notify_cd`), calling `say(msg, NOTIFY_HOLD)` — the message stays
  visible for **5s** (`NOTIFY_HOLD`) before hiding. Prevents several messages (e.g. many
  currency quotes) from overwriting each other. The 1st shows now; the rest wait 5s.
- In the [[Fluxo - Loop (_process) (EN)]], when `speech_clear` expires the text is cleared
  and the window shrinks.

## Sizing — in `_relayout()` ([[Sistema - Janela Overlay (EN)]])
- Measures the text with the real font; width grows only as needed.
- Above `MAX_W=640 px` it enables wrapping (`AUTOWRAP_WORD_SMART`) and computes the line count.
- The text band sits **right above the pet's body**:
  `speech.position.y = pet_y - SPEECH_GAP - band` (the `HOP_HEADROOM` is left over on top).
- Constants: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## Who speaks
Initial greeting (`t("hello") % name` — uses the **active saved pet name**
`current_pet_name`, or "Zimmy" if Default/random); actions (`feed/pet/play/_react`); pet
and accessory generation/selection; saving/errors; bad-mood complaints
([[Sistema - Interação e Mau Humor (EN)]], list `mood_neg`); and the **automations/
e-mails** (via `notify()`, spaced 5s apart).

## Mirrors on the face
`say()` also deduces the emotion from the emoji and the face reflects it while the
speech lasts — see [[Sistema - Expressões Faciais (EN)]].
