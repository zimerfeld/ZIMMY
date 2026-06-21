---
tags: [sistema, animacao, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# ✨ System - Animation

Procedural animations played in the [[Fluxo - Loop (_process) (EN)]] and applied in
the [[Sistema - Render (_draw) (EN)]].

## Breathing
`bob += delta * 2.2`; in `_draw`, `br = sin(bob) * 0.025` modulates the height of the
body/belly.

## Jump ("hop") with gravity
- `hop(force=320)` sets `vy = -force`.
- In `_process`: `y_off += vy*delta; vy += 900*delta;` and locks at `y_off=0` on the ground.
- Forces per action: click/`_react`/`feed` = 320, `pet` = 220, `play` = 420.
- Maximum height of `play` ≈ 98 logical px → motivated the `HOP_HEADROOM=80` in the
  [[Sistema - Janela Overlay (EN)]] so it does not get clipped.

## Blink
`blink_timer` counts down to the blink; `blink_t=0.16s` keeps the eyes closed; random
interval `randf_range(2.0, 5.0)`.

## Eyes follow the cursor
`pupil_off = (mouse - pet_center).limit_length(120)/120 * 3.5`. The center uses
`pet_x/pet_y + PET_DRAW/2` in the window's global position.

## Needs (mood/hunger)
`hunger` rises over time (`+0.7/s`); above 70 it drives `happy` down (`-0.5/s`). `happy`
changes the curve of the mouth (`smile`). See also [[Sistema - Interação e Mau Humor (EN)]].
