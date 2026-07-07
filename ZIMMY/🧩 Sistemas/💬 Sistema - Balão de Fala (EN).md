---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [sistema, fala, ui, zimmy-pet]
---

# 💬 System - Speech Bubble

A `Label` (created in the [[🟢 Fluxo - Inicialização (EN)]]) with an outline, using the
**Godot default font** (it renders accents and colored emojis on the Compatibility
renderer — a `SystemFont` would make the text disappear).

## 🔌 API — two lanes (reaction vs. queue)
The bubble has **two lanes** resolved by priority in the [[🔁 Fluxo - Loop (_process) (EN)]]
pump (**reaction > notification > nothing**), so nothing gets lost or spammy:
- `say(msg, hold := REACTION_HOLD)` — **immediate reaction** (pet interactions, hover, shake,
  selection, save/errors, greeting). Sets `react_text`/`react_hold` and shows **right away**,
  with priority over the queue. `REACTION_HOLD = 2.5s`.
- `notify(msg)` — **notification queue** (automations/e-mails/reminders). Enqueues into
  `msg_queue` as `{text, wait}`; each item stays visible `MSG_DURATION = 10s` in turn, never
  overlapping. While a reaction is on screen the notification **pauses** (`notify_hold` does
  not run) and resumes afterward, so it gets its full 10s.
- **User-action queue jump:** clicking an automation opens a window
  `urgent_cd = URGENT_WINDOW (6s)` in `_on_pick_automation`. Within it, `notify()` calls
  `_preempt_with(msg)` — the background notification goes back to the front of the queue and
  the user's response shows **immediately** (covers async web ones too, whose callback
  arrives within the window).
- **Time-based discard:** each frame every item's `wait` grows; items waiting more than
  `MAX_QUEUE_WAIT = 60s` in the queue are **discarded** (no longer relevant).
- In the pump, when there is no reaction nor notification and the queue empties, the text is
  cleared and the window shrinks.

## 📐 Sizing — in `_relayout()` ([[🪟 Sistema - Janela Overlay (EN)]])
- Measures the text with the real font; width grows only as needed.
- Above `MAX_W=300 px` it enables wrapping (`AUTOWRAP_WORD_SMART`) and computes the line count (a long phrase wraps into multiple lines).
- The text band sits **right above the pet's body**:
  `speech.position.y = pet_y - SPEECH_GAP - band` (the `HOP_HEADROOM` is left over on top).
- Constants: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## 🗣️ Who speaks
Initial greeting (`t("hello") % name` — uses the **active saved pet name**
`current_pet_name`, or "Zimmy" if Default/random); actions (`feed/pet/play/_react`); pet
and accessory generation/selection; saving/errors; bad-mood complaints
([[😤 Sistema - Interação e Mau Humor (EN)]], list `mood_neg`); mouse reactions (hover/shake,
see [[😶‍🌫️ Sistema - Expressões Faciais (EN)]]); and the **automations/e-mails** (via
`notify()`, 10s queue).

## 🪞 Mirrors on the face
`say()` also deduces the emotion from the emoji and the face reflects it while the
speech lasts — see [[😶‍🌫️ Sistema - Expressões Faciais (EN)]].
