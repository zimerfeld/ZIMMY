---
tags: [sistema, automacoes, agendador, extensibilidade, zimmy-pet]
atualizado: 2026-07-01
lang: en
---

# ⚙️ System - Automations & Scheduler

Zimmy's **extensibility** layer: any `.gd` script dropped in the `Automacoes/` folder
becomes a menu item. **One-off** scripts show up under **⚙️ Automations** (run once when
clicked) and those declaring a frequency show up under **⏱️ Timers** (Zimmy runs them by
itself). Contract source of truth: `Automacoes/LEIAME.md`.

## Discovery — `_scan_automations()` (zimmy.gd:1403)
The folder is **rescanned every time the context menu opens**, so new scripts appear
without a restart. For each `.gd` Zimmy reads the script's **constant map** and stores, per
path, the metadata in dictionaries: `automation_groups` (`MENU_GROUP`, zimmy.gd:71),
`automation_badge_keys` (`BADGE_KEY`), `automation_cred_keys` (`CRED_KEY`),
`automation_icon_colors` (`ICON_COLOR`), `automation_flags` (`ICON_FLAG`). The menu is
rebuilt by `_rebuild_automations_menu()` (zimmy.gd:1029), honoring the current language.

## Automation contract
- `func run(zimmy)` — **required**; receives the main node (access to `notify()`, `say()`,
  `feed()`, `pet()`, `play()`, `hop()`, `current`, `hunger`, `happy`, etc.).
- `const AUTOMATION_NAME` / `AUTOMATION_NAME_EN` — menu label (pt / en); without them the
  name is derived from the filename.
- `const SCHEDULE` / `SCHEDULE_SECONDS` — frequency (see **Scheduler**).
- `const MENU_GROUP` — routes the item into a dedicated submenu: `"email"` → 📧 E-mails
  ([[Sistema - E-mails (EN)]]), `"moedas"` → 💱 Currencies ([[Sistema - Moedas (EN)]]),
  `"whatsapp"` → 💬 WhatsApp. Without a group it lands in ⚙️ Automations.
- `const ICON_COLOR` (hex), `const BADGE_KEY` (dynamic label via `set_automation_badge`),
  `const CRED_KEY` (credentials), `const ICON_FLAG` (flag).
- **Lifecycle:** `extends RefCounted` → discarded after `run()`; `extends Node` → becomes a
  child of Zimmy and **persists** (useful for continuous automations with `_process`).

## Scheduler — `_parse_schedule()` (zimmy.gd:1462)
Turns `SCHEDULE`/`SCHEDULE_SECONDS` into a `{kind, every, at_minute, label}` descriptor:
- `"30s"` / `"5m"` / `"2h"` → **interval** (`_interval_def`, zimmy.gd:1491).
- `"hourly"` → every **top of the hour** (minute :00, clock-aligned).
- `"daily@HH:MM"` → **once a day** at that time.
- plain number (or `SCHEDULE_SECONDS`) → seconds.

Scheduled automations appear under **⏱️ Timers** (`timers_menu`, `MI_TIMERS=21`,
zimmy.gd:258) as **checkable** items (✓ = on) with a clock icon and the frequency in the
label — the **visual scheduler**. The on/off state is **persisted** in
`user://schedules.json` (`SCHEDULES_FILE`, zimmy.gd:44) and restored on reopen. The loop
`_tick_schedules(delta)` (zimmy.gd:1551) fires `_run_automation(path)` (zimmy.gd:1612) at
the right time — a scheduled `run()` should do the action **once** (recurrence belongs to
the scheduler). See [[Fluxo - Loop (_process) (EN)]].

## Speaking from automations
Use **`zimmy.notify(msg)`** (zimmy.gd:3549): it enters a **queue**, shows one at a time and
stays ~5 s (avoids overlap when several fire together, e.g. currency quotes). `say()` shows
immediately and fades in 2.5 s, no queue. See [[Sistema - Balão de Fala (EN)]].

## i18n for scripts
`zimmy.lang_text(pt, en)` (zimmy.gd:472), `zimmy.lang` (`"pt"`/`"en"`), and localized
formatters `fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (comma vs dot and
`DD/MM/YYYY` vs `MM/DD/YYYY`). See [[Sistema - Menu de Contexto (EN)]] (language switch).

## Web, system and credentials
- **Web:** `http_get_json(url, cb)` (zimmy.gd:1633) → `cb.call(ok, data)`.
- **Authenticated web:** `http_get_auth(url, user, pass, cb)` (zimmy.gd:1656) → HTTP Basic,
  `cb.call(status, body)`. Used by Gmail ([[Sistema - E-mails (EN)]]).
- **System:** GDScript can use `OS.execute`/`OS.create_process` (e.g. `desligar_pc.gd`,
  `alarme.gd`).
- **Credentials:** `with_credentials(key, title, cb)` (zimmy.gd:1869) hands over saved
  credentials or opens the login dialog; `confirm_credentials(key, data)` saves only if new;
  `forget_credentials(key)` clears them. Stored in `user://cred_<key>.json` (gitignored).
- **Badges/sound:** `set_automation_badge(key, text)` (zimmy.gd:1678) updates the label and,
  when the value grows, plays the matching submenu's sound alert.

## Bundled scripts (`Automacoes/`)
`alarme.gd` (daily@08:00), `auto_alimentar.gd` (20s), `comemoracao_hora_cheia.gd`
(hourly), `desligar_pc.gd` (daily@23:00) + `cancelar_desligamento.gd`,
`lembrete_pomodoro.gd` (25m), `email_gmail.gd` ([[Sistema - E-mails (EN)]]), `whatsapp.gd`,
`cotacao_usd/eur/gbp/jpy/cny.gd` ([[Sistema - Moedas (EN)]]). Template: `exemplo_automacao.gd.example`.

Related: [[Entrada - Itens do Menu (EN)]], [[Entrada - Funções de Ação (EN)]], [[Home (EN)]].
