---
tags: [sistema, animacao, zimmy-pet]
atualizado: 2026-06-24
lang: en
---

# ✨ System - Animation

Procedural animations played in the [[Fluxo - Loop (_process) (EN)]] and applied in
the [[Sistema - Render (_draw) (EN)]].

## Breathing
`bob += delta * 2.2`; in `_draw`, `br = sin(bob) * 0.025` modulates the height of the
body/belly.

## Jump ("hop")
- The pet **does a little hop** when interacted with. `hop(force=320)` is
  `func hop(force := 320.0) -> void: vy = -force`, called by
  `feed`/`pet`/`play`/`_react` and by the alarm (`alarme.gd`).
- The "gravity" in `_process` (`y_off += vy*delta; vy += 900*delta; ...`) is active and
  produces the jump: `vy` gets the negative impulse and gravity brings the pet back to the
  ground. The pet can also be **dragged** by the user (left button — see
  [[Fluxo - Arrastar e Posição (EN)]]).
- The `HOP_HEADROOM=80` in the [[Sistema - Janela Overlay (EN)]] reserves the space above
  the pet so the jump is not clipped.

## Per-action reaction animations (`ACTION_ANIMS`)
- Each **distinct menu action** triggers a **randomly chosen** animation (`pick_random`)
  from a pool matched to that action's "energy" — previously there was only the little
  hop. Dispatch in `play_action_anim(action)` → `play_anim(name)`.
- Repertoire (`play_anim`): `hop`, `double_hop`, `triple_hop`, `spin`, `spin_jump`,
  `backflip`, `wiggle`, `nod`, `squish`, `tilt`, `dance` — physics hops (via `hop`/the
  `hop_queue`) combined with rotation / squash-stretch / sway computed per-phase in
  `_draw` while `anim != ""`.
- `ACTION_ANIMS` map: `feed` (contained joy: hop/nod/wiggle/squish); `pet`
  (melts/sways: nod/wiggle/tilt/squish); `play` (high energy: double/triple hop,
  spin_jump, backflip, dance); `react` (clicking the pet: hop/wiggle/spin/tilt); `newpet`
  ("ta-da": spin/spin_jump/dance); `newacc` (spin/wiggle/nod); `choose` (saved
  pet/accessory: hop/spin/tilt); `save` (save/rename/notes: nod/hop); `sad` (deleting:
  squish/tilt); `happy` (generic celebration: hop/spin/dance).
- The **shadow stays grounded** (drawn before the animated transform) and the status bars
  are unaffected. See [[Sistema - Render (_draw) (EN)]].

## Blink
`blink_timer` counts down to the blink; `blink_t=0.16s` keeps the eyes closed; random
interval `randf_range(2.0, 5.0)`.

## Eyes follow the cursor
`pupil_off = (mouse - pet_center).limit_length(120)/120 * 3.5`. The center uses
`pet_x/pet_y + PET_DRAW/2` in the window's global position.

## Needs (mood/hunger)
`hunger` rises over time (`+0.7/s`); above 70 it drives `happy` down (`-0.5/s`). `happy`
changes the curve of the mouth (`smile`). See also [[Sistema - Interação e Mau Humor (EN)]].
