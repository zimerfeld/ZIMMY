---
tipo: conhecimento
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [referencia, git, zimmy-pet]
---

# 📚 Repositório e Branches

> 🇧🇷 Lee esta página en portugués → [[📚 Repositório e Branches]]
> 🇺🇸 Read this page in English → [[📚 Repositório e Branches (EN)]]

- **Remote**: `origin` → https://github.com/zimerfeld/ZIMMY.git
- **Rama predeterminada remota**: `main` (`origin/HEAD -> origin/main`).
- **Ramas locales**: `main`, `develop`, `feature/aleatorios` (activa el 2026-06-20).
- **Ramas remotas**: `origin/main`, `origin/develop`, `origin/feature/aleatorios`.

## 📝 Commits recientes
- `f498910` — Zimmy pet - Fix 3 files (fix, docs)
- `294ddda` — Zimmy pet - Implement 11 files (feat, docs)
- `714c75a` — Initial commit

## 🗂️ Layout del repo
```
zimmy.gd            # toda a lógica do pet (Node2D) -> [[📄 zimmy.gd]]
zimmy.gd.uid        # UID do script (Godot 4)
main.tscn           # cena raiz, só anexa o script -> [[📄 main.tscn]]
project.godot       # config do projeto/janela -> [[📄 project.godot]]
export_presets.cfg  # preset Windows Desktop -> [[📄 export_presets.cfg]]
icon.png / zimmy.ico# ícones (editor / .exe)
tools/make_icon.py  # gera os ícones -> [[📄 tools - make_icon.py]]
README.md           # docs (fonte da verdade) -> [[📄 Arquivo - README]]
build/ZimmyPet.exe  # binário exportado (gerado)
ZIMMY/              # este cofre (memória Obsidian)
```

Ver [[🚀 Export e Publicação (Prod) (ES)]] para generar el `.exe`.
</content>
