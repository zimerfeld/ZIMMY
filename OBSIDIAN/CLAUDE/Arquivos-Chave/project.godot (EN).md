---
tags: [arquivo, config, zimmy-pet]
caminho: project.godot
atualizado: 2026-06-21
lang: en
---

# 📄 project.godot

Godot project config. `config/features = "4.6"`. Initial scene:
`run/main_scene = "res://main.tscn"` ([[main.tscn (EN)]]). Editor icon:
`res://icon.png`.

## `[application]` — boot splash
```ini
boot_splash/show_image=false          # hides the Godot logo at startup
boot_splash/bg_color=Color(0, 0, 0, 0) # transparent splash background
```
Without this, the **Godot logo** would flash for a moment when the `.exe` starts.

## `[display]` — the overlay secret
```ini
window/size/viewport_width=200
window/size/viewport_height=200
window/size/borderless=true
window/size/always_on_top=true
window/size/transparent=true
window/per_pixel_transparency/allowed=true
```

## `[rendering]`
```ini
renderer/rendering_method="gl_compatibility"        # OpenGL (required for transparency)
renderer/rendering_method.mobile="gl_compatibility"
viewport/transparent_background=true
```

> ⚠️ Per-pixel transparency **only** works with the **Compatibility** renderer; with
> Forward+ the exported window shows a black square. 2D MSAA must also be
> turned off. Details in [[Sistema - Janela Overlay (EN)]].

`zimmy.gd:_ready()` also reinforces the flags at runtime — see [[Fluxo - Inicialização (EN)]].
