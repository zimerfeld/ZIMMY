---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, persistencia, dados, zimmy-pet]
---

# 💾 System - Persistence

Three JSON files in `user://` (on Windows:
`%APPDATA%\Godot\app_userdata\Zimmy Pet\`). Schemas in [[🗂️ Glossário de Configs (EN)]].

| File | Const | Content |
|---|---|---|
| `pets.json` | `PETS_FILE` | `{ name: pet_config }` |
| `accessories.json` | `ACC_FILE` | `{ name: accessory_config }` |
| `settings.json` | `SETTINGS_FILE` | `{ anchor_x, anchor_y, pet, acc, show_acc, lang, status, wa_sound, gmail_sound, feed_sound, pet_sound, play_sound }` (position + active choice + language + status-bars display + WhatsApp/Gmail sound alerts + Feed/Pet/Play action sound alerts) |
| `schedules.json` | `SCHEDULES_FILE` | `{ automation_path: true }` (scheduled, turned on) |
| `cred_<key>.json` | `CRED_PREFIX` | `{ user, pass }` per automation (e-mail), **encrypted** (AES). **Gitignored**, never commit |

## 🎨 Color serialization
- `_cfg_to_json(cfg)` — converts each `Color` into `[r,g,b,a]`; the rest passes through.
- `_json_to_cfg(d, base, color_keys)` — starts from `base` (the default!), and converts
  the keys in `color_keys` back (`PET_COLOR_KEYS` / `ACC_COLOR_KEYS`).
  **This is why old/partial files gain the new keys** without breaking.

## 🔧 Functions (`zimmy.gd:410+`)
- `_save_dict_to_disk(path, store)` + wrappers `_save_pets_to_disk` /
  `_save_accessories_to_disk`. **Deletion**: `_on_delete_confirmed` does
  `saved_pets`/`saved_accessories``.erase(name)` and rewrites via these same wrappers —
  permanent removal from the JSON; see [[💾 Fluxo - Salvar e Carregar (EN)]].
- `_load_pets_from_disk` / `_load_accessories_from_disk` (called in the
  [[🟢 Fluxo - Inicialização (EN)]]).
- `_read_json(path)` — tolerant helper (returns `null` if missing/on error).
- `_save_settings` / `_load_window_pos` — write/read `settings.json`; see
  [[🖱️ Fluxo - Arrastar e Posição (EN)]]. `_save_settings` (formerly `_save_window_pos`) now
  also writes `pet`/`acc`/`show_acc` (the active choice).
- `_load_selection` — restores the pet/accessory choice saved in `settings.json`,
  called in the [[🟢 Fluxo - Inicialização (EN)]] **after** loading the saved ones from disk and **before**
  building the menu (so the ✓ checks reflect the pre-selected option). Empty
  `pet`/`acc` names (random generation) fall back to the default — random is not restorable.
- `_save_schedules` / `_load_schedules` — scheduled automations turned on
  (`automation_enabled`); see [[🧭 Sistema - Menu de Contexto (EN)]].
- `load_credentials` / `save_credentials` / `forget_credentials` — automation
  credentials in `user://cred_<key>.json` (one file per automation, gitignored).
  **Encrypted** with `FileAccess.open_encrypted_with_pass`; the key comes from
  `_cred_key()` = `CRED_SALT` + `OS.get_unique_id()` (not plain text, and not valid on
  another machine). `load_credentials` **migrates** old plain-text files (re-encrypts on
  read). Written only after validation; see [[🧭 Sistema - Menu de Contexto (EN)]].

Writes triggered on: saving a pet/accessory ([[💾 Fluxo - Salvar e Carregar (EN)]]), dropping
the pet after dragging, and **choosing a pet/accessory or toggling 👓 Show accessories**
(each choice calls `_save_settings`).
