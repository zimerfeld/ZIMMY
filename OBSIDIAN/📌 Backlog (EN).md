---
tipo: backlog
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [meta, backlog, zimmy-pet]
---

# 🗂️ _Prioritized backlog

> **Self-sufficient** note to resume the project in any new chat.
> The global rule makes Claude read this vault at the start — so **start here** and then
> go to [[🏠 Home (EN)|Home]] and [[🧭 Como usar este cofre (EN)|How to use this vault]].
> Priority convention: **P0** = do now / unblocks the rest · **P1** = important, next
> batch · **P2** = when there's spare time / growth.

## 📸 State snapshot (2026-07-01)
- **Repo:** https://github.com/zimerfeld/ZIMMY · **branch:** `develop`
- **Latest commit:** `1013cf8` (LICENSE removal) — before: `41a19e1` Alarm (43 files), Timers/Currencies/E-mails.
- **Engine:** Godot 4.6.2, GDScript. All code in [[📄 zimmy.gd (EN)]] (~3,567 lines, procedural `_draw()`, no sprites).
- **Dirty tree (important):** the vault was **moved from `OBSIDIAN/CLAUDE/` → `OBSIDIAN/`** and the change **is not committed** (62 files as `D` + 9 new `??`). See **P0-1**.
- **Relevant rules/memory:** export the `.exe` as the final step ([[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]]); close `ZimmyPet.exe` and the Godot editor before touching the code; keep the clones/downloads count.

## 🔴 P0 — unblock
- [x] **P0-1 · Commit the vault restructure** (`OBSIDIAN/CLAUDE/` → `OBSIDIAN/`) — done on 2026-07-01, commit `bdf60c6`: 62 renames (92–100%, history preserved) + `_Backlog.md`; `git status` clean for `OBSIDIAN/`.
- [x] **P0-2 · Fix the obsolete path** — done on 2026-07-01: `...\OBSIDIAN\CLAUDE` → `...\OBSIDIAN` in [[🧭 Como usar este cofre (EN)|How to use this vault]] (PT/EN) and [[📚 Repositório e Branches (EN)|Repository and Branches]] (PT/EN).

## 🟠 P1 — next batch
- [x] **P1-1 · Close the vault documentation gap.** Done on 2026-07-01: created [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler system]], [[💱 Sistema - Moedas (EN)|Currencies system]] and [[📧 Sistema - E-mails (EN)|E-mails system]] (PT + (EN) pair), with verified `zimmy.gd:line` refs and linked in [[🏠 Home (EN)|Home]] (PT/EN). Original details below, for reference:
  - `Automations & Scheduler system` — `Automacoes/` folder, **⚙️ Automations** submenu (one-off) + **⏱️ Timers** (scheduled, `const SCHEDULE`/`SCHEDULE_SECONDS`, persisted in `user://schedules.json`). Scripts: `alarme.gd`, `auto_alimentar.gd`, `comemoracao_hora_cheia.gd`, `desligar_pc.gd`, `cancelar_desligamento.gd`, `lembrete_pomodoro.gd`, `whatsapp.gd`, `email_gmail.gd`.
  - `Currencies system` — **💱 Currencies** submenu (`MENU_GROUP := "moedas"`, pixel flag icons `ICON_FLAG`), scripts `cotacao_usd/eur/gbp/jpy/cny.gd`.
  - `E-mails system` — **📧 E-mails** submenu (Gmail, unread counter, sound alert `🔊`).
  - Automation API: `run(zimmy)`, `zimmy.notify()` (queue ~5 s) vs `say()` (2.5 s). Basis: `Automacoes/LEIAME.md` and README §Automations.
  - Follow the vault convention: create a **PT + (EN) pair** of each note and **link them in [[🏠 Home (EN)|Home]]** (🧩 Systems section). Verify `zimmy.gd` line numbers before citing `file:line`.
  - **Done when:** every README submenu has a mirror note in the vault and Home points to them.
- [x] **P1-2 · Update the clones/downloads count** — done on 2026-07-01. `gh` was already installed **and authenticated** (no longer blocked). Snapshot (clones 14d): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293 (release downloads = 0 for all 4). Recorded in `contagem de downloads.txt` and in [[📈 Adoção e Métricas (EN)|Adoption & Metrics]] (PT/EN). **Note:** clones is a 14-day rolling window (not cumulative); the historical/NuGet total is the zimerfeld.com project's responsibility.
- [x] **P1-3 · Export the release `.exe`** — done on 2026-07-01: `build/ZimmyPet.exe` (~100 MB) exported via Godot 4.6.2 headless CLI (`Windows Desktop` preset), **exit 0, no errors/warnings**. No instance was open. `build/` is gitignored (the `.exe` is not versioned). See [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]].

## ✅ Recently done
- [x] **User recurring reminders feature** — 2026-07-02: native **⏰ Reminders** submenu (without editing `.gd`) — dialog with message + frequency dropdown (15/30 min, 1 h, hourly, `daily@HH:MM`) + time field; checkable items (on/off), delete; persisted in `user://reminders.json`; fired by the same scheduler clock (extracted, shared `_parse_schedule_str` parser). Compiled (`--check-only`), **runtime-tested** (18/18 asserts, incl. firing) and app smoke test OK. Documented in README (root+PT+EN) and [[⏰ Sistema - Lembretes (EN)|Reminders system]] (PT/EN). It was idea #2 from [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]].
- [x] **Weather feature** — 2026-07-01: `Automacoes/clima.gd` (Open-Meteo free/no key, IP geolocation with fallback, bilingual). Syntax validated (`--check-only`) and **runtime-tested** (headless harness → "☀️ clear sky — 21.2°C in Rio de Janeiro"). Documented in README (root+PT+EN), LEIAME and [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler system]]. It was idea #1 from [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]].

## 🟡 P2 — growth / when there's spare time
- [x] **P2-1 · Bilingual promotion** — done on 2026-07-01: PT+EN copy (short announcement, long post and per-feature micro-posts) in [[📣 Divulgação — Posts (EN)|Promo Posts]]. Only **publishing** to the channels remains.
- [~] **P2-2 · Evaluate distribution channels** — analysis done in [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] (itch.io = highest ROI → then Reddit/video → Store/Product Hunt). Page description **ready to paste** in [[🎮 itch.io — Página (EN)|itch.io — Page]] (metadata + EN/PT + media checklist). **Execution pending (depends on the user):** create the itch.io account/page, upload the `.exe` and the GIFs.
- [x] **P2-3 · Product ideas** — prioritized by appeal × effort in [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] (top: weather 🔥 and user recurring reminders 🔥). Validate before coding.

## 🔗 See also
[[🏠 Home (EN)|Home]] · [[🧭 Como usar este cofre (EN)|How to use this vault]] · [[📚 Repositório e Branches (EN)|Repository and Branches]] · [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]] · [[📄 zimmy.gd (EN)]]
