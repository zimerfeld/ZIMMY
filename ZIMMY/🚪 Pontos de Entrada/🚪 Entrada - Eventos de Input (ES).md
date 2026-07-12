---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [endpoint, input, zimmy-pet]
---

# 🚪 Punto de Entrada - Eventos de Input

> 🇧🇷 Lee esta página en portugués → [[🚪 Entrada - Eventos de Input]]
> 🇺🇸 Read this page in English → [[🚪 Entrada - Eventos de Input (EN)]]

La "API" de entrada del overlay. Pasa por `_input(event)` **y** por muestreo del cursor
global en el [[🔁 Fluxo - Loop (_process) (ES)]] (hover/sacudida funcionan incluso sin foco/eventos).
(No hay endpoints de red — es una app de escritorio; estos eventos son la superficie de interacción.)

| Evento | Condición | Efecto |
|---|---|---|
| Tecla **Esc** | `InputEventKey` pressed | `get_tree().quit()` |
| **Botón izq. pulsa** | `MOUSE_BUTTON_LEFT` pressed | inicia el arrastre (`dragging`) |
| **Botón izq. suelta (sin mover, en el ojo)** | `!moved` + hit-test en el ojo | cierra ese ojo (`eye_closed_l/r`) hasta que el cursor salga |
| **Botón izq. suelta (sin mover, fuera del ojo)** | `!moved` | `_react()` (caricia) |
| **Botón izq. suelta (movió)** | `moved` | `_save_settings()` |
| **Movimiento con arrastre** | `dragging` | mueve la ventana (limitada) + actualiza `anchor` |
| **Botón derecho** | `MOUSE_BUTTON_RIGHT` pressed | abre el menú mediante `_context_menu_position()` — al lado del pet, sin cubrirlo y dentro de la pantalla |

## 🖱️ Reacciones muestreadas en `_process` (cursor global)
- **Hover** — cuando el cursor **entra** sobre el rectángulo del pet (sin arrastrar/sin habla),
  dispara una reacción (`HOVER_EXPRS`: happy/excited) durante ~1,1s.
- **Sacudida** — inversiones rápidas de dirección X del ratón cerca del pet
  (`SHAKE_MIN_SPEED`/`SHAKE_REVERSALS`/`SHAKE_WINDOW`/`SHAKE_RADIUS`, respiro `SHAKE_COOLDOWN`)
  llaman a `_trigger_shake()` → mareo/náusea/susto.
- **Reabrir el ojo** — en cada frame, si el cursor salió del ojo cerrado, este se reabre.

Detalles: [[🖱️ Fluxo - Arrastar e Posição (ES)]], [[🧭 Sistema - Menu de Contexto (ES)]],
[[✨ Sistema - Animação (ES)]], [[😶‍🌫️ Sistema - Expressões Faciais (ES)]], [[🚪 Entrada - Funções de Ação (ES)]].
