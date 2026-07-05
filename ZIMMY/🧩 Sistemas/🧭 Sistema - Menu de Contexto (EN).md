---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, ui, menu, zimmy-pet]
---

# 🧭 System - Context Menu

Native `PopupMenu` (right-click) with submenus (`pets_menu`, `acc_menu`,
`pets_del_menu`, `acc_del_menu`) and two `ConfirmationDialog`s (save / delete).
Assembled in `_build_menu()` (`zimmy.gd:242`).
Subwindows are native (`gui_embed_subwindows = false`).

## 📍 Positioning (on open)
On right-click, before `popup()`: `_rebuild_automations_menu()`,
`_refresh_save_labels()`, `menu.reset_size()` and then
`menu.position = _context_menu_position(menu.size)`. **`_context_menu_position`** computes
the pet's actual rectangle on screen (`get_window().position + (pet_x, pet_y)`, `PET_DRAW²`)
keeps the menu **glued to the pet** and decides the **cascade direction** (`lvl = max(menu.x,
300)`, `cascade = 2·lvl` ≈ 2 submenu levels): **(1)** if the cascade fits **to the right** (pet
on the left/center), menu right of the pet, submenus open right (native); **(2)** if it doesn't
fit right but fits **to the left** (pet on the right of the screen), menu left of the pet and
`_cascade_left = true` → submenus open **LEFTWARD**; **(3)** neither (narrow screen) → recede
right as needed (best-effort). If the menu would cover the pet there, it drops below (or above).
**Leftward cascade** (`_flip_submenu_if_left`): since Godot submenus only open rightward, each
submenu (mapped in `_submenu_parent`) connects `about_to_popup` and, when `_cascade_left`,
overrides the **X** to `parent.position.x − sub.size.x` (keeping the Y Godot aligned to the
item). So the menu sits next to the pet on the right and the cascade flows left, without
overlap. Note previews are capped at 30 chars so submenus don't get too wide. The z-order /
mouse-over capture between submenus is native (each is an **OS window**,
`gui_embed_subwindows = false`): the last-opened sits on top and grabs the mouse.

## 🆔 Items and ids (`MI_*`) — see [[🚪 Entrada - Itens do Menu (EN)]]
```
📊 Status (16, check, OFF default, persisted) → shows/hides the bars
🦴 Feed (0)   🤚 Pet (1)   🎾 Play (2)   ← same group (no separator)
🔊 Sound alerts ▸ (22) → submenu sounds_menu (1 toggle per action: Feed/Pet/Play)
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
💱 Currencies ▸ (17) → submenu moedas_menu (rates; main-menu item right below Automations; disabled if none exist)
📝 Notes ▸ (18) → submenu notes_menu (text scratchpad; manual + clipboard)
📧 E-mails ▸ (12) → submenu email_menu (🔊 Sound alert on top + Gmail)
💬 WhatsApp ▸ (19) → submenu whatsapp_menu (🔊 Sound alert on top + unread chats, read from the window title)
🌐 Language ▸ (15) → submenu lang_menu
❤️ Donate ▸ (20) → submenu donate_menu (GitHub Sponsors, Ko-fi — open links)
──
Quit (9)
```

## 🌐 Language (i18n)
All system texts come from the `STRINGS`/`STRING_LISTS` table (pt/en) via `t(key)`
/`ta(key)`. The **🌐 Language** submenu (`lang_menu`) has two radio-checks
(`LANG_PT`/`LANG_EN`); `_on_pick_language` switches `lang`, persists it (`_save_settings`,
key `lang` in settings.json) and calls `_apply_menu_labels()` (reapplies the menu labels
+ submenus + dialogs). `lang` is loaded in `_load_selection()` **before**
`_build_menu()`. The pet's speech (`say`) and lists (mood/feed/pet/play) also use
`t`/`ta`. See [[🗂️ Glossário de Configs (EN)]] and [[💾 Sistema - Persistência (EN)]].

## 📂 Submenus
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
  **always reloads the Default** (`Default`/`Nenhum`). See [[💾 Fluxo - Salvar e Carregar (EN)]].
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
  submenu. This submenu is a **main-menu item** (`MI_MOEDAS := 17`), placed **right below
  ⚙️ Automations** (added in `_build_menu` via
  `menu.add_submenu_node_item(t("mi_moedas"), moedas_menu, MI_MOEDAS)`; in the
  `_submenu_parent` map the parent of `moedas_menu` is the main `menu`, not
  `automations_menu`). The item is **disabled** when there are no rates
  (`menu.set_item_disabled(menu.get_item_index(MI_MOEDAS), n_moedas == 0)`); same handler
  `_on_pick_automation`. Each rate shows a small **flag icon (texture) on the left** via
  `const ICON_FLAG := "us"/"eu"/"gb"/"jp"/"cn"` (read in `_scan_automations` into
  `automation_flags`, drawn by `_flag_icon()` — flag emoji are *regional-indicator* pairs that
  **don't** render in `PopupMenu`, so we draw a pixel texture instead). The names have **no
  emoji** (`AUTOMATION_NAME`: "Cotação USD", "Cotação EUR", ...; EN: "USD rate" etc.). The
  rates **don't use `ICON_COLOR`** (the icon is the `ICON_FLAG` flag).
- **notes_menu** (`_rebuild_notes_menu`): a small text scratchpad (`MI_NOTES = 18`), above
  📧 E-mails. Fixed items `➕ New note...` (`NOTE_NEW`) and `📋 Paste from clipboard`
  (`NOTE_PASTE`); then the note list (ids 100+ ↔ `note_ids` → index in `notes`) — **clicking
  copies** the text back to the clipboard (`DisplayServer.clipboard_set`). Subsubmenu
  `🗑️ Delete note` (`notes_del_menu`, `MI_NOTES_DEL`, ids 100+ ↔ `note_del_ids`) removes a
  note. With no notes, shows a disabled `(no notes)` label. `➕ New note...` opens
  `notes_dialog` (a ConfirmationDialog with a multiline `TextEdit`); `📋 Paste` reads
  `DisplayServer.clipboard_get()`. Persistence: `user://notes.json` (array of strings —
  `_save_notes`/`_load_notes`). The menu preview is single-line (`_note_preview`: strips
  newlines, caps at 30 chars, appending "..." at the end when longer).

## ⚙️ Automations + Scheduler (folder `Automacoes/`)
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
`email_menu`; `moedas` → `moedas_menu`, main-menu item right below ⚙️ Automations; `whatsapp` →
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
extracts `<fullcount>N</fullcount>` — no IMAP. Gmail is the only provider in the submenu;
it requires an App Password (Basic for the feed). Contract in `Automacoes/LEIAME.md`.

## 🔊 Sound alert (unread)
At the **top** of the **💬 WhatsApp** and **📧 E-mails** submenus (before the counter item)
there is a **🔊 Sound alert** checkbox (translation key `mi_sound_alert`, "🔊 Alerta de som" / "🔊 Sound alert"). When the unread
badge **increases** (a new message arrived), Zimmy plays a quiet sound: a ringing phone
(WhatsApp) or a mail delivery (Gmail). The toggles use the ids `SND_WHATSAPP := 50` and
`SND_GMAIL := 51` (below 100, where automation ids begin), handled in `_on_pick_automation`;
the state persists in settings.json as `wa_sound` / `gmail_sound` (variables
`whatsapp_sound_on` / `gmail_sound_on`, on by default). The sound is synthesized in code (no
audio files) via `AudioStreamWAV` in `_build_audio`/`_build_ring_sound`/`_build_chime_sound`/
`_make_wav`/`_play_alert`, played by two `AudioStreamPlayer` nodes
(`_ring_player`/`_chime_player`). Playback is triggered inside `set_automation_badge(key,
text)` upon detecting a numeric increase of the badge for the `whatsapp` or `email_gmail` keys.

## 🔊 Sound alerts for the actions (Feed/Pet/Play)
The **🔊 Sound alerts** submenu (`sounds_menu`, item `MI_SOUNDS := 22`, **right below
🎾 Play**; translation key `mi_sounds`) has **one checkbox per action**: `🦴 Feed`
(`SND_FEED := 1`), `🤚 Pet` (`SND_PET := 2`), `🎾 Play` (`SND_PLAY := 3`) — its own submenu
ids (no clash with automation ids), handler `_on_pick_sound`. Each toggle (`sound_feed_on` /
`sound_pet_on` / `sound_play_on`, **on by default**, persisted in settings.json as
`feed_sound` / `pet_sound` / `play_sound`) governs **two** triggers of the same sound:
- **when you do the action** — `feed()` / `pet()` / `play()` play the player at the end
  ([[🚪 Entrada - Funções de Ação (EN)]]);
- **low-need reminder** — in the decay step (`_process`), when the bar **crosses
  `STAT_LOW = 20` going down** (only on the transition, once per crossing) — see
  [[📊 Sistema - Necessidades (EN)]].

Sounds are **synthesized in code** (`AudioStreamWAV`), in the same style as the WhatsApp/Gmail
ones: `_build_feed_sound` (two low munches), `_build_pet_sound` (a purr — low tone with
tremolo) and `_build_play_sound` (a cheerful rising arpeggio), created in `_build_audio` and
played by `_feed_player` / `_pet_player` / `_play_player` (via `_play_alert`). Labels are
reapplied per language in `_apply_menu_labels`; the submenu joins the `_submenu_parent` map
(leftward cascade).

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

## 💾 Save / rename dialog
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

## 🗑️ Delete dialog
`_build_delete_dialog` + `_open_delete_dialog(mode, name)` reuse a
`ConfirmationDialog` ("Delete"/"Cancel" buttons) for "pet" or "acc"
(`delete_mode` + `delete_name`). Only saved items reach here, so **there is no way to
delete `Default`/`Nenhum`**. Confirming triggers `_on_delete_confirmed`.

Related: [[🐾 Sistema - Pets (EN)]], [[🎀 Sistema - Acessórios (EN)]],
[[💾 Fluxo - Salvar e Carregar (EN)]], [[🎲 Fluxo - Geração Aleatória (EN)]].
