---
tags: [endpoint, menu, zimmy-pet]
atualizado: 2026-06-25
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
| 22 | `MI_SOUNDS` | 🔊 Alertas de som ▸ | submenu `sounds_menu` → `_on_pick_sound` (1 toggle por ação: Alimentar/Carinho/Brincar; logo abaixo de 🎾 Brincar) |
| 3 | `MI_RANDOM` | 🐶 Gerar pets | `_set_random_pet(!on)` |
| 10 | `MI_RANDOM_ACC` | 🎲 Gerar acessórios | `_set_random_acc(!on)` |
| 4 | `MI_SHOW_ACC` | 👓 Mostrar acessórios | `_set_show_accessories(!on)` |
| 16 | `MI_STATUS` | 📊 Status | `_set_show_status(!on)` (barras; OFF padrão, persistido) |
| 5 | `MI_SAVE_PET` | 💾 Salvar/Renomear Pet... | `_open_save_dialog("pet", save\|rename)` |
| 6 | `MI_CHOOSE_PET` | 📂 Escolher pet ▸ | submenu `pets_menu` |
| 13 | `MI_DEL_PET` | 🗑️ Excluir pet ▸ | submenu `pets_del_menu` |
| 7 | `MI_SAVE_ACC` | 🎀 Salvar/Renomear Acessório... | `_open_save_dialog("acc", save\|rename)` |
| 8 | `MI_CHOOSE_ACC` | 🧳 Escolher acessório ▸ | submenu `acc_menu` |
| 14 | `MI_DEL_ACC` | 🗑️ Excluir acessório ▸ | submenu `acc_del_menu` |
| 11 | `MI_AUTOMATIONS` | ⚙️ Automações ▸ | submenu `automations_menu` (só as **avulsas**, ícone ▶ play; desabilitado se não houver avulsas) |
| 21 | `MI_TIMERS` | ⏱️ Temporizadores ▸ | submenu `timers_menu` (logo abaixo de ⚙️ Automações; só as **agendadas**, marcáveis com ícone de relógio + frequência no rótulo — agendador visual; desabilitado se não houver agendadas) |
| 17 | `MI_MOEDAS` | 💱 Moedas ▸ | submenu `moedas_menu` (item do menu principal logo abaixo de ⏱️ Temporizadores; desabilitado se não houver cotações) |
| 18 | `MI_NOTES` | 📝 Notas ▸ | submenu `notes_menu` → `_on_pick_note` (nova/colar/copiar) + `🗑️ Excluir nota` (`notes_del_menu` → `_on_del_note`) |
| 12 | `MI_EMAIL` | 📧 E-mails ▸ | submenu `email_menu` (🔊 Alerta de som no topo + Gmail, feed Atom) |
| 19 | `MI_WHATSAPP` | 💬 WhatsApp ▸ | submenu `whatsapp_menu` (drop-in `whatsapp.gd`, `MENU_GROUP="whatsapp"`; 🔊 Alerta de som no topo + lê o título da janela do WhatsApp Web) |
| 15 | `MI_LANG` | 🌐 Idioma ▸ | submenu `lang_menu` → `_on_pick_language` |
| 20 | `MI_DONATE` | ❤️ Doação ▸ | submenu `donate_menu` → `_on_pick_donate` (GitHub Sponsors / Ko-fi via `OS.shell_open`) |
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
- `_on_pick_automation(id)` (atende `automations_menu` e `timers_menu`): 100+=scripts de
  `Automacoes/` (`automation_ids` → caminho). **Avulsa** → `_run_automation` (carrega e
  chama `run(self)`). **Agendada** (em `schedule_defs`) → alterna
  `_set_automation_enabled(path, !on)` (✓ persistente em `user://schedules.json`); o
  disparo recorrente é feito por `_tick_schedules` no `_process`. Também trata os toggles
  **🔊 Alerta de som** `SND_WHATSAPP=50` / `SND_GMAIL=51` (abaixo de 100), que alternam
  `whatsapp_sound_on` / `gmail_sound_on` (persistidos em settings.json como `wa_sound` /
  `gmail_sound`). Ambos os submenus são reconstruídos por `_rebuild_automations_menu()` a
  cada abertura: as do grupo default com `SCHEDULE`/`SCHEDULE_SECONDS` vão para
  ⏱️ Temporizadores (ícone de relógio), as avulsas ficam em ⚙️ Automações (ícone ▶ play);
  itens com `MENU_GROUP` (moedas/email/whatsapp) seguem nos próprios submenus mesmo
  quando agendados.
- `_on_pick_sound(id)` (submenu `sounds_menu`, **🔊 Alertas de som**): `SND_FEED=1` /
  `SND_PET=2` / `SND_PLAY=3` alternam `sound_feed_on` / `sound_pet_on` / `sound_play_on`
  (padrão ligado, persistidos em settings.json como `feed_sound` / `pet_sound` /
  `play_sound`). Cada toggle vale para o som **ao executar a ação** e para o **lembrete**
  quando a necessidade cruza `STAT_LOW=20` para baixo. Ver [[Sistema - Menu de Contexto]]
  e [[Sistema - Necessidades]].

> **Salvar vs Renomear**: `MI_SAVE_PET`/`MI_SAVE_ACC` viram "Renomear" (mesmo ícone)
> quando o item exibido já está salvo — `_refresh_save_labels()` ajusta o rótulo antes
> de abrir o menu; `_on_save_confirmed` → `_do_rename` quando `save_action == "rename"`.

Fluxos: [[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]],
[[Fluxo - Interação e Limites]].
