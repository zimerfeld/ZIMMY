---
tags: [meta, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 🧠 _Claude's Memory

This Obsidian vault is the **technical memory** of the Zimmy Pet project, created and maintained
by Claude. It lives at `C:\GODOT\ZIMMY\OBSIDIAN\CLAUDE`.

## Conventions
- **One idea per note**, with frontmatter (`tags`, `atualizado`).
- Notes start with a category prefix: `Sistema - …`, `Fluxo - …`,
  `Entrada - …`, `Arquivo - …`.
- **Link liberally** with `[[wikilinks]]`. The hub is [[Home (EN)]].
- Code references use `file:line` (e.g. `zimmy.gd:546`) — the lines may
  change; confirm before relying on them.
- Everything is in **Portuguese** (the author's preference, Renato Zimerfeld).

## What lives here
- **Systems**: the app's logical subsystems (what and why).
- **Flows**: execution sequences (`_ready`, `_process`, save/load…).
- **Entry Points (endpoints)**: the app's interaction surface — since this is
  a desktop overlay (not a web server), the "endpoints" are the **input
  events**, the **menu items** and the public **action functions**.
- **Key Files**: one note per important file in the repo.
- **References**: repository, build/export, glossary.

## Maintenance
When changing the app's behavior, update the affected system/flow note **and** the
corresponding [[Arquivo - README (EN)]] (the README is the source of truth; the vault
mirrors it). Convert relative dates to absolute ones.

> Origin: vault requested on 2026-06-20, populated from the current state of
> [[zimmy.gd (EN)]] (branch `feature/aleatorios`).
