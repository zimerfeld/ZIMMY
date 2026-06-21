---
tags: [fluxo, input, janela, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🖱️ Flow - Dragging and Position

Move the window and remember where the pet was left. Logic in `_input()`
([[Entrada - Eventos de Input (EN)]]) + persistence ([[Sistema - Persistência (EN)]]).

## Dragging
- **Left button press**: `dragging=true`, `moved=false`, stores `drag_offset`.
- **Movement while `dragging`**: if it moved >1px, sets `moved=true`; computes
  `pos = mouse - drag_offset` and **clamps it to the screen** (the entire window, including
  the `HOP_HEADROOM`) — it never leaves the bounds. Updates `anchor = pos + (win_w/2, win_h)`.
- **Release**: if it did **not** move → `_react()` (quick petting); if it moved →
  `_save_settings()`.

## Anchor (bottom-center)
`anchor` is the fixed point on the screen. Everything (relayout, opening, drag) derives the
window position from it, so the pet doesn't "jump" when speaking/resizing.
See [[Sistema - Janela Overlay (EN)]].

## Saved position
- `_save_settings()` (formerly `_save_window_pos`) writes `{anchor_x, anchor_y, pet, acc,
  show_acc}` to `settings.json` — position **+ active choice** ([[Sistema - Persistência (EN)]]).
- `_load_window_pos()` reads it on startup ([[Fluxo - Inicialização (EN)]]).
- **1st run** (no file): centers the pet's body on the screen.
