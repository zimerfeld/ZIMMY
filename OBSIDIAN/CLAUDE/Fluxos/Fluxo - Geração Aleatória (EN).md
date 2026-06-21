---
tags: [fluxo, geracao, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🎲 Flow - Random Generation

Pet and accessories have **independent** generation, with separate checkboxes and timers.

## Turn on/off
- `_set_random_pet(on)` — marks `MI_RANDOM`, resets `random_pet_timer`; if turning on,
  generates a pet right away (`current = _random_cfg()`) and speaks.
- `_set_random_acc(on)` — marks `MI_RANDOM_ACC`, resets `random_acc_timer`; if turning on,
  generates an accessory (`current_acc = _random_acc()`) **and turns on the display**
  (`_set_show_accessories(true)`).

## Continuous generation (in the [[Fluxo - Loop (_process) (EN)]])
Every `RANDOM_PERIOD = 9s`, if enabled, swaps `current`/`current_acc` and speaks
("novo pet! 🎲" / "novos acessórios! 🎲").

## Interactions that turn it off
- Choosing a **pet** in the menu → `_set_random_pet(false)` (pet only).
- Choosing an **accessory** → `_set_random_acc(false)` (accessory only).
- **Save pet** → `_set_random_pet(false)` on open (freezes) and again on
  **confirm** (unchecks "🎲 Gerar pets"); doesn't touch accessory generation.
- **Save accessory** → `_set_random_acc(false)` on open and on confirm (unchecks
  "🎲 Gerar acessórios"); doesn't touch pet generation. See [[Fluxo - Salvar e Carregar (EN)]].
- **Delete** pet/accessory → also turns off the corresponding random mode
  (reloads the Default).

Drawn content: [[Sistema - Pets (EN)]] / [[Sistema - Acessórios (EN)]]. The random pet
draws ~12 **independent** geometric categories beyond the silhouette (tail, horn,
crest, eye, pupil, eyebrow, paws, little arms, mark, whiskers, wings, freckles).
