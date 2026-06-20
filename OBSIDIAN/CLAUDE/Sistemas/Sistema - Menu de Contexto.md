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
⚙️ Automações ▸ (11) → submenu automations_menu
──
Sair (9)
```

## Submenus
- **pets_menu** (`_rebuild_pets_menu`): `Selecione...` (0, desabilitado, rótulo),
  `Default` (1), depois salvos (ids 100+ ↔ `pet_menu_ids`). Handler `_on_pick_pet`.
  `Default`/salvos são **radio-check items**; a opção ativa fica marcada (✓) via
  `_refresh_pets_menu_checks()` conforme `current_pet_name` (`""` quando o pet é
  aleatório → nada marcado).
- **acc_menu** (`_rebuild_acc_menu`): `Selecione...` (0), `Nenhum` (1, limpa), salvos
  (100+ ↔ `acc_menu_ids`). Handler `_on_pick_acc`. `Nenhum`/salvos são radio-check;
  realce da opção ativa via `_refresh_acc_menu_checks()` (`current_acc_name`, `""`
  quando aleatório).
- **automations_menu** (`_rebuild_automations_menu`): scripts `.gd` de
  `res://Automacoes/` (ids 100+ ↔ `automation_ids` → caminho). `_scan_automations()`
  lista `{name, path, sched}` e preenche `schedule_defs`. **Avulsas** (sem `SCHEDULE`)
  → item normal; handler `_on_pick_automation` → `_run_automation` (instancia e chama
  `run(self)`). **Agendadas** (com `SCHEDULE`) → `add_check_item` (✓ = ligada, rótulo
  com a frequência); o handler alterna `_set_automation_enabled(path, on)`. O item
  **⚙️ Automações** fica **desabilitado** quando a pasta não tem scripts; o submenu é
  reescaneado a cada abertura do menu (no clique direito).

## Automações + Agendador (pasta `Automacoes/`)
Drop-in de scripts: cada `.gd` em `Automacoes/` com `run(zimmy)` vira um item.
`extends RefCounted` é descartado após `run()`; `extends Node` é adicionado como filho
e persiste. **Agendador**: uma automação com `const SCHEDULE` (`"30s"`/`"5m"`/`"2h"`/
`"hourly"`/`"daily@HH:MM"`, ou `SCHEDULE_SECONDS`) roda sozinha — `_parse_schedule()`
gera `{kind, every, at_minute, label}`; `_tick_schedules(delta)` (no `_process`) dispara
via `_fire_automation()`; estado ligado/desligado persiste em `user://schedules.json`
(`_load_schedules`/`_save_schedules`, `automation_enabled`/`sched_runtime`).
**Web/sistema**: automações podem usar `zimmy.http_get_json(url, cb)` (helper que
encapsula `HTTPRequest` → JSON) e `OS.execute/create_process`. Exemplos: `auto_alimentar`,
`lembrete_pomodoro`, `comemoracao_hora_cheia`, `cotacao_usd/eur/gbp/jpy/cny` (AwesomeAPI,
o "submenu de moedas"), `desligar_pc`/`cancelar_desligamento` (`shutdown`), `alarme`.

## Submenu 📧 E-mails (grupos, badges, credenciais)
Consts opcionais lidas no scan: `MENU_GROUP` (roteia p/ um submenu dedicado — `email` →
`email_menu`), `ICON_COLOR` (ícone à esquerda via `add_icon_check_item` + `_provider_icon`,
cacheado), `BADGE_KEY` (rótulo mostra `automation_badges[key]`, setado por
`set_automation_badge`), `CRED_KEY` (arquivo de credencial). Mapas: `automation_groups`,
`automation_icon_colors`, `automation_badge_keys`, `automation_cred_keys`,
`automation_item_menu` (id → menu onde o item está, p/ marcar o ✓ no menu certo).
**Credenciais** (`CRED_PREFIX = user://cred_`): `with_credentials`/`confirm_credentials`/
`forget_credentials`/`load`/`save`; diálogo `cred_dialog` (e-mail + App Password mascarada);
pede ao ligar se não houver salva, grava só após validar. **IMAP**: `imap_unread(host,
port, user, pass, cb)` (TCP+TLS, `LOGIN` + `STATUS INBOX (UNSEEN)`). Exemplos
`email_gmail`/`email_outlook` (exigem App Password). Contrato em `Automacoes/LEIAME.md`.

## Diálogo de salvar
`_build_save_dialog` + `_open_save_dialog(mode)` reaproveitam o mesmo
`ConfirmationDialog` para "pet" ou "acc" (`save_mode`). Abrir **desliga a geração
automática** (`_stop_random_all`) para salvar o que está na tela. Valida nome em
`_on_save_confirmed` (rejeita vazio/`Default`/`Selecione...`/`Nenhum`).

Relacionado: [[Sistema - Pets]], [[Sistema - Acessórios]],
[[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]].
