---
tags: [sistema, interacao, gameplay, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 😤 System - Interaction and Bad Mood

Limits interaction spam and gives the pet personality. Centralized in
`_can_act(action)` (`zimmy.gd:846`), called at the start of each action
([[Entrada - Funções de Ação (EN)]]).

## Rules
1. **Max. 1 action/click per second** — `action_cd` (= `ACTION_COOLDOWN=1.0`),
   decremented in the [[Fluxo - Loop (_process) (EN)]].
2. **The same action at most 3x in a row** — `last_action` + `action_repeats`
   (`MAX_REPEAT=3`). A **different** action resets the count.
3. **Insisting on the same action in <1s → complaint** — if `action_cd>0` and the action
   is the same, it calls `_complain()`.

## `_complain()` (`zimmy.gd:864`)
Expresses **disgust / anger / sadness / indifference / dismissiveness** (random sentence
from `MOOD_NEG`, e.g.: "para com isso! 😠", "tanto faz 😑", "...zzz 😴"), reduces `happy`
by 6 and respects its own cooldown `complain_cd` (`COMPLAIN_COOLDOWN=1.5`) so it does
not spam speech. The sentence's emoji also **makes the face** angry/disgusted/sad/
indifferent — see [[Sistema - Expressões Faciais (EN)]].

## Decision table (same action)
| Situation | Result |
|---|---|
| 1st–3rd time, ≥1s apart | executes |
| repeats <1s (insistence) | blocks + `_complain()` |
| 4th+ time, ≥1s, no spam | blocks silently |
| different action | resets counter and executes |

> Only the pet/feed/play/click actions go through here. Switching pet/
> accessory and opening the menu are **not** limited.

Flow detail in [[Fluxo - Interação e Limites (EN)]].
