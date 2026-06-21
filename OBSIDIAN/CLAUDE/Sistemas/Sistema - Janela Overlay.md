---
tags: [sistema, overlay, zimmy-pet]
atualizado: 2026-06-21
---

# 🪟 Sistema - Janela Overlay

A "mágica": uma janela **transparente, sem bordas, sempre no topo** que flutua sobre
a área de trabalho e se redimensiona dinamicamente.

## Configuração (estática)
Em [[project.godot]] `[display]`: `borderless`, `always_on_top`, `transparent`,
`per_pixel_transparency/allowed`. `[rendering]`: `gl_compatibility` +
`viewport/transparent_background`. `[application]`: `boot_splash/show_image=false` +
`boot_splash/bg_color=Color(0,0,0,0)` para **não exibir o logo do Godot** na abertura.

## Reforço em runtime ([[Fluxo - Inicialização]])
```gdscript
get_tree().root.gui_embed_subwindows = false   # menu/diálogo como janelas nativas
get_tree().root.transparent_bg = true
get_window().set_flag(Window.FLAG_TRANSPARENT, true)
RenderingServer.set_default_clear_color(Color(0,0,0,0))
```
No `.exe` a janela pode iniciar opaca; por isso a flag + clear color são reforçadas.

## Layout dinâmico — `_relayout()` (`zimmy.gd:546`)
A janela tem o **pet no fundo** e uma faixa transparente acima:
- `PET_DRAW = 150` (= `PET_BOX * PET_SCALE`, pet 25% menor) — ver [[Sistema - Render (_draw)]].
- `HOP_HEADROOM = 80` — espaço acima p/ o pulo não cortar ([[Sistema - Animação]]).
- `top_space = max(faixa_da_fala + SPEECH_GAP, HOP_HEADROOM)`.
- `win_h = top_space + PET_DRAW`; `pet_y = top_space`;
  `pet_x = (win_w - PET_DRAW)/2` (centralizado).
- A janela é **ancorada pelo centro-inferior** (`anchor`), então o pet não se
  desloca quando fala/pula. A posição final é **clampada** à tela.

## Limitações
- A janela inteira (incluindo a faixa transparente) captura cliques — não há
  *click-through* (`mouse_passthrough_polygon` é ideia de evolução).
- `screen_get_usable_rect()` usa a tela atual (multimonitor simplificado).

Relacionado: [[Sistema - Balão de Fala]], [[Fluxo - Arrastar e Posição]].
