---
tipo: arquivo-chave
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [arquivo, codigo, zimmy-pet]
caminho: zimmy.gd
linguagem: GDScript
---

# 📄 zimmy.gd

`extends Node2D` — the **entire** app lives here (~908 lines). Attached to the root scene
[[📄 main.tscn (EN)]]. No external dependencies beyond the Godot API.

## 🗺️ Section map (in file order)
1. **Constants** — size/scale, speech, `user://` files, colors, menu ids.
2. **State** (`var`) — `current`, `current_acc`, `saved_pets`, `saved_accessories`,
   random flags, mood/hunger, animation, dragging, layout, UI.
3. **Pet config** — `_default_cfg()`, `_random_cfg()` → [[🐾 Sistema - Pets (EN)]]
4. **Accessory config** — `_default_acc()`, `_random_acc()` → [[🎀 Sistema - Acessórios (EN)]]
5. **`_ready()`** → [[🟢 Fluxo - Inicialização (EN)]]
6. **Menu/UI** — `_build_menu`, `_rebuild_pets_menu`, `_rebuild_acc_menu`,
   `_build_save_dialog`, handlers → [[🧭 Sistema - Menu de Contexto (EN)]]
7. **Setters** — `_set_random_pet`, `_set_random_acc`, `_set_show_accessories`,
   `_open_save_dialog`, `_on_save_confirmed`, `_do_rename`, `_on_delete_confirmed`
8. **Persistence** — `_cfg_to_json`, `_json_to_cfg`, `_save_dict_to_disk`,
   load/save of pets/accessories, `_read_json`, `_save/_load_window_pos`
   → [[💾 Sistema - Persistência (EN)]]
9. **`_process()`** → [[🔁 Fluxo - Loop (_process) (EN)]]
10. **`_relayout()`** → [[🪟 Sistema - Janela Overlay (EN)]] / [[💬 Sistema - Balão de Fala (EN)]]
11. **`_draw()` + helpers** — mouth, eyelashes, antennae, accessories, primitives
    (`_ellipse/_dome/_triangle/_star/_quad`) → [[🎨 Sistema - Render (_draw) (EN)]]
12. **`_input()`** → [[🚪 Entrada - Eventos de Input (EN)]] / [[🖱️ Fluxo - Arrastar e Posição (EN)]]
13. **Actions** — `_can_act`, `_complain`, `feed/pet/play/_react`, `hop`, `say`
    → [[😤 Sistema - Interação e Mau Humor (EN)]] / [[🚪 Entrada - Funções de Ação (EN)]]

## 📝 Notes
- The logical drawing space is 200×200; displayed at `PET_SCALE=0.75` (≈150 px).
- Persistence in `user://` (on Windows: `%APPDATA%\Godot\app_userdata\Zimmy Pet\`).
- `_*` functions are private; public ones: `feed`, `pet`, `play`, `hop`, `say`.
