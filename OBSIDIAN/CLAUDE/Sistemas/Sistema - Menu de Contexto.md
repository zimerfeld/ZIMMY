---
tags: [sistema, ui, menu, zimmy-pet]
atualizado: 2026-06-20
---

# 🧭 Sistema - Menu de Contexto

`PopupMenu` nativo (botão direito) com dois submenus (`pets_menu`, `acc_menu`) e um
`ConfirmationDialog` para salvar. Montado em `_build_menu()` (`zimmy.gd:242`).
Subjanelas são nativas (`gui_embed_subwindows = false`).

## Itens e ids (`MI_*`) — ver [[Entrada - Itens do Menu]]
```
🦴 Alimentar (0)   🤚 Carinho (1)   🎾 Brincar (2)
──
🎲 Gerar pets (3, check)
🎲 Gerar acessórios (10, check)
👓 Mostrar acessórios (4, check, default on)
──
💾 Salvar Pet... (5)
📂 Escolher pet ▸ (6)      → submenu pets_menu
🎀 Salvar Acessório... (7)
🧳 Escolher acessório ▸ (8) → submenu acc_menu
──
Sair (9)
```

## Submenus
- **pets_menu** (`_rebuild_pets_menu`): `Selecione...` (0, desabilitado, rótulo),
  `Default` (1), depois salvos (ids 100+ ↔ `pet_menu_ids`). Handler `_on_pick_pet`.
- **acc_menu** (`_rebuild_acc_menu`): `Selecione...` (0), `Nenhum` (1, limpa), salvos
  (100+ ↔ `acc_menu_ids`). Handler `_on_pick_acc`.

## Diálogo de salvar
`_build_save_dialog` + `_open_save_dialog(mode)` reaproveitam o mesmo
`ConfirmationDialog` para "pet" ou "acc" (`save_mode`). Abrir **desliga a geração
automática** (`_stop_random_all`) para salvar o que está na tela. Valida nome em
`_on_save_confirmed` (rejeita vazio/`Default`/`Selecione...`/`Nenhum`).

Relacionado: [[Sistema - Pets]], [[Sistema - Acessórios]],
[[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]].
