---
tags: [moc, zimmy-pet]
aliases: [Início, MOC, Mapa]
atualizado: 2026-06-21
lang: en
---

# 🧡 Zimmy Pet — Vault of Neurons

> Technical memory of the **Zimmy Pet** project, maintained by Claude.
> Repository: https://github.com/zimerfeld/ZIMMY
> Main source code: [[zimmy.gd (EN)]] (Godot 4.6, GDScript).

Desktop pet overlay: a transparent, borderless, always-on-top window with a
procedural face (the "Zimmy") that breathes, blinks, hops, follows the cursor and reacts to
interactions. Everything is drawn in code (`_draw()`), with no sprites.

## 💜 Funding / Sponsorship
Donation channels configured in the repository (badges at the top of the README + **Sponsor** button):
- **GitHub Sponsors:** [zimerfeld](https://github.com/sponsors/zimerfeld) · **Ko-fi:** [C0D621FCGD ☕](https://ko-fi.com/C0D621FCGD)
- **`.github/FUNDING.yml`:** created with `github: zimerfeld` and `ko_fi: C0D621FCGD`.
- **Social proof in the README:** GitHub **stars** and release **downloads** badges (`shields.io/github/stars` and `/downloads/.../total`) + a short "why donate" line (maintained in free time). The project is not published on NuGet, so the public metric is GitHub (no package badge).

## 🧠 How to use this vault
See [[_Memória do Claude (EN)]] for the convention on notes, links and updates.

## 🧩 Systems
- [[Sistema - Janela Overlay (EN)]] — transparency, always-on-top, dynamic layout
- [[Sistema - Pets (EN)]] — config, procedural generation, shapes and elements
- [[Sistema - Acessórios (EN)]] — independent layer (hat/glasses/bow/scarf)
- [[Sistema - Render (_draw) (EN)]] — drawing pipeline and primitives
- [[Sistema - Animação (EN)]] — breathing, hop, blink, eyes
- [[Sistema - Expressões Faciais (EN)]] — face mirrors the spoken emoji
- [[Sistema - Balão de Fala (EN)]] — `say()` + `_relayout()`
- [[Sistema - Interação e Mau Humor (EN)]] — cooldown, repeat limit, complaints
- [[Sistema - Necessidades (EN)]] — Feed/Pet/Play bars, decay, shutdown
- [[Sistema - Persistência (EN)]] — `user://` JSON (pets, accessories, position)
- [[Sistema - Menu de Contexto (EN)]] — PopupMenu, submenus, dialogs

## 🔀 Flows
- [[Fluxo - Inicialização (EN)]] (`_ready`)
- [[Fluxo - Loop (_process) (EN)]]
- [[Fluxo - Arrastar e Posição (EN)]]
- [[Fluxo - Geração Aleatória (EN)]]
- [[Fluxo - Salvar e Carregar (EN)]]
- [[Fluxo - Interação e Limites (EN)]]

## 🚪 Entry Points (endpoints)
- [[Entrada - Eventos de Input (EN)]] — mouse/keyboard
- [[Entrada - Itens do Menu (EN)]] — `MI_*` ids
- [[Entrada - Funções de Ação (EN)]] — `feed/pet/play/_react`

## 📄 Key Files
- [[zimmy.gd (EN)]] · [[project.godot (EN)]] · [[main.tscn (EN)]] · [[export_presets.cfg (EN)]]
- [[tools - make_icon.py (EN)]] · [[Arquivo - README (EN)]]

## 📚 References
- [[Repositório e Branches (EN)]] · [[Build e Export (EN)]] · [[Glossário de Configs (EN)]]
