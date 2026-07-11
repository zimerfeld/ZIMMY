---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, overlay, zimmy-pet]
---

# 🪟 Sistema - Ventana Overlay

> 🇧🇷 Lee esta página en portugués → [[🪟 Sistema - Janela Overlay]]
> 🇺🇸 Read this page in English → [[🪟 Sistema - Janela Overlay (EN)]]

La "magia": una ventana **transparente, sin bordes, siempre encima** que flota sobre
el escritorio y se redimensiona dinámicamente.

## ⚙️ Configuración (estática)
En [[📄 project.godot (ES)]] `[display]`: `borderless`, `always_on_top`, `transparent`,
`per_pixel_transparency/allowed`. `[rendering]`: `gl_compatibility` +
`viewport/transparent_background`. `[application]`: `boot_splash/show_image=false` +
`boot_splash/bg_color=Color(0,0,0,0)` para **no mostrar el logo de Godot** en la apertura.

## 🔄 Refuerzo en runtime ([[🟢 Fluxo - Inicialização (ES)]])
```gdscript
get_tree().root.gui_embed_subwindows = false   # menu/diálogo como janelas nativas
get_tree().root.transparent_bg = true
get_window().set_flag(Window.FLAG_TRANSPARENT, true)
RenderingServer.set_default_clear_color(Color(0,0,0,0))
```
En el `.exe` la ventana puede iniciar opaca; por eso la flag + clear color se refuerzan.

## 📐 Layout dinámico — `_relayout()` (`zimmy.gd:546`)
La ventana tiene el **pet al fondo** y una franja transparente encima:
- `PET_DRAW = 150` (= `PET_BOX * PET_SCALE`, pet 25% más pequeño) — ver [[🎨 Sistema - Render (_draw) (ES)]].
- `HOP_HEADROOM = 80` — franja transparente reservada encima del pet para que el salto no se
  corte ([[✨ Sistema - Animação (ES)]]).
- `top_space = max(franja_del_diálogo + SPEECH_GAP, HOP_HEADROOM)`.
- `win_h = top_space + PET_DRAW`; `pet_y = top_space`;
  `pet_x = (win_w - PET_DRAW)/2` (centrado).
- La ventana está **anclada por el centro-inferior** (`anchor`), así que el pet no se
  desplaza cuando habla. La posición final viene **solo del ancla**, **sin reclampar por el tamaño
  de la ventana** — un globo de diálogo grande puede desbordar hacia el borde de la pantalla, pero el pet
  permanece anclado (ver [[🖱️ Fluxo - Arrastar e Posição (ES)]]).

## 🚧 Limitaciones
- La ventana entera (incluida la franja transparente) captura clics — no hay
  *click-through* (`mouse_passthrough_polygon` es idea de evolución).
- `screen_get_usable_rect()` usa la pantalla actual (multimonitor simplificado).

Relacionado: [[💬 Sistema - Balão de Fala (ES)]], [[🖱️ Fluxo - Arrastar e Posição (ES)]].
