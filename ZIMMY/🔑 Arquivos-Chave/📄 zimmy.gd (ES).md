---
tipo: arquivo-chave
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [arquivo, codigo, zimmy-pet]
caminho: zimmy.gd
linguagem: GDScript
---

# 📄 zimmy.gd

> 🇧🇷 Lee esta página en portugués → [[📄 zimmy.gd]]
> 🇺🇸 Read this page in English → [[📄 zimmy.gd (EN)]]

`extends Node2D` — **todo** el app vive aquí (~908 líneas). Adjunto a la escena raíz
[[📄 main.tscn (ES)]]. Sin dependencias externas más allá de la API de Godot.

## 🗺️ Mapa de secciones (en el orden del archivo)
1. **Constantes** — tamaño/escala, diálogo, archivos `user://`, colores, ids de menú.
2. **Estado** (`var`) — `current`, `current_acc`, `saved_pets`, `saved_accessories`,
   flags de aleatorio, humor/hambre, animación, arrastre, layout, UI.
3. **Config de pet** — `_default_cfg()`, `_random_cfg()` → [[🐾 Sistema - Pets (ES)]]
4. **Config de accesorio** — `_default_acc()`, `_random_acc()` → [[🎀 Sistema - Acessórios (ES)]]
5. **`_ready()`** → [[🟢 Fluxo - Inicialização (ES)]]
6. **Menú/UI** — `_build_menu`, `_rebuild_pets_menu`, `_rebuild_acc_menu`,
   `_build_save_dialog`, handlers → [[🧭 Sistema - Menu de Contexto (ES)]]
7. **Setters** — `_set_random_pet`, `_set_random_acc`, `_set_show_accessories`,
   `_open_save_dialog`, `_on_save_confirmed`, `_do_rename`, `_on_delete_confirmed`
8. **Persistencia** — `_cfg_to_json`, `_json_to_cfg`, `_save_dict_to_disk`,
   load/save de pets/accesorios, `_read_json`, `_save/_load_window_pos`
   → [[💾 Sistema - Persistência (ES)]]
9. **`_process()`** → [[🔁 Fluxo - Loop (_process) (ES)]]
10. **`_relayout()`** → [[🪟 Sistema - Janela Overlay (ES)]] / [[💬 Sistema - Balão de Fala (ES)]]
11. **`_draw()` + helpers** — boca, pestañas, antenas, accesorios, primitivas
    (`_ellipse/_dome/_triangle/_star/_quad`) → [[🎨 Sistema - Render (_draw) (ES)]]
12. **`_input()`** → [[🚪 Entrada - Eventos de Input (ES)]] / [[🖱️ Fluxo - Arrastar e Posição (ES)]]
13. **Acciones** — `_can_act`, `_complain`, `feed/pet/play/_react`, `hop`, `say`
    → [[😤 Sistema - Interação e Mau Humor (ES)]] / [[🚪 Entrada - Funções de Ação (ES)]]

## 📝 Notas
- El espacio lógico de dibujo es 200×200; mostrado a `PET_SCALE=0.75` (≈150 px).
- Persistencia en `user://` (en Windows: `%APPDATA%\Godot\app_userdata\Zimmy Pet\`).
- Las funciones `_*` son privadas; públicas: `feed`, `pet`, `play`, `hop`, `say`.
