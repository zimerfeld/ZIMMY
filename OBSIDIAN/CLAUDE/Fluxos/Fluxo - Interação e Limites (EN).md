---
tags: [fluxo, interacao, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 😼 Flow - Interaction and Limits

How a click/action turns (or doesn't) into a reaction. Rules in
[[Sistema - Interação e Mau Humor (EN)]].

## Path of an action
1. Origin: click on the pet (`_react`) or menu item (`feed`/`pet`/`play`) —
   see [[Entrada - Funções de Ação (EN)]].
2. The action calls `_can_act("<name>")` before any effect.
3. `_can_act` decides:
   - `action_cd>0` (less than 1s since the last one):
     - same action → `_complain()` (bad mood) and returns `false`;
     - different action → returns `false` silently.
   - same action already repeated `MAX_REPEAT=3`x (no spam) → `false` silently.
   - otherwise: updates `last_action`/`action_repeats`, arms `action_cd=1.0`,
     returns `true`.
4. If `true`: applies the effect (mood/hunger), `say(...)` and `hop(...)`.

## Effects per action
| Action | happy | hunger | hop |
|---|---|---|---|
| `feed` | +8 | −25 | 320 |
| `pet` | +15 | — | 220 |
| `play` | +12 | +10 | 420 |
| `_react` (click) | +5 | — | 320 |
| `_complain` | −6 | — | — |

Jump animation: [[Sistema - Animação (EN)]]. Speech: [[Sistema - Balão de Fala (EN)]].
