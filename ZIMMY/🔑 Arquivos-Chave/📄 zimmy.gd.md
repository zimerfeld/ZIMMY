---
tipo: arquivo-chave
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [arquivo, codigo, zimmy-pet]
caminho: zimmy.gd
linguagem: GDScript
---

# 📄 zimmy.gd

> 🇪🇸 Lee esta página en español → [[📄 zimmy.gd (ES)]]

`extends Node2D` — **todo** o app vive aqui (~908 linhas). Anexado à cena raiz
[[📄 main.tscn]]. Sem dependências externas além da API do Godot.

## 🗺️ Mapa de seções (com a ordem do arquivo)
1. **Constantes** — tamanho/escala, fala, arquivos `user://`, cores, ids de menu.
2. **Estado** (`var`) — `current`, `current_acc`, `saved_pets`, `saved_accessories`,
   flags de aleatório, humor/fome, animação, arrasto, layout, UI.
3. **Config de pet** — `_default_cfg()`, `_random_cfg()` → [[🐾 Sistema - Pets]]
4. **Config de acessório** — `_default_acc()`, `_random_acc()` → [[🎀 Sistema - Acessórios]]
5. **`_ready()`** → [[🟢 Fluxo - Inicialização]]
6. **Menu/UI** — `_build_menu`, `_rebuild_pets_menu`, `_rebuild_acc_menu`,
   `_build_save_dialog`, handlers → [[🧭 Sistema - Menu de Contexto]]
7. **Setters** — `_set_random_pet`, `_set_random_acc`, `_set_show_accessories`,
   `_open_save_dialog`, `_on_save_confirmed`, `_do_rename`, `_on_delete_confirmed`
8. **Persistência** — `_cfg_to_json`, `_json_to_cfg`, `_save_dict_to_disk`,
   load/save de pets/acessórios, `_read_json`, `_save/_load_window_pos`
   → [[💾 Sistema - Persistência]]
9. **`_process()`** → [[🔁 Fluxo - Loop (_process)]]
10. **`_relayout()`** → [[🪟 Sistema - Janela Overlay]] / [[💬 Sistema - Balão de Fala]]
11. **`_draw()` + helpers** — boca, cílios, antenas, acessórios, primitivas
    (`_ellipse/_dome/_triangle/_star/_quad`) → [[🎨 Sistema - Render (_draw)]]
12. **`_input()`** → [[🚪 Entrada - Eventos de Input]] / [[🖱️ Fluxo - Arrastar e Posição]]
13. **Ações** — `_can_act`, `_complain`, `feed/pet/play/_react`, `hop`, `say`
    → [[😤 Sistema - Interação e Mau Humor]] / [[🚪 Entrada - Funções de Ação]]

## 📝 Notas
- Espaço lógico de desenho é 200×200; exibido a `PET_SCALE=0.75` (≈150 px).
- Persistência em `user://` (no Windows: `%APPDATA%\Godot\app_userdata\Zimmy Pet\`).
- Funções `_*` são privadas; públicas: `feed`, `pet`, `play`, `hop`, `say`.
