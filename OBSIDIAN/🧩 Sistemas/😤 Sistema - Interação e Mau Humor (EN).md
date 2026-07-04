---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, interacao, gameplay, zimmy-pet]
---

# 😤 System - Interaction and Bad Mood

Limits interaction spam and gives the pet personality. Centralized in
`_can_act(action)` (`zimmy.gd:846`), called at the start of each action
([[🚪 Entrada - Funções de Ação (EN)]]).

## 📏 Rules
1. **Max. 1 action/click per second** — `action_cd` (= `ACTION_COOLDOWN=1.0`),
   decremented in the [[🔁 Fluxo - Loop (_process) (EN)]].
2. **The same action at most 3x in a row** — `last_action` + `action_repeats`
   (`MAX_REPEAT=3`). A **different** action resets the count. The lock also **releases on
   its own after `REPEAT_RESET=30s`** with no new accepted action: `repeat_reset_cd`
   (refreshed on every accepted action in `_can_act`) is decremented in the
   [[🔁 Fluxo - Loop (_process) (EN)]] and, when it hits 0, resets
   `action_repeats`/`last_action` — the same action works again and re-counts up to 3.
3. **Insisting on the same action in <1s → complaint** — if `action_cd>0` and the action
   is the same, it calls `_complain()`.

## 😤 `_complain()` (`zimmy.gd:864`)
Expresses **disgust / anger / sadness / indifference / dismissiveness** (random sentence
from `ta("mood_neg")` (localized), e.g.: "para com isso! 😠"/"stop it! 😠", reduces `happy`
by 6 and respects its own cooldown `complain_cd` (`COMPLAIN_COOLDOWN=1.5`) so it does
not spam speech. The sentence's emoji also **makes the face** angry/disgusted/sad/
indifferent — see [[😶‍🌫️ Sistema - Expressões Faciais (EN)]].

## 🧮 Decision table (same action)
| Situation | Result |
|---|---|
| 1st–3rd time, ≥1s apart | executes |
| repeats <1s (insistence) | blocks + `_complain()` |
| 4th+ time, ≥1s, no spam | blocks silently |
| different action | resets counter and executes |
| 30s without repeating (same action) | lock releases, re-counts from zero |

> Only the pet/feed/play/click actions go through here. Switching pet/
> accessory and opening the menu are **not** limited.

Flow detail in [[😼 Fluxo - Interação e Limites (EN)]].
