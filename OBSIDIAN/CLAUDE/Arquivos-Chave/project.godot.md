---
tags: [arquivo, config, zimmy-pet]
caminho: project.godot
atualizado: 2026-06-20
---

# 📄 project.godot

Config do projeto Godot. `config/features = "4.6"`. Cena inicial:
`run/main_scene = "res://main.tscn"` ([[main.tscn]]). Ícone do editor:
`res://icon.png`.

## `[display]` — o segredo do overlay
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
renderer/rendering_method="gl_compatibility"        # OpenGL (obrigatório p/ transparência)
renderer/rendering_method.mobile="gl_compatibility"
viewport/transparent_background=true
```

> ⚠️ A transparência por pixel **só** funciona no renderer **Compatibility**; no
> Forward+ a janela exportada fica com um quadrado preto. O MSAA 2D também precisa
> ficar desligado. Detalhes em [[Sistema - Janela Overlay]].

`zimmy.gd:_ready()` ainda reforça as flags em runtime — ver [[Fluxo - Inicialização]].
