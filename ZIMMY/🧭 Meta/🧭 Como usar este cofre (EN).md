---
tipo: meta
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [meta, zimmy-pet]
---

# 🧭 How to use this vault

> 🇧🇷 Leia esta página em português → [[🧭 Como usar este cofre]]
> 🇪🇸 Lee esta página en español → [[🧭 Como usar este cofre (ES)]]

> To **resume work**, see [[📌 Backlog (EN)|Backlog]] (P0/P1/P2 priorities).

This Obsidian vault is the **technical memory** of the Zimmy Pet project, created and maintained
by Claude. It lives at `C:\GODOT\ZIMMY\ZIMMY`.

## 📐 Conventions
- **One idea per note**, with standard frontmatter (`tipo`, `projeto`, `lang`, `atualizado`, `tags`).
- Notes start with **emoji + category prefix**: `🐾 Sistema - …`, `🎲 Fluxo - …`,
  `🚪 Entrada - …`, `📄 Arquivo - …`.
- **Icons (emoji) everywhere:** every note carries the same themed emoji in **three
  places** — in the **file name** (shows in the tree), on the **`#` title** and on
  **each `##` subheading** (the latter picked from the section's content). **Folders**
  also carry an emoji prefix; the pane order is defined by the root `sortspec.md`
  (**custom-sort** plugin), by **priority**: `🔑 Arquivos-Chave` (impact) →
  `🧩 Sistemas` (reuse) → `🔀 Fluxos` (usage) → `🚀 Operação` → `🚪 Pontos de Entrada` →
  `📚 Conhecimento` → `💼 Negócio` → `🧭 Meta`.
- **Bilingual pair:** every PT note `<emoji> Name.md` has a `<emoji> Name (EN).md` pair
  (full English-US translation). PT notes link PT names; EN notes link the `(EN)` pairs.
- **Link liberally** with `[[wikilinks]]`. The hub is [[🏠 Home (EN)|Home]]. `[[links]]` use
  the note's **base name** (with the emoji); moving a note between folders won't break
  the link, but **renaming the file will** — update the wikilinks alongside any rename (PT and EN).
- Code references use `file:line` (e.g. `zimmy.gd:546`) — the lines may
  change; confirm before relying on them.
- The vault's base language is **Portuguese** (the author's preference, Renato Zimerfeld),
  with a full English mirror in the `(EN)` pairs.

## 🏠 What lives here
- **🔑 Arquivos-Chave (Key Files)**: one note per important file in the repo (high impact if manipulated).
- **🧩 Sistemas (Systems)**: the app's logical subsystems (what and why), reused across the project.
- **🔀 Fluxos (Flows)**: execution sequences (`_ready`, `_process`, save/load…).
- **🚀 Operação (Operations)**: runbooks — run in the editor (Dev) and export/publish the `.exe` (Prod).
- **🚪 Pontos de Entrada (Entry Points)**: the app's interaction surface — since this is
  a desktop overlay (not a web server), the "endpoints" are the **input
  events**, the **menu items** and the public **action functions**.
- **📚 Conhecimento (Knowledge)**: repository/branches and configs glossary.
- **💼 Negócio (Business)**: adoption/metrics, promotion, distribution, itch.io, funding.
- **🧭 Meta**: this note (how to use the vault).

## 🧹 Maintenance
When changing the app's behavior, update the affected system/flow note **and** the
corresponding [[📄 Arquivo - README (EN)]] (the README is the source of truth; the vault
mirrors it). Convert relative dates to absolute ones. Keep the `(EN)` pair in sync.

> Origin: vault requested on 2026-06-20, populated from the current state of
> [[📄 zimmy.gd (EN)]] (branch `feature/aleatorios`). Restructured to the
> "Vault of Neurons v2" standard on 2026-07-04.
