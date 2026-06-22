---
tags: [fluxo, ciclo-de-vida, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 🔁 Flow - Loop (`_process`)

`_process(delta)` (`zimmy.gd:483`) runs every frame, in order:

1. **Breathing** — `bob += delta*2.2` ([[Sistema - Animação (EN)]]).
2. **Cooldowns** — decrements `action_cd` and `complain_cd`
   ([[Sistema - Interação e Mau Humor (EN)]]).
3. **Jump** — integrates `y_off`/`vy` with gravity 900; locks on the ground.
4. **Blink** — `blink_timer`/`blink_t`.
5. **Eyes follow the cursor** — computes `pupil_off` from the pet's real center.
6. **Continuous random generation** — a single `random_timer` (period `RANDOM_PERIOD=10s`)
   for pet and accessory; with both on, they switch together ([[Fluxo - Geração Aleatória (EN)]]).
7. **Automation scheduler** — `_tick_schedules(delta)` triggers the enabled scheduled
   automations according to their frequency ([[Sistema - Menu de Contexto (EN)]]).
8. **Needs** — `hunger` rises; if >70, `happy` drops.
9. **Need bars** — `stat_decay_timer`; every `STAT_DECAY_PERIOD=1800s` (30 min) each bar
   (`stat_feed`/`stat_pet`/`stat_play`) drops 1; with all three at 0, `get_tree().quit()`
   ([[Sistema - Necessidades (EN)]]).
10. **Repeat lock** — `repeat_reset_cd` (releases the 3x lock after 30s; see
    [[Sistema - Interação e Mau Humor (EN)]]).
11. **Clears speech** — when `speech_clear` expires, it clears and runs `_relayout()`
    ([[Sistema - Balão de Fala (EN)]]).
12. **`queue_redraw()`** — schedules the [[Sistema - Render (_draw) (EN)]].
