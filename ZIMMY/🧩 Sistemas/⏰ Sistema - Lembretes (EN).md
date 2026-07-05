---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, lembretes, agendador, usuario, zimmy-pet]
---

# ⏰ System - Reminders (user recurring)

Recurring reminders the **user creates through the UI, with no `.gd` editing**. It's a
**native** system (it does NOT use the `Automacoes/` folder), so it works in the exported
`.exe`. It mirrors the Notes pattern (item created via dialog, persisted, submenu + delete)
and reuses the **scheduler clock** from [[⚙️ Sistema - Automações e Agendador (EN)]].

## ⏰ Reminders submenu — `_rebuild_reminders_menu()` (zimmy.gd:1460)
Item `MI_REMINDERS=23` (zimmy.gd:277), right below **⏱️ Timers**. Holds: **➕ New reminder…**
(`REM_NEW`), the reminders as **checkable** items (✓ = on) and **🗑️ Delete reminder ▸**
(`REM_DEL`, subsubmenu). Each reminder shows `⏰ <message> · <frequency>`
(`_reminder_label`). Empty → disabled label.

## 🗃️ Data model and persistence
`reminders: Array` of `{text, sched, on}`, persisted in `user://reminders.json`
(`_save_reminders`/`_load_reminders`, zimmy.gd:1679). `sched` is a **frequency string**
(e.g. `"30m"`, `"hourly"`, `"daily@08:00"`). `reminder_defs` (parallel) holds the parsed
descriptor and `reminder_rt` the runtime (accum/last_day/last_hour) of enabled ones —
recomputed by `_refresh_reminder_defs()` after any load/add/delete/toggle.

## 🆕 Creation dialog — `_build_reminders_dialog()` / `_open_reminder_dialog()` (zimmy.gd:1574)
`ConfirmationDialog` with: **message** (`LineEdit`) + **frequency** (`OptionButton` with
presets: every 15/30 min, 1 h, on the hour, **daily at…**) + **time HH:MM** (`LineEdit`,
shown only for the daily preset — `_on_reminder_freq_changed`). On confirm
(`_on_reminder_confirmed`, zimmy.gd:1630) it builds the `sched` from the preset, validates
(`_parse_hhmm` for the time; `_parse_schedule_str` for the frequency) and adds the reminder.

## 🔔 Firing — `_tick_reminders(delta)` (zimmy.gd:1538)
Called each frame by `_process` (only if there are reminders). It walks the **enabled** ones
and, per `def` (interval/hourly/daily), uses the **same logic** as `_tick_schedules`; when
the frequency is hit it calls `_fire_reminder(i)`, which does `notify("⏰ " + text)` — enters
the **speech queue** (~5 s), see [[💬 Sistema - Balão de Fala (EN)]].

## ♻️ Reuse — `_parse_schedule_str()` (zimmy.gd:1767)
The frequency parser was **extracted** from `_parse_schedule` into a function taking the raw
string, now **shared** between automations (`const SCHEDULE`) and reminders. No duplicated
logic.

> Bilingual (EN/PT): all labels/messages via `t()`; the submenu and dialog re-translate on
> language switch ([[🧭 Sistema - Menu de Contexto (EN)]]).

Related: [[⚙️ Sistema - Automações e Agendador (EN)]], [[🚪 Entrada - Itens do Menu (EN)]], [[🏠 Home (EN)]].
