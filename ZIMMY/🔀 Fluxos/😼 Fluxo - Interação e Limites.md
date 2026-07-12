---
tipo: fluxo
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [fluxo, interacao, zimmy-pet]
---

# 😼 Fluxo - Interação e Limites

> 🇪🇸 Lee esta página en español → [[😼 Fluxo - Interação e Limites (ES)]]

Como um clique/ação vira (ou não) uma reação. Regras em
[[😤 Sistema - Interação e Mau Humor]].

## 🛤️ Caminho de uma ação
1. Origem: clique no pet (`_react`) ou item de menu (`feed`/`pet`/`play`) —
   ver [[🚪 Entrada - Funções de Ação]].
2. A ação chama `_can_act("<nome>")` antes de qualquer efeito.
3. `_can_act` decide:
   - `action_cd>0` (menos de 1s desde a última):
     - mesma ação → `_complain()` (mau humor) e retorna `false`;
     - ação diferente → retorna `false` em silêncio.
   - mesma ação já repetida `MAX_REPEAT=3`x (sem spam) → `false` em silêncio.
   - senão: atualiza `last_action`/`action_repeats`, arma `action_cd=1.0` e
     `repeat_reset_cd=REPEAT_RESET=30`, retorna `true`.
4. Se `true`: aplica efeito (humor/fome), chama `hop(...)` (o pet **pula** — ver
   [[✨ Sistema - Animação]]) e `say(...)`.
5. **Liberação por tempo**: 30s sem nova ação aceita (`repeat_reset_cd`→0 no
   [[🔁 Fluxo - Loop (_process)]]) zera `action_repeats`/`last_action` — a trava de 3x solta.

## ✨ Efeitos por ação
A coluna `hop` lista a força passada a `hop()` (impulso do pulo, `vy = -force`).

| Ação | happy | hunger | hop |
|---|---|---|---|
| `feed` | +8 | −25 | 320 |
| `pet` | +15 | — | 220 |
| `play` | +12 | +10 | 420 |
| `_react` (clique) | +5 | — | 320 |
| `_complain` | −6 | — | — |

Animação (`hop` ativo): [[✨ Sistema - Animação]]. Fala: [[💬 Sistema - Balão de Fala]].
