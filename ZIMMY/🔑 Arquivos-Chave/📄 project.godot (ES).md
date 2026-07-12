---
tipo: arquivo-chave
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [arquivo, config, zimmy-pet]
caminho: project.godot
---

# 📄 project.godot

> 🇧🇷 Lee esta página en portugués → [[📄 project.godot]]
> 🇺🇸 Read this page in English → [[📄 project.godot (EN)]]

Configuración del proyecto Godot. `config/features = "4.6"`. Escena inicial:
`run/main_scene = "res://main.tscn"` ([[📄 main.tscn (ES)]]). Icono del editor:
`res://icon.png`.

## 🚀 `[application]` — boot splash
```ini
boot_splash/show_image=false          # esconde o logo do Godot na abertura
boot_splash/bg_color=Color(0, 0, 0, 0) # fundo do splash transparente
```
Sin esto, el **logo de Godot** aparecería por un instante al iniciar el `.exe`.

## 🪟 `[display]` — el secreto del overlay
```ini
window/size/viewport_width=200
window/size/viewport_height=200
window/size/borderless=true
window/size/always_on_top=true
window/size/transparent=true
window/per_pixel_transparency/allowed=true
```

## 🎨 `[rendering]`
```ini
renderer/rendering_method="gl_compatibility"        # OpenGL (obrigatório p/ transparência)
renderer/rendering_method.mobile="gl_compatibility"
viewport/transparent_background=true
```

> ⚠️ La transparencia por píxel **solo** funciona en el renderer **Compatibility**; en
> Forward+ la ventana exportada queda con un cuadrado negro. El MSAA 2D también debe
> quedar desactivado. Detalles en [[🪟 Sistema - Janela Overlay (ES)]].

`zimmy.gd:_ready()` aún refuerza los flags en runtime — ver [[🟢 Fluxo - Inicialização (ES)]].
