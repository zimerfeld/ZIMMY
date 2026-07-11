---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, interacao, zimmy-pet]
---

# 😼 Flujo - Interacción y Límites

> 🇧🇷 Lee esta página en portugués → [[😼 Fluxo - Interação e Limites]]
> 🇺🇸 Read this page in English → [[😼 Fluxo - Interação e Limites (EN)]]

Cómo un clic/acción se convierte (o no) en una reacción. Reglas en
[[😤 Sistema - Interação e Mau Humor (ES)]].

## 🛤️ Recorrido de una acción
1. Origen: clic en el pet (`_react`) o elemento de menú (`feed`/`pet`/`play`) —
   ver [[🚪 Entrada - Funções de Ação (ES)]].
2. La acción llama a `_can_act("<nombre>")` antes de cualquier efecto.
3. `_can_act` decide:
   - `action_cd>0` (menos de 1s desde la última):
     - misma acción → `_complain()` (mal humor) y devuelve `false`;
     - acción diferente → devuelve `false` en silencio.
   - misma acción ya repetida `MAX_REPEAT=3`x (sin spam) → `false` en silencio.
   - si no: actualiza `last_action`/`action_repeats`, arma `action_cd=1.0` y
     `repeat_reset_cd=REPEAT_RESET=30`, devuelve `true`.
4. Si es `true`: aplica el efecto (humor/hambre), llama a `hop(...)` (el pet **salta** — ver
   [[✨ Sistema - Animação (ES)]]) y `say(...)`.
5. **Liberación por tiempo**: 30s sin una nueva acción aceptada (`repeat_reset_cd`→0 en el
   [[🔁 Fluxo - Loop (_process) (ES)]]) pone a cero `action_repeats`/`last_action` — el bloqueo de 3x se suelta.

## ✨ Efectos por acción
La columna `hop` indica la fuerza que se pasa a `hop()` (el impulso del salto, `vy = -force`).

| Acción | happy | hunger | hop |
|---|---|---|---|
| `feed` | +8 | −25 | 320 |
| `pet` | +15 | — | 220 |
| `play` | +12 | +10 | 420 |
| `_react` (clic) | +5 | — | 320 |
| `_complain` | −6 | — | — |

Animación (`hop` activo): [[✨ Sistema - Animação (ES)]]. Habla: [[💬 Sistema - Balão de Fala (ES)]].
