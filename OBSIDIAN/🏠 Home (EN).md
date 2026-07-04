---
tipo: moc
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [moc, home, zimmy-pet]
---

# 🏠 ZIMMY — Neuron Vault

> 🇧🇷 Leia esta página em português → [[🏠 Home]]

> [!abstract] 🧠 What this vault is
> Claude's persistent memory for the **ZIMMY (Zimmy Pet)** project. A procedural *desktop pet*
> in Godot 4 that also became a light assistant. This vault is maintained by Claude and
> **mirrors the README** (source of truth); when behavior changes, the affected note and the
> README are updated together.

## ⚡ Executive summary
- **What it is:** a free, **open-source** desktop pet for Windows — a transparent, borderless,
  always-on-top overlay window; everything is **drawn in code** (procedural `_draw()`, no
  sprites), so every pet is unique.
- **Problem it solves:** cute on-screen company + small everyday utilities without opening
  heavy apps.
- **Differentiators:** a built-in light assistant — visual scheduler, currency quotes, weather,
  Gmail, alarm/reminders; **extensible** (drop a `.gd` into `Automacoes/`); **bilingual** (PT/EN).
- **Stack:** Godot **4.6.2** stable, GDScript; the whole app lives in [[📄 zimmy.gd (EN)]] attached
  to [[📄 main.tscn (EN)]]. No external dependencies beyond the Godot API.
- **Current state:** `develop` branch; recent weather and recurring-reminders features shipped.
  Release `.exe` (~100 MB) exportable ([[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]]).
- **Audience:** virtual-pet enthusiasts + people who want "cute productivity" on the desktop.
- **Business angle:** free/OSS → indirect return (portfolio + top of funnel + donations/
  sponsorship). See [[💜 Financiamento e Patrocínio (EN)|Funding and Sponsorship]] and
  [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]].

## 🧭 Navigation by priority

### 1️⃣ 🔑 Impact — Key Files
> Files that, if manipulated, have a big impact on the system.
- [[📄 zimmy.gd (EN)]] — the whole app (~908 useful lines, procedural `_draw()`); touching it changes everything.
- [[📄 project.godot (EN)]] — overlay config (transparency, borderless, always-on-top, OpenGL renderer).
- [[📄 main.tscn (EN)]] — root scene that instantiates `zimmy.gd`.
- [[📄 export_presets.cfg (EN)]] — `.exe` preset (Windows Desktop, `embed_pck`, icon, excludes `tools/*`).
- [[📄 tools - make_icon.py (EN)]] — generates `icon.png` + `zimmy.ico`.
- [[📄 Arquivo - README (EN)|README]] — documentation and **source of truth** for project facts.

### 2️⃣ 🧩 Reuse — Systems
> Subsystems reused by several parts of the project.
- [[🪟 Sistema - Janela Overlay (EN)|Overlay Window]] — the transparent/borderless/always-on-top window and `_relayout`.
- [[🎨 Sistema - Render (_draw) (EN)|Render (_draw)]] — procedural pet drawing (no sprites).
- [[✨ Sistema - Animação (EN)|Animation]] — breathing, blinking, hopping, cursor following.
- [[🐾 Sistema - Pets (EN)|Pets]] — default/random config of each pet.
- [[🎀 Sistema - Acessórios (EN)|Accessories]] — accessories on the pet.
- [[😶‍🌫️ Sistema - Expressões Faciais (EN)|Facial Expressions]] — faces/expressions.
- [[😤 Sistema - Interação e Mau Humor (EN)|Interaction and Mood]] — poke reactions, mood.
- [[📊 Sistema - Necessidades (EN)|Needs]] — hunger/mood over time.
- [[💬 Sistema - Balão de Fala (EN)|Speech Bubble]] — dynamic speech bubble.
- [[🧭 Sistema - Menu de Contexto (EN)|Context Menu]] — the right-click menu and its submenus.
- [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler]] — `Automacoes/`, ⚙️ Automations + ⏱️ Timers.
- [[⏰ Sistema - Lembretes (EN)|Reminders]] — ⏰ user recurring reminders submenu.
- [[💱 Sistema - Moedas (EN)|Currencies]] — USD/EUR/GBP/JPY/CNY quotes.
- [[📧 Sistema - E-mails (EN)|E-mails]] — Gmail (unread counter + sound).
- [[💾 Sistema - Persistência (EN)|Persistence]] — reading/writing state in `user://`.

### 3️⃣ 🔀 Use — Flows
> Step-by-step usage flows.
- [[🟢 Fluxo - Inicialização (EN)|Init]] — `_ready`, reinforcing the overlay flags.
- [[🔁 Fluxo - Loop (_process) (EN)|Loop (_process)]] — the per-frame loop.
- [[🖱️ Fluxo - Arrastar e Posição (EN)|Drag and Position]] — dragging the pet and computing position.
- [[😼 Fluxo - Interação e Limites (EN)|Interaction and Bounds]] — poking and screen bounds.
- [[💾 Fluxo - Salvar e Carregar (EN)|Save and Load]] — persist and restore.
- [[🎲 Fluxo - Geração Aleatória (EN)|Random Generation]] — random pet/config.

## 🚀 Operation
- [[💻 Rodar no Editor (Dev) (EN)|Run in the Editor (Dev)]] — open/run in the Godot editor (F5) during development.
- [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing (Prod)]] — headless export of `build/ZimmyPet.exe` + publish.

## 🚪 Entry Points
> Since this is a desktop overlay (not a web server), the interaction surface is the input
> events, the menu items and the action functions.
- [[🚪 Entrada - Eventos de Input (EN)|Input Events]] — mouse/keyboard.
- [[🚪 Entrada - Itens do Menu (EN)|Menu Items]] — the context-menu entries.
- [[🚪 Entrada - Funções de Ação (EN)|Action Functions]] — public functions triggered by the menu.

## 📚 Knowledge
- [[📚 Repositório e Branches (EN)|Repository and Branches]] — repo, branches and the GitFlow flow.
- [[🗂️ Glossário de Configs (EN)|Config Glossary]] — glossary of configuration keys.

## 💼 Business
- [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] — channels and product ideas (investor lens).
- [[💜 Financiamento e Patrocínio (EN)|Funding and Sponsorship]] — GitHub Sponsors `zimerfeld` + Ko-fi `C0D621FCGD` + badges.
- [[📈 Adoção e Métricas (EN)|Adoption & Metrics]] — clones/downloads count.
- [[🎮 itch.io — Página (EN)|itch.io — Page]] — ready-to-paste page (metadata + bilingual description).
- [[📣 Divulgação — Posts (EN)|Promo Posts]] — ready-to-publish bilingual copy.

## 🧭 Meta
- [[🧭 Como usar este cofre (EN)|How to use this vault]] — vault conventions, structure and maintenance.

## 📌 Resume
- [[📌 Backlog (EN)|Backlog]] — **start here** when resuming the project in another session.
