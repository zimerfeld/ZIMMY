---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [endpoint, input, zimmy-pet]
---

# 🚪 Entrada - Eventos de Input

> 🇪🇸 Lee esta página en español → [[🚪 Entrada - Eventos de Input (ES)]]

A "API" de entrada do overlay. Passa por `_input(event)` **e** por amostragem do cursor
global no [[🔁 Fluxo - Loop (_process)]] (hover/sacudida funcionam mesmo sem foco/eventos).
(Não há endpoints de rede — é um app desktop; estes eventos são a superfície de interação.)

| Evento | Condição | Efeito |
|---|---|---|
| Tecla **Esc** | `InputEventKey` pressed | `get_tree().quit()` |
| **Botão esq. pressiona** | `MOUSE_BUTTON_LEFT` pressed | inicia arrasto (`dragging`) |
| **Botão esq. solta (sem mover, no olho)** | `!moved` + hit-test no olho | fecha aquele olho (`eye_closed_l/r`) até o cursor sair |
| **Botão esq. solta (sem mover, fora do olho)** | `!moved` | `_react()` (carinho) |
| **Botão esq. solta (moveu)** | `moved` | `_save_settings()` |
| **Movimento c/ arrasto** | `dragging` | move janela (clampada) + atualiza `anchor` |
| **Botão direito** | `MOUSE_BUTTON_RIGHT` pressed | abre o menu via `_context_menu_position()` — ao lado do pet, sem cobri-lo e dentro da tela |

## 🖱️ Reações amostradas no `_process` (cursor global)
- **Hover** — ao o cursor **entrar** sobre o retângulo do pet (sem arrastar/sem fala),
  dispara uma reação (`HOVER_EXPRS`: happy/excited) por ~1,1s.
- **Sacudida** — reversões rápidas de direção X do mouse perto do pet
  (`SHAKE_MIN_SPEED`/`SHAKE_REVERSALS`/`SHAKE_WINDOW`/`SHAKE_RADIUS`, respiro `SHAKE_COOLDOWN`)
  chamam `_trigger_shake()` → tontura/enjoo/susto.
- **Reabrir olho** — a cada frame, se o cursor saiu do olho fechado, ele reabre.

Detalhes: [[🖱️ Fluxo - Arrastar e Posição]], [[🧭 Sistema - Menu de Contexto]],
[[✨ Sistema - Animação]], [[😶‍🌫️ Sistema - Expressões Faciais]], [[🚪 Entrada - Funções de Ação]].
