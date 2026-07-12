---
tipo: arquivo-chave
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [arquivo, ferramenta, python, zimmy-pet]
caminho: tools/make_icon.py
linguagem: Python
---

# 📄 tools/make_icon.py

> 🇪🇸 Lee esta página en español → [[📄 tools - make_icon.py (ES)]]

Python script (requires **Pillow**) that reproduces the pet's procedural drawing and
generates the icons — so that the icon matches the face drawn in [[📄 zimmy.gd (EN)]] (`_draw()`).

## 📤 Outputs
- `icon.png` (1024×1024) — Godot editor icon ([[📄 project.godot (EN)]] `config/icon`).
- `zimmy.ico` (multi-size 16→256) — `.exe` icon ([[📄 export_presets.cfg (EN)]]).

## 🔍 How it works
- Renders on a large canvas (`SS=2048`, supersampling) with `SCALE≈6.144`.
- `t(x,y)` maps the pet's logical 200×200 space to the render space.
- Reuses the same colors/positions as `_draw`: shadow, ears, body/belly,
  cheeks, eyes with highlight, and mouth (happy "U" arc).
- Downscales with LANCZOS and saves PNG + ICO.

```powershell
py tools/make_icon.py
```

> ⚠️ It is a **replica** of the drawing (it does not share code with `_draw()`). Changed the
> face in [[🎨 Sistema - Render (_draw) (EN)]]? Update it here too so the icon doesn't
> drift. Excluded from the exported package.
