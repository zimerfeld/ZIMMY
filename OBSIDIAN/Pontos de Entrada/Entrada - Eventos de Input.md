---
tags: [endpoint, input, zimmy-pet]
atualizado: 2026-06-21
---

# 🚪 Entrada - Eventos de Input

A "API" de entrada do overlay. Tudo passa por `_input(event)` (`zimmy.gd:809`).
(Não há endpoints de rede — é um app desktop; estes eventos são a superfície de
interação.)

| Evento | Condição | Efeito |
|---|---|---|
| Tecla **Esc** | `InputEventKey` pressed | `get_tree().quit()` |
| **Botão esq. pressiona** | `MOUSE_BUTTON_LEFT` pressed | inicia arrasto (`dragging`) |
| **Botão esq. solta (sem mover)** | `!moved` | `_react()` (carinho) |
| **Botão esq. solta (moveu)** | `moved` | `_save_settings()` |
| **Movimento c/ arrasto** | `dragging` | move janela (clampada) + atualiza `anchor` |
| **Botão direito** | `MOUSE_BUTTON_RIGHT` pressed | abre o menu via `_context_menu_position()` — ao lado do pet, sem cobri-lo e dentro da tela |

Detalhes: [[Fluxo - Arrastar e Posição]], [[Sistema - Menu de Contexto]],
[[Entrada - Funções de Ação]].
