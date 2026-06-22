---
tags: [sistema, ui, menu, zimmy-pet]
atualizado: 2026-06-21
---

# 🧭 Sistema - Menu de Contexto

`PopupMenu` nativo (botão direito) com submenus (`pets_menu`, `acc_menu`,
`pets_del_menu`, `acc_del_menu`) e dois `ConfirmationDialog` (salvar / excluir).
Montado em `_build_menu()` (`zimmy.gd:242`).
Subjanelas são nativas (`gui_embed_subwindows = false`).

## Posicionamento (ao abrir)
No clique direito, antes do `popup()`: `_rebuild_automations_menu()`,
`_refresh_save_labels()`, `menu.reset_size()` e então
`menu.position = _context_menu_position(menu.size)`. **`_context_menu_position`** calcula
o retângulo real do pet na tela (`get_window().position + (pet_x, pet_y)`, `PET_DRAW²`)
e testa candidatos **direita → esquerda → abaixo → acima** (gap de 8px): retorna o
primeiro que **cabe na área útil** (`screen_get_usable_rect().encloses`) e **não cobre o
pet** (`!intersects`). Sem encaixe perfeito, clampa o candidato da direita às bordas.

## Itens e ids (`MI_*`) — ver [[Entrada - Itens do Menu]]
```
🦴 Alimentar (0)   🤚 Carinho (1)   🎾 Brincar (2)
──
🐶 Gerar pets (3, check)
🎲 Gerar acessórios (10, check)
👓 Mostrar acessórios (4, check, default on)
──
💾 Salvar Pet... (5)
📂 Escolher pet ▸ (6)      → submenu pets_menu
🗑️ Excluir pet ▸ (13)      → submenu pets_del_menu
🎀 Salvar Acessório... (7)
🧳 Escolher acessório ▸ (8) → submenu acc_menu
🗑️ Excluir acessório ▸ (14) → submenu acc_del_menu
──
⚙️ Automações ▸ (11) → submenu automations_menu
📧 E-mails ▸ (12) → submenu email_menu
🌐 Idioma ▸ (15) → submenu lang_menu
──
Sair (9)
```

## Idioma (i18n)
Todos os textos do sistema vêm da tabela `STRINGS`/`STRING_LISTS` (pt/en) via `t(key)`
/`ta(key)`. O submenu **🌐 Idioma** (`lang_menu`) tem dois radio-checks
(`LANG_PT`/`LANG_EN`); `_on_pick_language` troca `lang`, persiste (`_save_settings`,
chave `lang` em settings.json) e chama `_apply_menu_labels()` (reaplica rótulos do menu
+ submenus + diálogos). `lang` é carregado em `_load_selection()` **antes** de
`_build_menu()`. As falas do pet (`say`) e listas (mood/feed/pet/play) também usam
`t`/`ta`. Ver [[Glossário de Configs]] e [[Sistema - Persistência]].

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
- **pets_del_menu / acc_del_menu** (`_rebuild_pets_del_menu`/`_rebuild_acc_del_menu`,
  chamados no fim dos respectivos `_rebuild_*_menu`): listam **só os itens salvos**
  (ids 100+ ↔ `pet_del_ids`/`acc_del_ids`) — `Default`/`Nenhum`/`Selecione...` **nunca
  entram** (intocáveis). Sem itens, mostram um rótulo desabilitado "(nenhum … salvo)".
  Handlers `_on_del_pet`/`_on_del_acc` abrem o `delete_dialog`; ao confirmar,
  `_on_delete_confirmed` apaga de `saved_pets`/`saved_accessories`, regrava o JSON e
  **sempre recarrega o Default** (`Default`/`Nenhum`). Ver [[Fluxo - Salvar e Carregar]].
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

**i18n nas automações**: o nome no menu é bilíngue — `_automation_name_from` usa
`AUTOMATION_NAME_EN` quando `lang == "en"` (senão `AUTOMATION_NAME`). As falas usam os
helpers `zimmy.lang_text(pt, en)` / `zimmy.lang`; valores e datas das cotações usam
`zimmy.fmt_num`/`fmt_pct`/`fmt_money_brl`/`fmt_quote_date` (separador decimal e formato de
data por idioma). `_apply_menu_labels()` chama `_rebuild_automations_menu()`, então os
nomes trocam de idioma na hora. Contrato em `Automacoes/LEIAME.md`.

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

## Diálogo de salvar / renomear
`_build_save_dialog` + `_open_save_dialog(mode, action)` reaproveitam o mesmo
`ConfirmationDialog` para "pet" ou "acc" (`save_mode`) em duas ações (`save_action`):
- **save** — abrir **congela só a geração do tipo sendo salvo** (`_set_random_pet` ou
  `_set_random_acc` `(false)`) para gravar o que está na tela; campo vazio com
  placeholder. Ao **confirmar**, desmarca novamente a checkbox do tipo salvo.
- **rename** — só quando o item exibido **já está salvo**; pré-preenche o nome atual
  (`name_edit.select_all()`), botão "Renomear".

Os rótulos do menu trocam **Salvar → Renomear** (mesmo ícone 💾/🎀) via
`_refresh_save_labels()`, chamado antes de abrir o menu (no clique direito), conforme
`saved_pets.has(current_pet_name)` / `saved_accessories.has(current_acc_name)`.

`_on_save_confirmed` valida o nome (rejeita vazio/`Default`/`Selecione...`/`Nenhum`) e
despacha: **save** grava `saved_*[nome]` (e torna o item ativo); **rename** chama
`_do_rename` → `_rename_key` (troca a chave **preservando a ordem** do dropdown),
rejeita nome duplicado, regrava o JSON + `settings.json` e reconstrói os menus.

## Diálogo de excluir
`_build_delete_dialog` + `_open_delete_dialog(mode, nome)` reaproveitam um
`ConfirmationDialog` (botões "Excluir"/"Cancelar") para "pet" ou "acc"
(`delete_mode` + `delete_name`). Só itens salvos chegam aqui, então **não há como
excluir `Default`/`Nenhum`**. Confirmar dispara `_on_delete_confirmed`.

Relacionado: [[Sistema - Pets]], [[Sistema - Acessórios]],
[[Fluxo - Salvar e Carregar]], [[Fluxo - Geração Aleatória]].
