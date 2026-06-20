---
tags: [fluxo, input, janela, zimmy-pet]
atualizado: 2026-06-20
---

# 🖱️ Fluxo - Arrastar e Posição

Mover a janela e lembrar onde o pet ficou. Lógica em `_input()`
([[Entrada - Eventos de Input]]) + persistência ([[Sistema - Persistência]]).

## Arrastar
- **Botão esquerdo pressiona**: `dragging=true`, `moved=false`, guarda `drag_offset`.
- **Movimento com `dragging`**: se moveu >1px marca `moved=true`; calcula
  `pos = mouse - drag_offset` e **clampa à tela** (a janela inteira, incluindo o
  `HOP_HEADROOM`) — não sai dos limites. Atualiza `anchor = pos + (win_w/2, win_h)`.
- **Solta**: se **não** moveu → `_react()` (carinho rápido); se moveu →
  `_save_window_pos()`.

## Âncora (centro-inferior)
`anchor` é o ponto fixo na tela. Tudo (relayout, abertura, drag) deriva a posição da
janela a partir dele, então o pet não "pula" ao falar/redimensionar.
Ver [[Sistema - Janela Overlay]].

## Posição salva
- `_save_window_pos()` grava `{anchor_x, anchor_y}` em `settings.json`.
- `_load_window_pos()` lê na inicialização ([[Fluxo - Inicialização]]).
- **1ª execução** (sem arquivo): centraliza o corpo do pet na tela.
