---
tipo: backlog
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [meta, backlog, zimmy-pet]
---

# 🗂️ _Prioritized backlog

> **Self-sufficient** note to resume the project in any new chat.
> The global rule makes Claude read this vault at the start — so **start here** and then
> go to [[🏠 Home (EN)|Home]] and [[🧭 Como usar este cofre (EN)|How to use this vault]].
> Priority convention: **P0** = do now / unblocks the rest · **P1** = important, next
> batch · **P2** = when there's spare time / growth.

## 📸 State snapshot (2026-07-07)
- **Repo:** https://github.com/zimerfeld/ZIMMY · **branch:** `develop` (`0ce994e`) · **`main`:** `6b65440` (in sync with origin).
- **Latest releases:** tags **`202607071044geracao-30s`** (30s generation) and **`202607071024reacoes-e-fala`** (reactions/speech batch). **GitHub Release** published on the 30s tag with `ZimmyPet.exe` attached (Latest).
- **Engine:** Godot 4.6.2, GDScript. All code in [[📄 zimmy.gd (EN)]] (~4,215 lines, procedural `_draw()`, no sprites).
- **Clean tree** (aside from Obsidian UI-state churn in `ZIMMY/.obsidian/*`, intentionally kept out of commits).
- **Relevant rules/memory:** export the `.exe` as the final step ([[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]]); close `ZimmyPet.exe` and the Godot editor before touching the code; keep the clones/downloads count; GitFlow (feature → develop → release → main + tag).

## 🔴 P0 — unblock
- [x] **P0-1 · Commit the vault restructure** (`OBSIDIAN/CLAUDE/` → `OBSIDIAN/`) — done on 2026-07-01, commit `bdf60c6`: 62 renames (92–100%, history preserved) + `_Backlog.md`; `git status` clean for `OBSIDIAN/`.
- [x] **P0-2 · Fix the obsolete path** — done on 2026-07-01: `...\OBSIDIAN\CLAUDE` → `...\OBSIDIAN` in [[🧭 Como usar este cofre (EN)|How to use this vault]] (PT/EN) and [[📚 Repositório e Branches (EN)|Repository and Branches]] (PT/EN).

## 🟠 P1 — next batch
- [x] **P1-1 · Close the vault documentation gap.** Done on 2026-07-01: created [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler system]], [[💱 Sistema - Moedas (EN)|Currencies system]] and [[📧 Sistema - E-mails (EN)|E-mails system]] (PT + (EN) pair), with verified `zimmy.gd:line` refs and linked in [[🏠 Home (EN)|Home]] (PT/EN). Original details below, for reference:
  - `Automations & Scheduler system` — `Automacoes/` folder, **⚙️ Automations** submenu (one-off) + **⏱️ Timers** (scheduled, `const SCHEDULE`/`SCHEDULE_SECONDS`, persisted in `user://schedules.json`). Scripts: `alarme.gd`, `comemoracao_hora_cheia.gd` (fireworks via `celebrate()`), `desligar_pc.gd`, `cancelar_desligamento.gd`, `lembrete_pomodoro.gd`, `whatsapp.gd`, `email_gmail.gd`.
  - `Currencies system` — **💱 Currencies** submenu (`MENU_GROUP := "moedas"`, pixel flag icons `ICON_FLAG`), scripts `cotacao_usd/eur/gbp/jpy/cny.gd`.
  - `E-mails system` — **📧 E-mails** submenu (Gmail, unread counter, sound alert `🔊`).
  - Automation API: `run(zimmy)`, `zimmy.notify()` (queue ~5 s) vs `say()` (2.5 s). Basis: `Automacoes/LEIAME.md` and README §Automations.
  - Follow the vault convention: create a **PT + (EN) pair** of each note and **link them in [[🏠 Home (EN)|Home]]** (🧩 Systems section). Verify `zimmy.gd` line numbers before citing `file:line`.
  - **Done when:** every README submenu has a mirror note in the vault and Home points to them.
- [x] **P1-2 · Update the clones/downloads count** — done on 2026-07-01. `gh` was already installed **and authenticated** (no longer blocked). Snapshot (clones 14d): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293 (release downloads = 0 for all 4). Recorded in `contagem de downloads.txt` and in [[📈 Adoção e Métricas (EN)|Adoption & Metrics]] (PT/EN). **Note:** clones is a 14-day rolling window (not cumulative); the historical/NuGet total is the zimerfeld.com project's responsibility.
- [x] **P1-3 · Export the release `.exe`** — done on 2026-07-01: `build/ZimmyPet.exe` (~100 MB) exported via Godot 4.6.2 headless CLI (`Windows Desktop` preset), **exit 0, no errors/warnings**. No instance was open. `build/` is gitignored (the `.exe` is not versioned). See [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]].

## ✅ Recently done
- [x] **Landing-page fix — PT title/subtitle line break** — 2026-07-07: the landing page (`index.html`, served at **zimmy.zimerfeld.com** via GitHub Pages) used the i18n rule `html[data-lang="pt"] .lang-pt{display:inline}`, which forced **every** Portuguese element to `inline` — including `h2`/`h3` — making the title/subtitle collapse into the following text when the site opens in PT (EN was fine, since `h2`/`h3` are `block` by default). **1-line CSS fix:** `html[data-lang="pt"] h2.lang-pt,html[data-lang="pt"] h3.lang-pt{display:block}` — restores the break only on PT titles/subtitles, with no effect on EN. Shipped via GitFlow (`feature/pt-heading-break` → `develop` → release → `main`) + tag **`202607071915pt-heading-break`**; `CNAME` preserved; deploy verified live. `.obsidian/*` kept out of the commit, as usual.
- [x] **"Reactions & speech" batch + 30s generation** — 2026-07-07 (2 releases this session):
  - **Mouse reactions:** hover → happy/excited expression; **click an eye** → closes until the cursor leaves; **shake the mouse** fast → random animation + expression of **dizzy/nausea/scared** (`react_expr`, `_trigger_shake`). See [[😶‍🌫️ Sistema - Expressões Faciais (EN)|Facial Expressions]] and [[✨ Sistema - Animação (EN)|Animation]].
  - **Per-group sounds:** Feed/Pet/Play play random variations drawn within the group (`_build_*_sounds` + `_play_group`).
  - **Fireworks** on the hourly celebration (`zimmy.celebrate()` + `_draw_fireworks`); removed the `auto_alimentar.gd` (20s) automation.
  - **Unified speech queue:** immediate reactions (`say`, ~2.5s) + notification queue (`notify`, 10s each, no overlap); a user action **jumps the queue** (`urgent_cd`/`_preempt_with`, covers async web); an item waiting **>60s is discarded**. See [[💬 Sistema - Balão de Fala (EN)|Speech Bubble]].
  - **`RANDOM_PERIOD` 10s → 30s** (random pet/accessory generation more spaced out).
  - **Reverted at the user's request:** the usage-based dynamic menu reordering (plus `preferences.json` + "Restore defaults" item) — the menus went back to **static**.
  - **Close-out:** docs synced (3 READMEs + vault notes + `LEIAME.md`); `.exe` re-exported (100 MB, icon via rcedit, smoke-test OK). GitFlow: 2 releases finalized on `main` + tags **`202607071024reacoes-e-fala`** and **`202607071044geracao-30s`** (with `main → develop` backmerge). **GitHub Release** created on the 30s tag with `ZimmyPet.exe` attached (Latest).
  - **Metrics:** 2026-07-07 adoption snapshot (ZIMARO 706 · Tree 432 · CommitMsg 305 · ZIMMY 257 clones/14d) in `contagem de downloads.txt` and [[📈 Adoção e Métricas (EN)|Adoption & Metrics]]. `ZimmyPet.exe` has been published as a GitHub Release **since 2026-06-25** (release `202606251217`); ZIMMY's *downloads* = **all-time cumulative** of the asset (0 today). This tracking was **automated in the GitAdoptionMeter D1** — new host `github-release`, live at `gitadoptionmeter.com/api/adoption` (field `releaseDownloads`). Details in the GitAdoptionMeter project backlog.
- [x] **Rename the vault `OBSIDIAN/` → `ZIMMY/`** — 2026-07-05: vault folder renamed to the project name. References updated in `.claude/build-if-changed.ps1` (exclusion changed from `\OBSIDIAN\` to `\ZIMMY\ZIMMY\`, since the project root is also `...\ZIMMY`), in [[🧭 Como usar este cofre (EN)|How to use this vault]] (PT/EN, path `C:\GODOT\ZIMMY\ZIMMY`) and in the [[📚 Repositório e Branches (EN)|Repository and Branches]] tree (PT/EN). The user's global vault (`C:\Users\Renat\OBSIDIAN`) is a different thing and was not touched.
- [x] **User recurring reminders feature** — 2026-07-02: native **⏰ Reminders** submenu (without editing `.gd`) — dialog with message + frequency dropdown (15/30 min, 1 h, hourly, `daily@HH:MM`) + time field; checkable items (on/off), delete; persisted in `user://reminders.json`; fired by the same scheduler clock (extracted, shared `_parse_schedule_str` parser). Compiled (`--check-only`), **runtime-tested** (18/18 asserts, incl. firing) and app smoke test OK. Documented in README (root+PT+EN) and [[⏰ Sistema - Lembretes (EN)|Reminders system]] (PT/EN). It was idea #2 from [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]].
- [x] **Weather feature** — 2026-07-01: `Automacoes/clima.gd` (Open-Meteo free/no key, IP geolocation with fallback, bilingual). Syntax validated (`--check-only`) and **runtime-tested** (headless harness → "☀️ clear sky — 21.2°C in Rio de Janeiro"). Documented in README (root+PT+EN), LEIAME and [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler system]]. It was idea #1 from [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]].

## 🟡 P2 — growth / when there's spare time
- [x] **P2-1 · Bilingual promotion** — done on 2026-07-01: PT+EN copy (short announcement, long post and per-feature micro-posts) in [[📣 Divulgação — Posts (EN)|Promo Posts]]. Only **publishing** to the channels remains.
- [~] **P2-2 · Evaluate distribution channels** — analysis done in [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] (itch.io = highest ROI → then Reddit/video → Store/Product Hunt). Page description **ready to paste** in [[🎮 itch.io — Página (EN)|itch.io — Page]] (metadata + EN/PT + media checklist). **Execution pending (depends on the user):** create the itch.io account/page, upload the `.exe` and the GIFs.
- [x] **P2-3 · Product ideas** — prioritized by appeal × effort in [[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] (top: weather 🔥 and user recurring reminders 🔥). Validate before coding.

## 🔗 See also
[[🏠 Home (EN)|Home]] · [[🧭 Como usar este cofre (EN)|How to use this vault]] · [[📚 Repositório e Branches (EN)|Repository and Branches]] · [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]] · [[📄 zimmy.gd (EN)]]
