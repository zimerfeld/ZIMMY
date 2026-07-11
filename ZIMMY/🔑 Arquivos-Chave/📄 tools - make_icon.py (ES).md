---
tipo: arquivo-chave
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [arquivo, ferramenta, python, zimmy-pet]
caminho: tools/make_icon.py
linguagem: Python
---

# 📄 tools/make_icon.py

> 🇧🇷 Lee esta página en portugués → [[📄 tools - make_icon.py]]
> 🇺🇸 Read this page in English → [[📄 tools - make_icon.py (EN)]]

Script de Python (requiere **Pillow**) que reproduce el dibujo procedural del pet y genera los
iconos — para que el icono coincida con la carita dibujada en [[📄 zimmy.gd (ES)]] (`_draw()`).

## 📤 Salidas
- `icon.png` (1024×1024) — icono del editor Godot ([[📄 project.godot (ES)]] `config/icon`).
- `zimmy.ico` (multi-size 16→256) — icono del `.exe` ([[📄 export_presets.cfg (ES)]]).

## 🔍 Cómo funciona
- Renderiza en un canvas grande (`SS=2048`, supersampling) con `SCALE≈6.144`.
- `t(x,y)` mapea el espacio lógico 200×200 del pet al espacio de render.
- Reutiliza los mismos colores/posiciones del `_draw`: sombra, orejas, cuerpo/barriga,
  mejillas, ojos con brillo y boca (arco «U» feliz).
- Hace downscale con LANCZOS y guarda PNG + ICO.

```powershell
py tools/make_icon.py
```

> ⚠️ Es una **réplica** del dibujo (no comparte código con el `_draw()`). ¿Cambiaste la
> carita en [[🎨 Sistema - Render (_draw) (ES)]]? Actualízala aquí también para que el icono no
> diverja. Excluido del paquete exportado.
