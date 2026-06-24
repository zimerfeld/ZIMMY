---
tags: [endpoint, menu, zimmy-pet]
atualizado: 2026-06-24
lang: en
---

# 🚪 Entry Point - Menu Items

Endpoints triggered by the context menu. `MI_*` ids dispatched in `_on_menu(id)`
(`zimmy.gd:306`). Submenus have their own handlers. See [[Sistema - Menu de Contexto (EN)]].

## Main menu (`_on_menu`)
| id | const | label | action |
|---|---|---|---|
| 0 | `MI_FEED` | 🦴 Alimentar | `feed()` |
| 1 | `MI_PET` | 🤚 Carinho | `pet()` |
| 2 | `MI_PLAY` | 🎾 Brincar | `play()` |
| 3 | `MI_RANDOM` | 🐶 Gerar pets | `_set_random_pet(!on)` |
| 10 | `MI_RANDOM_ACC` | 🎲 Gerar acessórios | `_set_random_acc(!on)` |
| 4 | `MI_SHOW_ACC` | 👓 Mostrar acessórios | `_set_show_accessories(!on)` |
| 16 | `MI_STATUS` | 📊 Status | `_set_show_status(!on)` (bars; OFF default, persisted) |
| 5 | `MI_SAVE_PET` | 💾 Salvar/Renomear Pet... | `_open_save_dialog("pet", save\|rename)` |
| 6 | `MI_CHOOSE_PET` | 📂 Escolher pet ▸ | submenu `pets_menu` |
| 13 | `MI_DEL_PET` | 🗑️ Excluir pet ▸ | submenu `pets_del_menu` |
| 7 | `MI_SAVE_ACC` | 🎀 Salvar/Renomear Acessório... | `_open_save_dialog("acc", save\|rename)` |
| 8 | `MI_CHOOSE_ACC` | 🧳 Escolher acessório ▸ | submenu `acc_menu` |
| 14 | `MI_DEL_ACC` | 🗑️ Excluir acessório ▸ | submenu `acc_del_menu` |
| 11 | `MI_AUTOMATIONS` | ⚙️ Automações ▸ | submenu `automations_menu` (only the **one-off** ones, ▶ play icon; disabled if there are no one-off automations) |
| 21 | `MI_TIMERS` | ⏱️ Timers ▸ | submenu `timers_menu` (right below ⚙️ Automations; only the **scheduled** ones, checkable with clock icon + frequency in the label — visual scheduler; disabled if there are no scheduled automations) |
| 17 | `MI_MOEDAS` | 💱 Currencies ▸ | submenu `moedas_menu` (main-menu item right below ⏱️ Timers; disabled if there are no rates) |
| 18 | `MI_NOTES` | 📝 Notes ▸ | submenu `notes_menu` → `_on_pick_note` (new/paste/copy) + `🗑️ Delete note` (`notes_del_menu` → `_on_del_note`) |
| 12 | `MI_EMAIL` | 📧 E-mails ▸ | submenu `email_menu` (🔊 Sound alert on top + Gmail, Atom feed) |
| 19 | `MI_WHATSAPP` | 💬 WhatsApp ▸ | submenu `whatsapp_menu` (drop-in `whatsapp.gd`, `MENU_GROUP="whatsapp"`; 🔊 Sound alert on top + reads the WhatsApp Web window title) |
| 15 | `MI_LANG` | 🌐 Idioma ▸ | submenu `lang_menu` → `_on_pick_language` |
| 20 | `MI_DONATE` | ❤️ Donate ▸ | submenu `donate_menu` → `_on_pick_donate` (GitHub Sponsors / Ko-fi via `OS.shell_open`) |
| 9 | `MI_QUIT` | Sair | `get_tree().quit()` |

## Submenus
- `_on_pick_pet(id)`: 0=`Selecione...` (ignored), 1=`Default`, 100+=saved
  (`pet_menu_ids`). Updates `current_pet_name` and highlights the active option via
  `_refresh_pets_menu_checks()` (radio-check ✓).
- `_on_pick_acc(id)`: 0=`Selecione...`, 1=`Nenhum` (clears), 100+=saved
  (`acc_menu_ids`). Updates `current_acc_name` and highlights the active option via
  `_refresh_acc_menu_checks()`.
- `_on_del_pet(id)` / `_on_del_acc(id)`: 100+=saved (`pet_del_ids`/`acc_del_ids`) →
  `_open_delete_dialog(mode, name)`. Only saved items reach this (Default/Nenhum/Selecione
  don't enter the delete submenus). Confirm → `_on_delete_confirmed` deletes,
  rewrites the JSON and reverts the active selection to Default/Nenhum if applicable.
- `_on_pick_automation(id)` (serves both `automations_menu` and `timers_menu`):
  100+=scripts from `Automacoes/` (`automation_ids` → path). **One-off** →
  `_run_automation` (loads and calls `run(self)`). **Scheduled** (in `schedule_defs`) →
  toggles `_set_automation_enabled(path, !on)` (✓ persisted in `user://schedules.json`);
  the recurring trigger is handled by `_tick_schedules` in `_process`. Also handles the
  **🔊 Sound alert** toggles `SND_WHATSAPP=50` / `SND_GMAIL=51` (below 100), which flip
  `whatsapp_sound_on` / `gmail_sound_on` (persisted in settings.json as `wa_sound` /
  `gmail_sound`). Both submenus are rebuilt by `_rebuild_automations_menu()` on every
  opening: default-group scripts with `SCHEDULE`/`SCHEDULE_SECONDS` go to ⏱️ Timers (clock
  icon), the one-off ones stay in ⚙️ Automations (▶ play icon); items with `MENU_GROUP`
  (currencies/email/whatsapp) remain in their own submenus even when scheduled.

> **Save vs Rename**: `MI_SAVE_PET`/`MI_SAVE_ACC` change to "Renomear" (same icon)
> when the displayed item is already saved — `_refresh_save_labels()` adjusts the label before
> opening the menu; `_on_save_confirmed` → `_do_rename` when `save_action == "rename"`.

Flows: [[Fluxo - Salvar e Carregar (EN)]], [[Fluxo - Geração Aleatória (EN)]],
[[Fluxo - Interação e Limites (EN)]].
