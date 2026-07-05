---
tipo: conhecimento
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [referencia, git, zimmy-pet]
---

# 📚 Repository and Branches

- **Remote**: `origin` → https://github.com/zimerfeld/ZIMMY.git
- **Default remote branch**: `main` (`origin/HEAD -> origin/main`).
- **Local branches**: `main`, `develop`, `feature/aleatorios` (active on 2026-06-20).
- **Remote branches**: `origin/main`, `origin/develop`, `origin/feature/aleatorios`.

## 📝 Recent commits
- `f498910` — Zimmy pet - Fix 3 files (fix, docs)
- `294ddda` — Zimmy pet - Implement 11 files (feat, docs)
- `714c75a` — Initial commit

## 🗂️ Repo layout
```
zimmy.gd            # all the pet logic (Node2D) -> [[📄 zimmy.gd (EN)]]
zimmy.gd.uid        # script UID (Godot 4)
main.tscn           # root scene, just attaches the script -> [[📄 main.tscn (EN)]]
project.godot       # project/window config -> [[📄 project.godot (EN)]]
export_presets.cfg  # Windows Desktop preset -> [[📄 export_presets.cfg (EN)]]
icon.png / zimmy.ico# icons (editor / .exe)
tools/make_icon.py  # generates the icons -> [[📄 tools - make_icon.py (EN)]]
README.md           # docs (source of truth) -> [[📄 Arquivo - README (EN)]]
build/ZimmyPet.exe  # exported binary (generated)
ZIMMY/              # this vault (Obsidian memory)
```

See [[🚀 Export e Publicação (Prod) (EN)]] to generate the `.exe`.
