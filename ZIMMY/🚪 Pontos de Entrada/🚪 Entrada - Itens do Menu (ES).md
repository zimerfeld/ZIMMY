---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [endpoint, menu, zimmy-pet]
---

# 🚪 Punto de Entrada - Elementos del Menú

> 🇧🇷 Lee esta página en portugués → [[🚪 Entrada - Itens do Menu]]
> 🇺🇸 Read this page in English → [[🚪 Entrada - Itens do Menu (EN)]]

Endpoints activados por el menú contextual. Los ids `MI_*` se despachan en `_on_menu(id)`
(`zimmy.gd:306`). Los submenús tienen sus propios handlers. Ver [[🧭 Sistema - Menu de Contexto (ES)]].

## 📋 Menú principal (`_on_menu`)
| id | const | etiqueta | acción |
|---|---|---|---|
| 0 | `MI_FEED` | 🦴 Alimentar | `feed()` |
| 1 | `MI_PET` | 🤚 Carinho | `pet()` |
| 2 | `MI_PLAY` | 🎾 Brincar | `play()` |
| 22 | `MI_SOUNDS` | 🔊 Alertas de som ▸ | submenú `sounds_menu` → `_on_pick_sound` (1 toggle por acción: Alimentar/Carinho/Brincar; justo debajo de 🎾 Brincar) |
| 3 | `MI_RANDOM` | 🐶 Gerar pets | `_set_random_pet(!on)` |
| 10 | `MI_RANDOM_ACC` | 🎲 Gerar acessórios | `_set_random_acc(!on)` |
| 4 | `MI_SHOW_ACC` | 👓 Mostrar acessórios | `_set_show_accessories(!on)` |
| 16 | `MI_STATUS` | 📊 Status | `_set_show_status(!on)` (barras; OFF por defecto, persistido) |
| 5 | `MI_SAVE_PET` | 💾 Salvar/Renomear Pet... | `_open_save_dialog("pet", save\|rename)` |
| 6 | `MI_CHOOSE_PET` | 📂 Escolher pet ▸ | submenú `pets_menu` |
| 13 | `MI_DEL_PET` | 🗑️ Excluir pet ▸ | submenú `pets_del_menu` |
| 7 | `MI_SAVE_ACC` | 🎀 Salvar/Renomear Acessório... | `_open_save_dialog("acc", save\|rename)` |
| 8 | `MI_CHOOSE_ACC` | 🧳 Escolher acessório ▸ | submenú `acc_menu` |
| 14 | `MI_DEL_ACC` | 🗑️ Excluir acessório ▸ | submenú `acc_del_menu` |
| 11 | `MI_AUTOMATIONS` | ⚙️ Automações ▸ | submenú `automations_menu` (solo las **sueltas**, icono ▶ play; deshabilitado si no hay sueltas) |
| 21 | `MI_TIMERS` | ⏱️ Temporizadores ▸ | submenú `timers_menu` (justo debajo de ⚙️ Automações; solo las **programadas**, marcables con icono de reloj + frecuencia en la etiqueta — planificador visual; deshabilitado si no hay programadas) |
| 17 | `MI_MOEDAS` | 💱 Moedas ▸ | submenú `moedas_menu` (elemento del menú principal justo debajo de ⏱️ Temporizadores; deshabilitado si no hay cotizaciones) |
| 18 | `MI_NOTES` | 📝 Notas ▸ | submenú `notes_menu` → `_on_pick_note` (nueva/pegar/copiar) + `🗑️ Excluir nota` (`notes_del_menu` → `_on_del_note`) |
| 12 | `MI_EMAIL` | 📧 E-mails ▸ | submenú `email_menu` (🔊 Alerta de som arriba + Gmail, feed Atom) |
| 19 | `MI_WHATSAPP` | 💬 WhatsApp ▸ | submenú `whatsapp_menu` (drop-in `whatsapp.gd`, `MENU_GROUP="whatsapp"`; 🔊 Alerta de som arriba + lee el título de la ventana de WhatsApp Web) |
| 15 | `MI_LANG` | 🌐 Idioma ▸ | submenú `lang_menu` → `_on_pick_language` |
| 20 | `MI_DONATE` | ❤️ Doação ▸ | submenú `donate_menu` → `_on_pick_donate` (GitHub Sponsors / Ko-fi mediante `OS.shell_open`) |
| 9 | `MI_QUIT` | Sair | `get_tree().quit()` |

## 📂 Submenús
- `_on_pick_pet(id)`: 0=`Selecione...` (ignora), 1=`Default`, 100+=guardados
  (`pet_menu_ids`). Actualiza `current_pet_name` y resalta la opción activa mediante
  `_refresh_pets_menu_checks()` (radio-check ✓).
- `_on_pick_acc(id)`: 0=`Selecione...`, 1=`Nenhum` (limpia), 100+=guardados
  (`acc_menu_ids`). Actualiza `current_acc_name` y resalta la opción activa mediante
  `_refresh_acc_menu_checks()`.
- `_on_del_pet(id)` / `_on_del_acc(id)`: 100+=guardados (`pet_del_ids`/`acc_del_ids`) →
  `_open_delete_dialog(mode, nombre)`. Solo llegan los elementos guardados (Default/Nenhum/Selecione
  no entran en los submenús de eliminación). Confirmar → `_on_delete_confirmed` borra,
  reescribe el JSON y revierte la selección activa a Default/Nenhum si procede.
- `_on_pick_automation(id)` (atiende `automations_menu` y `timers_menu`): 100+=scripts de
  `Automacoes/` (`automation_ids` → ruta). **Suelta** → `_run_automation` (carga y
  llama a `run(self)`). **Programada** (en `schedule_defs`) → alterna
  `_set_automation_enabled(path, !on)` (✓ persistente en `user://schedules.json`); el
  disparo recurrente lo hace `_tick_schedules` en `_process`. También gestiona los toggles
  **🔊 Alerta de som** `SND_WHATSAPP=50` / `SND_GMAIL=51` (por debajo de 100), que alternan
  `whatsapp_sound_on` / `gmail_sound_on` (persistidos en settings.json como `wa_sound` /
  `gmail_sound`). Ambos submenús se reconstruyen con `_rebuild_automations_menu()` en
  cada apertura: las del grupo default con `SCHEDULE`/`SCHEDULE_SECONDS` van a
  ⏱️ Temporizadores (icono de reloj), las sueltas quedan en ⚙️ Automações (icono ▶ play);
  los elementos con `MENU_GROUP` (moedas/email/whatsapp) siguen en sus propios submenús incluso
  cuando están programados.
- `_on_pick_sound(id)` (submenú `sounds_menu`, **🔊 Alertas de som**): `SND_FEED=1` /
  `SND_PET=2` / `SND_PLAY=3` alternan `sound_feed_on` / `sound_pet_on` / `sound_play_on`
  (activados por defecto, persistidos en settings.json como `feed_sound` / `pet_sound` /
  `play_sound`). Cada toggle vale para el sonido **al ejecutar la acción** y para el **recordatorio**
  cuando la necesidad cruza `STAT_LOW=20` hacia abajo. Ver [[🧭 Sistema - Menu de Contexto (ES)]]
  y [[📊 Sistema - Necessidades (ES)]].

> **Guardar vs Renombrar**: `MI_SAVE_PET`/`MI_SAVE_ACC` cambian a "Renomear" (mismo icono)
> cuando el elemento mostrado ya está guardado — `_refresh_save_labels()` ajusta la etiqueta antes
> de abrir el menú; `_on_save_confirmed` → `_do_rename` cuando `save_action == "rename"`.

Flujos: [[💾 Fluxo - Salvar e Carregar (ES)]], [[🎲 Fluxo - Geração Aleatória (ES)]],
[[😼 Fluxo - Interação e Limites (ES)]].
