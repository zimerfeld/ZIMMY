---
tags: [sistema, ui, menu, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🧭 System - Context Menu

Native `PopupMenu` (right-click) with submenus (`pets_menu`, `acc_menu`,
`pets_del_menu`, `acc_del_menu`) and two `ConfirmationDialog`s (save / delete).
Assembled in `_build_menu()` (`zimmy.gd:242`).
Subwindows are native (`gui_embed_subwindows = false`).

## Positioning (on open)
On right-click, before `popup()`: `_rebuild_automations_menu()`,
`_refresh_save_labels()`, `menu.reset_size()` and then
`menu.position = _context_menu_position(menu.size)`. **`_context_menu_position`** computes
the pet's actual rectangle on screen (`get_window().position + (pet_x, pet_y)`, `PET_DRAW²`)
and tests candidates **right → left → below → above** (8px gap): it returns the
first one that **fits in the usable area** (`screen_get_usable_rect().encloses`) and **does
not cover the pet** (`!intersects`). With no perfect fit, it clamps the right-side
candidate to the edges.

## Items and ids (`MI_*`) — see [[Entrada - Itens do Menu (EN)]]
```
📊 Status (16, check, OFF default, persisted) → shows/hides the bars
🦴 Feed (0)   🤚 Pet (1)   🎾 Play (2)   ← same group (no separator)
──
🎲 Generate pets (3, check)
🎲 Generate accessories (10, check)
👓 Show accessories (4, check, default on)
──
💾 Save Pet... (5)
📂 Choose pet ▸ (6)      → submenu pets_menu
🗑️ Delete pet ▸ (13)      → submenu pets_del_menu
🎀 Save Accessory... (7)
🧳 Choose accessory ▸ (8) → submenu acc_menu
🗑️ Delete accessory ▸ (14) → submenu acc_del_menu
──
⚙️ Automations ▸ (11) → submenu automations_menu
   └ 💱 Currencies ▸ (17) → submenu moedas_menu (rates; only shown if any exist)
📝 Notes ▸ (18) → submenu notes_menu (text scratchpad; manual + clipboard)
📧 E-mails ▸ (12) → submenu email_menu
💬 WhatsApp ▸ (19) → submenu whatsapp_menu (unread chats, read from the window title)
🌐 Language ▸ (15) → submenu lang_menu
──
Quit (9)
```

## Language (i18n)
All system texts come from the `STRINGS`/`STRING_LISTS` table (pt/en) via `t(key)`
/`ta(key)`. The **🌐 Language** submenu (`lang_menu`) has two radio-checks
(`LANG_PT`/`LANG_EN`); `_on_pick_language` switches `lang`, persists it (`_save_settings`,
key `lang` in settings.json) and calls `_apply_menu_labels()` (reapplies the menu labels
+ submenus + dialogs). `lang` is loaded in `_load_selection()` **before**
`_build_menu()`. The pet's speech (`say`) and lists (mood/feed/pet/play) also use
`t`/`ta`. See [[Glossário de Configs (EN)]] and [[Sistema - Persistência (EN)]].

## Submenus
- **pets_menu** (`_rebuild_pets_menu`): `Selecione...` (0, disabled, label),
  `Default` (1), then saved ones (ids 100+ ↔ `pet_menu_ids`). Handler `_on_pick_pet`.
  `Default`/saved are **radio-check items**; the active option is marked (✓) via
  `_refresh_pets_menu_checks()` according to `current_pet_name` (`""` when the pet is
  random → nothing marked).
- **acc_menu** (`_rebuild_acc_menu`): `Selecione...` (0), `Nenhum` (1, clears), saved
  (100+ ↔ `acc_menu_ids`). Handler `_on_pick_acc`. `Nenhum`/saved are radio-check;
  the active option is highlighted via `_refresh_acc_menu_checks()` (`current_acc_name`, `""`
  when random).
- **pets_del_menu / acc_del_menu** (`_rebuild_pets_del_menu`/`_rebuild_acc_del_menu`,
  called at the end of the respective `_rebuild_*_menu`): list **only the saved items**
  (ids 100+ ↔ `pet_del_ids`/`acc_del_ids`) — `Default`/`Nenhum`/`Selecione...` **never
  appear** (untouchable). With no items, they show a disabled label "(no … saved)".
  Handlers `_on_del_pet`/`_on_del_acc` open the `delete_dialog`; on confirm,
  `_on_delete_confirmed` deletes from `saved_pets`/`saved_accessories`, rewrites the JSON and
  **always reloads the Default** (`Default`/`Nenhum`). See [[Fluxo - Salvar e Carregar (EN)]].
- **automations_menu** (`_rebuild_automations_menu`): `.gd` scripts from
  `res://Automacoes/` (ids 100+ ↔ `automation_ids` → path). `_scan_automations()`
  lists `{name, path, sched}` and fills `schedule_defs`. **Standalone** (no `SCHEDULE`)
  → normal item; handler `_on_pick_automation` → `_run_automation` (instantiates and calls
  `run(self)`). **Scheduled** (with `SCHEDULE`) → `add_check_item` (✓ = on, label
  with the frequency); the handler toggles `_set_automation_enabled(path, on)`. The
  **⚙️ Automations** item is **disabled** when the folder has no scripts (neither
  standalone nor currencies); the submenu is rescanned every time the menu opens (on
  right-click).
- **moedas_menu** (part of `_rebuild_automations_menu`): scripts with
  `MENU_GROUP := "moedas"` (the `cotacao_*` rates) are routed to the **💱 Currencies**
  submenu (`MI_MOEDAS = 17`), nested at the top of **⚙️ Automations**. The submenu item
  is only created when at least one rate exists; same handler `_on_pick_automation`.
- **notes_menu** (`_rebuild_notes_menu`): a small text scratchpad (`MI_NOTES = 18`), above
  📧 E-mails. Fixed items `➕ New note...` (`NOTE_NEW`) and `📋 Paste from clipboard`
  (`NOTE_PASTE`); then the note list (ids 100+ ↔ `note_ids` → index in `notes`) — **clicking
  copies** the text back to the clipboard (`DisplayServer.clipboard_set`). Subsubmenu
  `🗑️ Delete note` (`notes_del_menu`, `MI_NOTES_DEL`, ids 100+ ↔ `note_del_ids`) removes a
  note. With no notes, shows a disabled `(no notes)` label. `➕ New note...` opens
  `notes_dialog` (a ConfirmationDialog with a multiline `TextEdit`); `📋 Paste` reads
  `DisplayServer.clipboard_get()`. Persistence: `user://notes.json` (array of strings —
  `_save_notes`/`_load_notes`). The menu preview is single-line (`_note_preview`: strips
  newlines, caps at 40 chars).

## Automations + Scheduler (folder `Automacoes/`)
Drop-in scripts: each `.gd` in `Automacoes/` with `run(zimmy)` becomes an item.
`extends RefCounted` is discarded after `run()`; `extends Node` is added as a child
and persists. **Scheduler**: an automation with `const SCHEDULE` (`"30s"`/`"5m"`/`"2h"`/
`"hourly"`/`"daily@HH:MM"`, or `SCHEDULE_SECONDS`) runs on its own — `_parse_schedule()`
generates `{kind, every, at_minute, label}`; `_tick_schedules(delta)` (in `_process`) fires
via `_fire_automation()`; the on/off state persists in `user://schedules.json`
(`_load_schedules`/`_save_schedules`, `automation_enabled`/`sched_runtime`).
**Web/system**: automations can use `zimmy.http_get_json(url, cb)` (a helper that
wraps `HTTPRequest` → JSON) and `OS.execute/create_process`. Examples: `auto_alimentar`,
`lembrete_pomodoro`, `comemoracao_hora_cheia`, `cotacao_usd/eur/gbp/jpy/cny` (AwesomeAPI,
the "currency submenu"), `desligar_pc`/`cancelar_desligamento` (`shutdown`), `alarme`.

**i18n in automations**: the menu name is bilingual — `_automation_name_from` uses
`AUTOMATION_NAME_EN` when `lang == "en"` (otherwise `AUTOMATION_NAME`). Speech uses the
helpers `zimmy.lang_text(pt, en)` / `zimmy.lang`; currency values and dates use
`zimmy.fmt_num`/`fmt_pct`/`fmt_money_brl`/`fmt_quote_date` (decimal separator and date
format per language). `_apply_menu_labels()` calls `_rebuild_automations_menu()`, so the
names switch language immediately. Contract in `Automacoes/LEIAME.md`.

## 📧 E-mails submenu (groups, badges, credentials)
Optional consts read in the scan: `MENU_GROUP` (routes to a dedicated submenu — `email` →
`email_menu`; `moedas` → `moedas_menu`, nested in ⚙️ Automations; `whatsapp` →
`whatsapp_menu`, top-level `MI_WHATSAPP = 19`), `ICON_COLOR` (icon on the left via `add_icon_check_item` + `_provider_icon`,
cached), `BADGE_KEY` (label shows `automation_badges[key]`, set by
`set_automation_badge`), `CRED_KEY` (credential file). Maps: `automation_groups`,
`automation_icon_colors`, `automation_badge_keys`, `automation_cred_keys`,
`automation_item_menu` (id → menu where the item lives, to mark the ✓ in the right menu).
**Credentials** (`CRED_PREFIX = user://cred_`): `with_credentials(key, title, cb, help_steps:="", help_url:="")`/`confirm_credentials`/
`forget_credentials`/`load`/`save`; `cred_dialog` dialog (optional step-by-step `cred_help` +
`cred_link`→`OS.shell_open(help_url)` at the top, e-mail + masked App Password). `email_gmail`
passes the step-by-step on how to generate the App Password (shown the first time);
asks when turning on if none is saved, writes only after validating. **Gmail**
(`email_gmail`) uses the **Atom feed**: `http_get_auth(url, user, pass, cb)` (GET with
`Authorization: Basic`, returns `cb.call(status, body)`) on `mail/feed/atom`, and a regex
extracts `<fullcount>N</fullcount>` — no IMAP. **Outlook** (`email_outlook`) uses **IMAP**:
`imap_unread(host, port, user, pass, cb)` (TCP+TLS, `LOGIN` + `STATUS INBOX (UNSEEN)`). Both
require an App Password (Basic for the feed, `LOGIN` for IMAP). Contract in
`Automacoes/LEIAME.md`.

## 💬 WhatsApp submenu (unread chats)
Drop-in `whatsapp.gd` (`MENU_GROUP = "whatsapp"` → top-level `💬 WhatsApp` submenu,
`BADGE_KEY`, `ICON_COLOR = 25d366`, `SCHEDULE = "1m"`). **No API and no credentials**:
WhatsApp Web locks the session to the QR-linked browser. The automation only **reads the
window title** (`OS.execute("tasklist", ["/v","/fo","csv","/nh"])`) — when there are unread
chats the title becomes `"(N) WhatsApp"`; a `RegEx` `(?i)\((\d+)\)\s*whatsapp` extracts N
(lowercased / `(?i)` to match any case — `WhatsApp`, `web.whatsapp.com`, the PWA window; no
parens ⇒ 0; window missing ⇒ badge `?` + "isn't open" notice). Passive observation (never
touches WhatsApp servers, doesn't break the ToS). Requires WhatsApp Web open and ideally as
**ONE dedicated window** (`chrome --app=...` shortcut, or ⋮ ▸ Create shortcut ▸ Open as
window): with the normal tab AND a 2nd window open at once, WhatsApp shows "open in another
window" and won't put the `(N)` in the title.

## Save / rename dialog
`_build_save_dialog` + `_open_save_dialog(mode, action)` reuse the same
`ConfirmationDialog` for "pet" or "acc" (`save_mode`) in two actions (`save_action`):
- **save** — opening **freezes only the generation of the type being saved** (`_set_random_pet` or
  `_set_random_acc` `(false)`) to save what is on screen; empty field with
  placeholder. On **confirm**, it unchecks the checkbox of the saved type again.
- **rename** — only when the displayed item **is already saved**; pre-fills the current name
  (`name_edit.select_all()`), "Rename" button.

The menu labels switch **Save → Rename** (same icon 💾/🎀) via
`_refresh_save_labels()`, called before opening the menu (on right-click), according to
`saved_pets.has(current_pet_name)` / `saved_accessories.has(current_acc_name)`.

`_on_save_confirmed` validates the name (rejects empty/`Default`/`Selecione...`/`Nenhum`) and
dispatches: **save** writes `saved_*[name]` (and makes the item active); **rename** calls
`_do_rename` → `_rename_key` (swaps the key **preserving the order** of the dropdown),
rejects a duplicate name, rewrites the JSON + `settings.json` and rebuilds the menus.

## Delete dialog
`_build_delete_dialog` + `_open_delete_dialog(mode, name)` reuse a
`ConfirmationDialog` ("Delete"/"Cancel" buttons) for "pet" or "acc"
(`delete_mode` + `delete_name`). Only saved items reach here, so **there is no way to
delete `Default`/`Nenhum`**. Confirming triggers `_on_delete_confirmed`.

Related: [[Sistema - Pets (EN)]], [[Sistema - Acessórios (EN)]],
[[Fluxo - Salvar e Carregar (EN)]], [[Fluxo - Geração Aleatória (EN)]].
