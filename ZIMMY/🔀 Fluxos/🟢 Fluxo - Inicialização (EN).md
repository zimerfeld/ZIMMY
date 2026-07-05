---
tipo: fluxo
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [fluxo, ciclo-de-vida, zimmy-pet]
---

# 🟢 Flow - Initialization (`_ready`)

`_ready()` (`zimmy.gd:198`) runs once when the app opens.

1. **Transparency/overlay** — `gui_embed_subwindows=false`, `transparent_bg`,
   `FLAG_TRANSPARENT`, clear color zero. See [[🪟 Sistema - Janela Overlay (EN)]].
2. **Initial configs** — `current = _default_cfg()`, `current_acc = _default_acc()`.
3. **Loads from disk** — `_load_pets_from_disk()`, `_load_accessories_from_disk()` and
   `_load_selection()` (restores the active pet/accessory choice saved in
   `settings.json`, before building the menu so the ✓ checks line up)
   ([[💾 Sistema - Persistência (EN)]]).
4. **Position** — `get_window().size = (win_w, win_h)`; if `_load_window_pos()` finds
   `settings.json`, it uses the saved anchor; otherwise it **centers the pet's body** on the screen.
   `start_pos` is clamped to the screen. See [[🖱️ Fluxo - Arrastar e Posição (EN)]].
5. **Speech bubble** — creates the `Label` with the default outline/font
   ([[💬 Sistema - Balão de Fala (EN)]]).
6. **UI** — `_build_menu()` + `_build_save_dialog()` ([[🧭 Sistema - Menu de Contexto (EN)]]).
7. **Greeting** — `say("olá! eu sou o Zimmy 🧡")`.

After that, [[🔁 Fluxo - Loop (_process) (EN)]] takes over.
