---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, input, janela, zimmy-pet]
---

# 🖱️ Flujo - Arrastrar y Posición

> 🇧🇷 Lee esta página en portugués → [[🖱️ Fluxo - Arrastar e Posição]]
> 🇺🇸 Read this page in English → [[🖱️ Fluxo - Arrastar e Posição (EN)]]

Mover la ventana y recordar dónde se quedó el pet. Lógica en `_input()`
([[🚪 Entrada - Eventos de Input (ES)]]) + persistencia ([[💾 Sistema - Persistência (ES)]]).

> **Modo de reposicionar el pet.** El pet da un saltito al interactuar (`hop()` — ver
> [[✨ Sistema - Animação (ES)]]), pero arrastrar con el botón izquierdo es la forma de reposicionarlo
> de verdad. El pet queda **anclado** (no se desplaza) cuando el globo de diálogo es grande y
> excede la ventana — ver Ancla más abajo.

## 🖱️ Arrastrar
- **El botón izquierdo pulsa**: `dragging=true`, `moved=false`, guarda `drag_offset`.
- **Movimiento con `dragging`**: si se movió >1px marca `moved=true`; calcula
  `pos = mouse - drag_offset` y **lo limita a la pantalla** (la ventana entera, incluido el
  `HOP_HEADROOM`) — no sale de los límites. Actualiza `anchor = pos + (win_w/2, win_h)`.
- **Soltar**: si **no** se movió → `_react()` (caricia rápida); si se movió →
  `_save_settings()`.

## ⚓ Ancla (centro-inferior)
`anchor` es el punto fijo en la pantalla. Todo (relayout, apertura, arrastre) deriva la posición de
la ventana a partir de él, así que el pet no se desplaza al hablar/redimensionar. En `_relayout()`
la posición de la ventana viene **solo** del ancla, **sin volver a limitarla por el tamaño de la
ventana** — así que un globo de diálogo **grande** puede desbordar hacia el borde de la pantalla,
pero el **pet no se mueve** (sigue anclado). El ancla en sí se mantiene dentro de la pantalla al
**arrastrar** (`_input`) y al **cargar** (`_ready`). Ver [[🪟 Sistema - Janela Overlay (ES)]].

## 📍 Posición guardada
- `_save_settings()` (antiguo `_save_window_pos`) escribe `{anchor_x, anchor_y, pet, acc,
  show_acc}` en `settings.json` — posición **+ elección activa** ([[💾 Sistema - Persistência (ES)]]).
- `_load_window_pos()` lo lee en la inicialización ([[🟢 Fluxo - Inicialização (ES)]]).
- **1ª ejecución** (sin archivo): centra el cuerpo del pet en la pantalla.
