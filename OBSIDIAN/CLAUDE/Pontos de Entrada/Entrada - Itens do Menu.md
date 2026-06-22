---
tags: [endpoint, menu, zimmy-pet]
atualizado: 2026-06-21
---

# 🚪 Entrada - Itens do Menu

Endpoints acionados pelo menu de contexto. Ids `MI_*` despachados em `_on_menu(id)`
(`zimmy.gd:306`). Submenus têm handlers próprios. Ver [[Sistema - Menu de Contexto]].

## Menu principal (`_on_menu`)
| id | const | rótulo | ação |
|---|---|---|---|
| 0 | `MI_FEED` | 🦴 Alimentar | `feed()` |
| 1 | `MI_PET` | 🤚 Carinho | `pet()` |
| 2 | `MI_PLAY` | 🎾 Brincar | `play()` |
| 3 | `MI_RANDOM` | 🐶 Gerar pets | `_set_random_pet(!on)` |
| 10 | `MI_RANDOM_ACC` | 🎲 Gerar acessórios | `_set_random_acc(!on)` |
| 4 | `MI_SHOW_ACC` | 👓 Mostrar acessórios | `_set_show_accessories(!on)` |
| 5 | `MI_SAVE_PET` | 💾 Salvar/Renomear Pet... | `_open_save_dialog("pet", save\|rename)` |
| 6 | `MI_CHOOSE_PET` | 📂 Escolher pet ▸ | submenu `pets_menu` |
| 13 | `MI_DEL_PET` | 🗑️ Excluir pet ▸ | submenu `pets_del_menu` |
| 7 | `MI_SAVE_ACC` | 🎀 Salvar/Renomear Acessório... | `_open_save_dialog("acc", save\|rename)` |
| 8 | `MI_CHOOSE_ACC` | 🧳 Escolher acessório ▸ | submenu `acc_menu` |
| 14 | `MI_DEL_ACC` | 🗑️ Excluir acessório ▸ | submenu `acc_del_menu` |
| 11 | `MI_AUTOMATIONS` | ⚙️ Automações ▸ | submenu `automations_menu` |
| 12 | `MI_EMAIL` | 📧 E-mails ▸ | submenu `email_menu` |
| 15 | `MI_LANG` | 🌐 Idioma ▸ | submenu `lang_menu` → `_on_pick_language` |
| 9 | `MI_QUIT` | Sair | `get_tree().quit()` |

## Submenus
- `_on_pick_pet(id)`: 0=`Selecione...` (ignora), 1=`Default`, 100+=salvos
  (`pet_menu_ids`). Atualiza `current_pet_name` e realça a opção ativa via
  `_refresh_pets_menu_checks()` (radio-check ✓).
- `_on_pick_acc(id)`: 0=`Selecione...`, 1=`Nenhum` (limpa), 100+=salvos
  (`acc_menu_ids`). Atualiza `current_acc_name` e realça a opção ativa via
  `_refresh_acc_menu_checks()`.
- `_on_del_pet(id)` / `_on_del_acc(id)`: 100+=salvos (`pet_del_ids`/`acc_del_ids`) →
  `_open_delete_dialog(mode, nome)`. Só itens salvos chegam (Default/Nenhum/Selecione
  não entram nos submenus de exclusão). Confirmar → `_on_delete_confirmed` apaga,
  regrava o JSON e reverte a seleção ativa p/ Default/Nenhum se for o caso.
- `_on_pick_automation(id)`: 100+=scripts de `Automacoes/` (`automation_ids` →
  caminho). **Avulsa** → `_run_automation` (carrega e chama `run(self)`). **Agendada**
  (em `schedule_defs`) → alterna `_set_automation_enabled(path, !on)` (✓ persistente em
  `user://schedules.json`); o disparo recorrente é feito por `_tick_schedules` no
  `_process`. Submenu reconstruído por `_rebuild_automations_menu()` a cada abertura.

> **Salvar vs Renomear**: `MI_SAVE_PET`/`MI_SAVE_ACC` viram "Renomear" (mesmo ícone)
> quando o item exibido já está salvo — `_refresh_save_labels()` ajusta o rótulo antes
> de abrir o menu; `_on_save_confirmed` → `_do_rename` quando `save_action == "rename"`.

Fluxos: [[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]],
[[Fluxo - Interação e Limites]].
