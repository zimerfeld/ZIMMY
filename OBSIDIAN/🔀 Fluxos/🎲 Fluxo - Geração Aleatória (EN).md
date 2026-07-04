---
tipo: fluxo
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [fluxo, geracao, zimmy-pet]
---

# 🎲 Flow - Random Generation

Pet and accessories have **independent** checkboxes but share a **single timer**
(`random_timer`): with both on, they switch **together** on the same tick.

## 🔀 Turn on/off
- `_set_random_pet(on)` — marks `MI_RANDOM`, resets the shared `random_timer`; if turning
  on, calls `_generate_pet()`.
- `_set_random_acc(on)` — marks `MI_RANDOM_ACC`, resets the shared `random_timer`; if
  turning on, **turns on the display** (`_set_show_accessories(true)`) and calls `_generate_acc()`.

## 🎲 Generation + suggested name
- `_generate_pet()` — `current = _random_cfg()`, `current_pet_name = ""`, draws a
  **suggestive name** (`suggested_pet_name = _suggest_name("pet")`) and gives a
  **welcome** with it (`say(t("welcome_pet") % name)`).
- `_generate_acc()` — `current_acc = _random_acc()`, `current_acc_name = ""`, draws
  `suggested_acc_name` (`_suggest_name("acc")`) and **congratulates** (`say(t("congrats_acc") % name)`).
- `_suggest_name(kind)` builds a **combinatorial** name: noun + adjective from the
  language banks (`STRING_LISTS["<kind>_nouns"/"<kind>_adjs"]`, kind = `pet`/`acc`). ~900
  combos per category/language (rarely repeats). Order: pt = "Noun Adjective"; en =
  "Adjective Noun". The pt adjectives are gender-invariant (no agreement errors).
- The suggested name **pre-fills** the Save/Rename dialog (see
  [[💾 Fluxo - Salvar e Carregar (EN)]]); choosing a specific item clears the suggestion.

## 🔁 Continuous generation (in the [[🔁 Fluxo - Loop (_process) (EN)]])
A single `random_timer` advances while **pet OR accessory** is on; every
`RANDOM_PERIOD = 10s` it calls `_generate_pet()` and/or `_generate_acc()` (whichever are
on, on the same tick).

## 🚫 Interactions that turn it off
- Choosing a **pet** in the menu → `_set_random_pet(false)` (pet only).
- Choosing an **accessory** → `_set_random_acc(false)` (accessory only).
- **Save pet** → `_set_random_pet(false)` on open (freezes) and again on
  **confirm** (unchecks "🐶 Gerar pets"); doesn't touch accessory generation.
- **Save accessory** → `_set_random_acc(false)` on open and on confirm (unchecks
  "🎲 Gerar acessórios"); doesn't touch pet generation. See [[💾 Fluxo - Salvar e Carregar (EN)]].
- **Delete** pet/accessory → also turns off the corresponding random mode
  (reloads the Default).

Drawn content: [[🐾 Sistema - Pets (EN)]] / [[🎀 Sistema - Acessórios (EN)]]. The random pet
draws ~14 **independent** geometric categories beyond the silhouette; and ~55% of the
time it becomes a recognizable **critter** (`_apply_critter`: cat/dog/bunny/bear/frog/
fox/mouse/pig) — see [[🐾 Sistema - Pets (EN)]].
