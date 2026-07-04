---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, necessidades, gameplay, zimmy-pet]
---

# 📊 System - Needs (Feed/Pet/Play)

Three tamagotchi-style needs, shown as **subtle bars at the bottom** of the pet. State in
`stat_feed` / `stat_pet` / `stat_play` (0..100, `STAT_MAX=100`). **Not persisted**: they
start full (100%) on every launch.

## 📊 Bars — `_draw_stat_bars()`
Drawn in a **reserved footer below the pet** (`STATUS_FOOTER=58px`, added to `win_h` in
`_relayout` only when `show_status`). `_draw_stat_bars()` resets the transform to
**identity** (real px — no `PET_SCALE` and no hop `y_off`) and stacks 3 rows (`row_h=16`, bar
`bh=8`): track `Color(0,0,0,0.18)` + colored fill with width = `bw * stat/100` (no
numbers). The **icon+bar group is the pet's width** (`PET_DRAW`) and **centered under it**
(from `pet_x`) — it does **not** stretch with the speech bubble. Each bar has its **menu icon on the left** (🦴/🤚/🎾, `icon_fs=17` ≈ 2× the
previous) via `draw_string` with `speech.get_theme_font("font")`:
- Feed → `COL_FEED` (white), Pet → `COL_PET` (yellow), Play → `COL_PLAY` (reddish pink).
The pet stays **anchored by its bottom-center** (the footer grows downward, not moving the
pet). Only when `show_status` (the **📊 Status** checkbox, above Feed; **OFF by default**,
persisted in settings.json `status` via `_set_show_status` → `_relayout`). See
[[🎨 Sistema - Render (_draw) (EN)]] and [[🧭 Sistema - Menu de Contexto (EN)]].

## 📉 Decay and shutdown — `_process`
Every `STAT_DECAY_PERIOD = 1800s` (30 min) each bar loses **1 point**
(`stat_decay_timer`). Doing the matching action refills **only that** bar to 100
(`feed()`/`pet()`/`play()` in [[🚪 Entrada - Funções de Ação (EN)]]). When **all three** hit
zero, `get_tree().quit()` **closes the window and ends the process**.

**Low-need sound alert**: still in the decay step, when a bar **crosses `STAT_LOW = 20`
going down** (only on the **transition** — it stores the previous value and compares, so it
plays once per crossing, not every cycle below the threshold), Zimmy plays that action's
sound (`_feed_player`/`_pet_player`/`_play_player`), as long as the matching toggle is on
(`sound_feed_on`/`sound_pet_on`/`sound_play_on`). It is **the same sound** played when you do
the action; the **🔊 Sound alerts** submenu (`MI_SOUNDS`) controls both triggers. See
[[🧭 Sistema - Menu de Contexto (EN)]] and [[🚪 Entrada - Funções de Ação (EN)]].

## 😖 Need face — `_need_expression()`
With no speech, if a bar is at 0 the face changes (priority hungry > needy > bored), via
`_draw_expression` ([[😶‍🌫️ Sistema - Expressões Faciais (EN)]]):
- `stat_feed=0` → **hungry**: hungry face, **wide-open mouth** + little tongue.
- `stat_pet=0` → **needy**: needy face, **crying** (two tears) + sad mouth.
- `stat_play=0` → **bored**: bored face, **closed eyes** (—) + straight mouth.

> Speech (an emotive emoji) still takes priority over the need face.

Related: [[😤 Sistema - Interação e Mau Humor (EN)]], [[🔁 Fluxo - Loop (_process) (EN)]].
