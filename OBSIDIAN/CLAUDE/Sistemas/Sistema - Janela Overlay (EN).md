---
tags: [sistema, overlay, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🪟 System - Overlay Window

The "magic": a **transparent, borderless, always-on-top** window that floats over
the desktop and resizes dynamically.

## Configuration (static)
In [[project.godot (EN)]] `[display]`: `borderless`, `always_on_top`, `transparent`,
`per_pixel_transparency/allowed`. `[rendering]`: `gl_compatibility` +
`viewport/transparent_background`. `[application]`: `boot_splash/show_image=false` +
`boot_splash/bg_color=Color(0,0,0,0)` to **not show the Godot logo** on startup.

## Runtime reinforcement ([[Fluxo - Inicialização (EN)]])
```gdscript
get_tree().root.gui_embed_subwindows = false   # menu/dialog as native windows
get_tree().root.transparent_bg = true
get_window().set_flag(Window.FLAG_TRANSPARENT, true)
RenderingServer.set_default_clear_color(Color(0,0,0,0))
```
In the `.exe` the window may start opaque; that is why the flag + clear color are reinforced.

## Dynamic layout — `_relayout()` (`zimmy.gd:546`)
The window has the **pet at the bottom** and a transparent band above:
- `PET_DRAW = 150` (= `PET_BOX * PET_SCALE`, pet 25% smaller) — see [[Sistema - Render (_draw) (EN)]].
- `HOP_HEADROOM = 80` — space above so the jump does not get clipped ([[Sistema - Animação (EN)]]).
- `top_space = max(speech_band + SPEECH_GAP, HOP_HEADROOM)`.
- `win_h = top_space + PET_DRAW`; `pet_y = top_space`;
  `pet_x = (win_w - PET_DRAW)/2` (centered).
- The window is **anchored by its bottom-center** (`anchor`), so the pet does not
  shift when it speaks/jumps. The final position is **clamped** to the screen.

## Limitations
- The whole window (including the transparent band) captures clicks — there is no
  *click-through* (`mouse_passthrough_polygon` is an idea for the future).
- `screen_get_usable_rect()` uses the current screen (simplified multi-monitor).

Related: [[Sistema - Balão de Fala (EN)]], [[Fluxo - Arrastar e Posição (EN)]].
