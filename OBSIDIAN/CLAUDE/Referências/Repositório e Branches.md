---
tags: [referencia, git, zimmy-pet]
atualizado: 2026-06-20
---

# 📚 Repositório e Branches

- **Remote**: `origin` → https://github.com/zimerfeld/ZIMMY_PET.git
- **Branch padrão remoto**: `main` (`origin/HEAD -> origin/main`).
- **Branches locais**: `main`, `develop`, `feature/aleatorios` (ativa em 2026-06-20).
- **Branches remotas**: `origin/main`, `origin/develop`, `origin/feature/aleatorios`.

## Commits recentes
- `f498910` — Zimmy pet - Fix 3 files (fix, docs)
- `294ddda` — Zimmy pet - Implement 11 files (feat, docs)
- `714c75a` — Initial commit

## Layout do repo
```
zimmy.gd            # toda a lógica do pet (Node2D) -> [[zimmy.gd]]
zimmy.gd.uid        # UID do script (Godot 4)
main.tscn           # cena raiz, só anexa o script -> [[main.tscn]]
project.godot       # config do projeto/janela -> [[project.godot]]
export_presets.cfg  # preset Windows Desktop -> [[export_presets.cfg]]
icon.png / zimmy.ico# ícones (editor / .exe)
tools/make_icon.py  # gera os ícones -> [[tools - make_icon.py]]
README.md           # docs (fonte da verdade) -> [[Arquivo - README]]
build/ZimmyPet.exe  # binário exportado (gerado)
OBSIDIAN/CLAUDE/    # este cofre
```

Veja [[Build e Export]] para gerar o `.exe`.
