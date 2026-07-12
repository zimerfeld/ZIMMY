---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, ciclo-de-vida, zimmy-pet]
---

# 🟢 Flujo - Inicialización (`_ready`)

> 🇧🇷 Lee esta página en portugués → [[🟢 Fluxo - Inicialização]]
> 🇺🇸 Read this page in English → [[🟢 Fluxo - Inicialização (EN)]]

`_ready()` (`zimmy.gd:198`) se ejecuta una vez al abrir.

1. **Transparencia/overlay** — `gui_embed_subwindows=false`, `transparent_bg`,
   `FLAG_TRANSPARENT`, clear color a cero. Ver [[🪟 Sistema - Janela Overlay (ES)]].
2. **Configuraciones iniciales** — `current = _default_cfg()`, `current_acc = _default_acc()`.
3. **Carga desde el disco** — `_load_pets_from_disk()`, `_load_accessories_from_disk()` y
   `_load_selection()` (restaura la elección activa de pet/accesorio guardada en
   `settings.json`, antes de montar el menú para que los checks ✓ coincidan)
   ([[💾 Sistema - Persistência (ES)]]).
4. **Posición** — `get_window().size = (win_w, win_h)`; si `_load_window_pos()` encuentra
   `settings.json`, usa el ancla guardada; si no, **centra el cuerpo del pet** en la pantalla.
   `start_pos` se limita a la pantalla. Ver [[🖱️ Fluxo - Arrastar e Posição (ES)]].
5. **Globo de diálogo** — crea el `Label` con contorno/fuente por defecto
   ([[💬 Sistema - Balão de Fala (ES)]]).
6. **UI** — `_build_menu()` + `_build_save_dialog()` ([[🧭 Sistema - Menu de Contexto (ES)]]).
7. **Saludo** — `say("olá! eu sou o Zimmy 🧡")`.

Después de esto, [[🔁 Fluxo - Loop (_process) (ES)]] toma el control.
