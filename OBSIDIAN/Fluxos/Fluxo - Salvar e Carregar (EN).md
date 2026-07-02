---
tags: [fluxo, persistencia, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 💾 Flow - Save and Load

Pets and accessories are saved/loaded **independently**. See
[[Sistema - Persistência (EN)]] and [[Sistema - Menu de Contexto (EN)]].

## Save
1. Menu "💾 Salvar Pet..." or "🎀 Salvar Acessório..." → `_open_save_dialog(mode, "save")`.
2. `_open_save_dialog` **freezes only the generation of the type being saved** (`_set_random_pet`
   or `_set_random_acc` `(false)`), adjusts the title/placeholder according to `save_mode`,
   **pre-fills** the box with the generated item's suggested name
   (`suggested_pet_name`/`suggested_acc_name`, selected for easy replacement), centers and
   opens the dialog. See [[Fluxo - Geração Aleatória (EN)]].
3. Confirm → `_on_save_confirmed`:
   - validates the name (rejects empty, `Default`, `Selecione...`, `Nenhum`);
   - `pet`: **`_set_random_pet(false)`** (unchecks "🐶 Gerar pets"),
     `saved_pets[nm] = current.duplicate(true)`, `current_pet_name = nm` (becomes the active one →
     the item changes to "Renomear") → `_save_pets_to_disk` → `_rebuild_pets_menu` →
     `_save_settings`;
   - `acc`: **`_set_random_acc(false)`** (unchecks "🎲 Gerar acessórios"), same for
     `saved_accessories` → `_save_accessories_to_disk` → `_rebuild_acc_menu` →
     `_save_settings`.

## Rename (already-saved item)
When the displayed pet/accessory is already saved, the menu item changes to **Renomear** (same
icon), via `_refresh_save_labels()`. `_open_save_dialog(mode, "rename")` pre-fills the
current name; confirm → `_on_save_confirmed` → `_do_rename(new)`:
- validates; ignores if the name didn't change; **rejects an already-existing name**;
- `_rename_key()` swaps the key **preserving the order** of the dropdown; updates
  `current_*_name`, rewrites the JSON + `settings.json` and rebuilds the menu.

## Load
- **Pet**: submenu "📂 Escolher pet" → `_on_pick_pet(id)`. `Default` (1) returns to the
  default config; saved ones (100+) load `saved_pets`. Turns off pet generation only.
- **Accessory**: submenu "🧳 Escolher acessório" → `_on_pick_acc(id)`. `Nenhum` (1)
  clears; saved ones load `saved_accessories`. Turns off accessory generation and **turns on
  the display**.

> `Selecione...` (id 0) in both is just a disabled label.
Initial load from disk: [[Fluxo - Inicialização (EN)]].

## Delete (permanent)
- Submenus **🗑️ Excluir pet** (`pets_del_menu`) / **🗑️ Excluir acessório**
  (`acc_del_menu`) list **only the saved ones** — `Default`/`Nenhum`/`Selecione...` are
  **untouchable** and never appear.
- `_on_del_pet`/`_on_del_acc` → `_open_delete_dialog(mode, name)` (confirmation).
- `_on_delete_confirmed`: `erase(name)` in `saved_pets`/`saved_accessories`, rewrites the
  JSON (`_save_*_to_disk`), rebuilds the menus and **always reloads the Default**
  (`_default_cfg`/`_default_acc`, `current_*_name` = `Default`/`Nenhum`), turning off
  random mode (`_set_random_*(false)`) and persisting via `_save_settings`.

## Choice remembered across sessions
- `_on_pick_pet` and `_on_pick_acc` call `_save_settings()` at the end, writing the
  choice (`pet`/`acc`/`show_acc`) to `settings.json` ([[Sistema - Persistência (EN)]]).
- On the next opening, `_load_selection()` restores the chosen pet/accessory and it
  reappears **pre-selected** (✓) in the dropdown. See [[Fluxo - Inicialização (EN)]].
