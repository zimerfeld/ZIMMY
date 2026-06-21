---
tags: [fluxo, interacao, zimmy-pet]
atualizado: 2026-06-20
---

# 😼 Fluxo - Interação e Limites

Como um clique/ação vira (ou não) uma reação. Regras em
[[Sistema - Interação e Mau Humor]].

## Caminho de uma ação
1. Origem: clique no pet (`_react`) ou item de menu (`feed`/`pet`/`play`) —
   ver [[Entrada - Funções de Ação]].
2. A ação chama `_can_act("<nome>")` antes de qualquer efeito.
3. `_can_act` decide:
   - `action_cd>0` (menos de 1s desde a última):
     - mesma ação → `_complain()` (mau humor) e retorna `false`;
     - ação diferente → retorna `false` em silêncio.
   - mesma ação já repetida `MAX_REPEAT=3`x (sem spam) → `false` em silêncio.
   - senão: atualiza `last_action`/`action_repeats`, arma `action_cd=1.0`,
     retorna `true`.
4. Se `true`: aplica efeito (humor/fome), `say(...)` e `hop(...)`.

## Efeitos por ação
| Ação | happy | hunger | hop |
|---|---|---|---|
| `feed` | +8 | −25 | 320 |
| `pet` | +15 | — | 220 |
| `play` | +12 | +10 | 420 |
| `_react` (clique) | +5 | — | 320 |
| `_complain` | −6 | — | — |

Animação do pulo: [[Sistema - Animação]]. Fala: [[Sistema - Balão de Fala]].
