---
tipo: fluxo
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [fluxo, input, janela, zimmy-pet]
---

# 🖱️ Fluxo - Arrastar e Posição

Mover a janela e lembrar onde o pet ficou. Lógica em `_input()`
([[🚪 Entrada - Eventos de Input]]) + persistência ([[💾 Sistema - Persistência]]).

> **Modo de reposicionar o pet.** O pet dá um pulinho ao interagir (`hop()` — ver
> [[✨ Sistema - Animação]]), mas arrastar com o botão esquerdo é a forma de reposicioná-lo
> de fato. O pet fica **ancorado** (não se desloca) quando o balão de fala é grande e
> excede a janela — ver Âncora abaixo.

## 🖱️ Arrastar
- **Botão esquerdo pressiona**: `dragging=true`, `moved=false`, guarda `drag_offset`.
- **Movimento com `dragging`**: se moveu >1px marca `moved=true`; calcula
  `pos = mouse - drag_offset` e **clampa à tela** (a janela inteira, incluindo o
  `HOP_HEADROOM`) — não sai dos limites. Atualiza `anchor = pos + (win_w/2, win_h)`.
- **Solta**: se **não** moveu → `_react()` (carinho rápido); se moveu →
  `_save_settings()`.

## ⚓ Âncora (centro-inferior)
`anchor` é o ponto fixo na tela. Tudo (relayout, abertura, drag) deriva a posição da
janela a partir dele, então o pet não se desloca ao falar/redimensionar. Em `_relayout()`
a posição da janela vem **só** da âncora, **sem reclampar pelo tamanho da janela** — então
um balão de fala **grande** pode transbordar para a borda da tela, mas o **pet não se
move** (continua ancorado). A âncora em si é mantida dentro da tela ao **arrastar**
(`_input`) e ao **carregar** (`_ready`). Ver [[🪟 Sistema - Janela Overlay]].

## 📍 Posição salva
- `_save_settings()` (antigo `_save_window_pos`) grava `{anchor_x, anchor_y, pet, acc,
  show_acc}` em `settings.json` — posição **+ escolha ativa** ([[💾 Sistema - Persistência]]).
- `_load_window_pos()` lê na inicialização ([[🟢 Fluxo - Inicialização]]).
- **1ª execução** (sem arquivo): centraliza o corpo do pet na tela.
