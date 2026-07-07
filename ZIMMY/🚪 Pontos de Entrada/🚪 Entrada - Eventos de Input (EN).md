---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [endpoint, input, zimmy-pet]
---

# 🚪 Entry Point - Input Events

The overlay's input "API". It goes through `_input(event)` **and** global-cursor sampling in
the [[🔁 Fluxo - Loop (_process) (EN)]] (hover/shake work even without focus/events).
(There are no network endpoints — it's a desktop app; these events are the interaction surface.)

| Event | Condition | Effect |
|---|---|---|
| **Esc** key | `InputEventKey` pressed | `get_tree().quit()` |
| **Left button press** | `MOUSE_BUTTON_LEFT` pressed | starts dragging (`dragging`) |
| **Left button release (no move, on eye)** | `!moved` + eye hit-test | closes that eye (`eye_closed_l/r`) until the cursor leaves |
| **Left button release (no move, off eye)** | `!moved` | `_react()` (petting) |
| **Left button release (moved)** | `moved` | `_save_settings()` |
| **Movement while dragging** | `dragging` | moves the window (clamped) + updates `anchor` |
| **Right button** | `MOUSE_BUTTON_RIGHT` pressed | opens the menu via `_context_menu_position()` — next to the pet, without covering it and within the screen |

## 🖱️ Reactions sampled in `_process` (global cursor)
- **Hover** — when the cursor **enters** the pet's rectangle (not dragging/no speech), it
  fires a reaction (`HOVER_EXPRS`: happy/excited) for ~1.1s.
- **Shake** — fast X-direction reversals of the mouse near the pet
  (`SHAKE_MIN_SPEED`/`SHAKE_REVERSALS`/`SHAKE_WINDOW`/`SHAKE_RADIUS`, cooldown `SHAKE_COOLDOWN`)
  call `_trigger_shake()` → dizzy/nauseous/scared.
- **Reopen eye** — each frame, if the cursor left a closed eye, it reopens.

Details: [[🖱️ Fluxo - Arrastar e Posição (EN)]], [[🧭 Sistema - Menu de Contexto (EN)]],
[[✨ Sistema - Animação (EN)]], [[😶‍🌫️ Sistema - Expressões Faciais (EN)]], [[🚪 Entrada - Funções de Ação (EN)]].
