---
tipo: arquivo-chave
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [arquivo, ferramenta, python, zimmy-pet]
caminho: tools/make_icon.py
linguagem: Python
---

# 📄 tools/make_icon.py

Script Python (requer **Pillow**) que reproduz o desenho procedural do pet e gera os
ícones — para que o ícone case com a carinha desenhada em [[📄 zimmy.gd]] (`_draw()`).

## 📤 Saídas
- `icon.png` (1024×1024) — ícone do editor Godot ([[📄 project.godot]] `config/icon`).
- `zimmy.ico` (multi-size 16→256) — ícone do `.exe` ([[📄 export_presets.cfg]]).

## 🔍 Como funciona
- Renderiza num canvas grande (`SS=2048`, supersampling) com `SCALE≈6.144`.
- `t(x,y)` mapeia o espaço lógico 200×200 do pet para o espaço de render.
- Reusa as mesmas cores/posições do `_draw`: sombra, orelhas, corpo/barriga,
  bochechas, olhos com brilho e boca (arco "U" feliz).
- Faz downscale com LANCZOS e salva PNG + ICO.

```powershell
py tools/make_icon.py
```

> ⚠️ É uma **réplica** do desenho (não compartilha código com o `_draw()`). Mudou a
> carinha em [[🎨 Sistema - Render (_draw)]]? Atualize aqui também para o ícone não
> divergir. Excluído do pacote exportado.
