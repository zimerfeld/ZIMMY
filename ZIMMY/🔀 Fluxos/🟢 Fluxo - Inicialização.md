---
tipo: fluxo
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [fluxo, ciclo-de-vida, zimmy-pet]
---

# 🟢 Fluxo - Inicialização (`_ready`)

> 🇪🇸 Lee esta página en español → [[🟢 Fluxo - Inicialização (ES)]]

`_ready()` (`zimmy.gd:198`) roda uma vez ao abrir.

1. **Transparência/overlay** — `gui_embed_subwindows=false`, `transparent_bg`,
   `FLAG_TRANSPARENT`, clear color zero. Ver [[🪟 Sistema - Janela Overlay]].
2. **Configs iniciais** — `current = _default_cfg()`, `current_acc = _default_acc()`.
3. **Carrega disco** — `_load_pets_from_disk()`, `_load_accessories_from_disk()` e
   `_load_selection()` (restaura a escolha ativa de pet/acessório salva em
   `settings.json`, antes de montar o menu p/ os checks ✓ baterem)
   ([[💾 Sistema - Persistência]]).
4. **Posição** — `get_window().size = (win_w, win_h)`; se `_load_window_pos()` achar
   `settings.json`, usa a âncora salva; senão **centraliza o corpo do pet** na tela.
   `start_pos` é clampado à tela. Ver [[🖱️ Fluxo - Arrastar e Posição]].
5. **Balão de fala** — cria o `Label` com contorno/fonte padrão
   ([[💬 Sistema - Balão de Fala]]).
6. **UI** — `_build_menu()` + `_build_save_dialog()` ([[🧭 Sistema - Menu de Contexto]]).
7. **Saudação** — `say("olá! eu sou o Zimmy 🧡")`.

Depois disso, [[🔁 Fluxo - Loop (_process)]] assume.
