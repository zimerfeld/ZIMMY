---
tags: [endpoint, menu, zimmy-pet]
atualizado: 2026-06-20
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
| 3 | `MI_RANDOM` | 🎲 Gerar pets | `_set_random_pet(!on)` |
| 10 | `MI_RANDOM_ACC` | 🎲 Gerar acessórios | `_set_random_acc(!on)` |
| 4 | `MI_SHOW_ACC` | 👓 Mostrar acessórios | `_set_show_accessories(!on)` |
| 5 | `MI_SAVE_PET` | 💾 Salvar Pet... | `_open_save_dialog("pet")` |
| 6 | `MI_CHOOSE_PET` | 📂 Escolher pet ▸ | submenu `pets_menu` |
| 7 | `MI_SAVE_ACC` | 🎀 Salvar Acessório... | `_open_save_dialog("acc")` |
| 8 | `MI_CHOOSE_ACC` | 🧳 Escolher acessório ▸ | submenu `acc_menu` |
| 11 | `MI_AUTOMATIONS` | ⚙️ Automações ▸ | submenu `automations_menu` |
| 9 | `MI_QUIT` | Sair | `get_tree().quit()` |

## Submenus
- `_on_pick_pet(id)`: 0=`Selecione...` (ignora), 1=`Default`, 100+=salvos
  (`pet_menu_ids`). Atualiza `current_pet_name` e realça a opção ativa via
  `_refresh_pets_menu_checks()` (radio-check ✓).
- `_on_pick_acc(id)`: 0=`Selecione...`, 1=`Nenhum` (limpa), 100+=salvos
  (`acc_menu_ids`). Atualiza `current_acc_name` e realça a opção ativa via
  `_refresh_acc_menu_checks()`.
- `_on_pick_automation(id)`: 100+=scripts de `Automacoes/` (`automation_ids` →
  caminho). **Avulsa** → `_run_automation` (carrega e chama `run(self)`). **Agendada**
  (em `schedule_defs`) → alterna `_set_automation_enabled(path, !on)` (✓ persistente em
  `user://schedules.json`); o disparo recorrente é feito por `_tick_schedules` no
  `_process`. Submenu reconstruído por `_rebuild_automations_menu()` a cada abertura.

Fluxos: [[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]],
[[Fluxo - Interação e Limites]].
