---
tags: [endpoint, input, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🚪 Entry Point - Input Events

The overlay's input "API". Everything goes through `_input(event)` (`zimmy.gd:809`).
(There are no network endpoints — it's a desktop app; these events are the interaction
surface.)

| Event | Condition | Effect |
|---|---|---|
| **Esc** key | `InputEventKey` pressed | `get_tree().quit()` |
| **Left button press** | `MOUSE_BUTTON_LEFT` pressed | starts dragging (`dragging`) |
| **Left button release (no move)** | `!moved` | `_react()` (petting) |
| **Left button release (moved)** | `moved` | `_save_settings()` |
| **Movement while dragging** | `dragging` | moves the window (clamped) + updates `anchor` |
| **Right button** | `MOUSE_BUTTON_RIGHT` pressed | opens the menu via `_context_menu_position()` — next to the pet, without covering it and within the screen |

Details: [[Fluxo - Arrastar e Posição (EN)]], [[Sistema - Menu de Contexto (EN)]],
[[Entrada - Funções de Ação (EN)]].
