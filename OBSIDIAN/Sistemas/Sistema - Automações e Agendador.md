---
tags: [sistema, automacoes, agendador, extensibilidade, zimmy-pet]
atualizado: 2026-07-01
---

# ⚙️ Sistema - Automações e Agendador

Camada de **extensibilidade** do Zimmy: qualquer script `.gd` colocado na pasta
`Automacoes/` vira um item de menu. Scripts **avulsos** aparecem em **⚙️ Automações**
(executam uma vez ao clicar) e os que declaram frequência aparecem em
**⏱️ Temporizadores** (o Zimmy roda sozinho). Fonte de verdade do contrato:
`Automacoes/LEIAME.md`.

## Descoberta — `_scan_automations()` (zimmy.gd:1403)
A pasta é **reescaneada toda vez que o menu de contexto abre**, então scripts novos
aparecem sem reiniciar. Para cada `.gd` o Zimmy lê o **mapa de constantes** do script e
guarda, por caminho, os metadados em dicionários: `automation_groups` (`MENU_GROUP`,
zimmy.gd:71), `automation_badge_keys` (`BADGE_KEY`), `automation_cred_keys` (`CRED_KEY`),
`automation_icon_colors` (`ICON_COLOR`), `automation_flags` (`ICON_FLAG`). O menu é
remontado por `_rebuild_automations_menu()` (zimmy.gd:1029), respeitando o idioma atual.

## Contrato de uma automação
- `func run(zimmy)` — **obrigatório**; recebe o nó principal (acesso a `notify()`,
  `say()`, `feed()`, `pet()`, `play()`, `hop()`, `current`, `hunger`, `happy`, etc.).
- `const AUTOMATION_NAME` / `AUTOMATION_NAME_EN` — rótulo no menu (pt / en); sem eles o
  nome é derivado do arquivo.
- `const SCHEDULE` / `SCHEDULE_SECONDS` — frequência (ver **Agendador**).
- `const MENU_GROUP` — joga o item num submenu dedicado: `"email"` → 📧 E-mails
  ([[Sistema - E-mails]]), `"moedas"` → 💱 Moedas ([[Sistema - Moedas]]),
  `"whatsapp"` → 💬 WhatsApp. Sem grupo, cai em ⚙️ Automações.
- `const ICON_COLOR` (hex), `const BADGE_KEY` (rótulo dinâmico via
  `set_automation_badge`), `const CRED_KEY` (credenciais), `const ICON_FLAG` (bandeira).
- **Ciclo de vida:** `extends RefCounted` → descartado após o `run()`; `extends Node` →
  vira filho do Zimmy e **persiste** (útil para automações contínuas com `_process`).

## Agendador — `_parse_schedule()` (zimmy.gd:1462)
Converte `SCHEDULE`/`SCHEDULE_SECONDS` num descritor `{kind, every, at_minute, label}`:
- `"30s"` / `"5m"` / `"2h"` → **intervalo** (`_interval_def`, zimmy.gd:1491).
- `"hourly"` → toda **hora cheia** (minuto :00, alinhado ao relógio).
- `"daily@HH:MM"` → **uma vez por dia** no horário.
- número puro (ou `SCHEDULE_SECONDS`) → segundos.

Automações agendadas aparecem em **⏱️ Temporizadores** (`timers_menu`, `MI_TIMERS=21`,
zimmy.gd:258) como itens **marcáveis** (✓ = ligada) com ícone de relógio e a frequência no
rótulo — é o **agendador visual**. O estado ligado/desligado é **persistido** em
`user://schedules.json` (`SCHEDULES_FILE`, zimmy.gd:44) e restaurado ao reabrir. O loop
`_tick_schedules(delta)` (zimmy.gd:1551) dispara `_run_automation(path)` (zimmy.gd:1612) na
hora certa — o `run()` de uma agendada deve fazer a ação **uma vez** (a recorrência é do
agendador). Ver [[Fluxo - Loop (_process)]].

## Falar a partir de automações
Use **`zimmy.notify(msg)`** (zimmy.gd:3549): entra numa **fila**, aparece uma de cada vez
e fica ~5 s (evita sobreposição quando várias disparam juntas, ex.: cotações). `say()`
mostra na hora e some em 2,5 s, sem fila. Ver [[Sistema - Balão de Fala]].

## i18n para scripts
`zimmy.lang_text(pt, en)` (zimmy.gd:472), `zimmy.lang` (`"pt"`/`"en"`), e formatadores
localizados `fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (vírgula vs ponto,
`DD/MM/AAAA` vs `MM/DD/YYYY`). Ver [[Sistema - Menu de Contexto]] (troca de idioma).

## Web, sistema e credenciais
- **Web:** `http_get_json(url, cb)` (zimmy.gd:1633) → `cb.call(ok, data)`.
- **Web autenticado:** `http_get_auth(url, user, pass, cb)` (zimmy.gd:1656) → HTTP Basic,
  `cb.call(status, body)`. Usado pelo Gmail ([[Sistema - E-mails]]).
- **Sistema:** GDScript pode usar `OS.execute`/`OS.create_process` (ex.: `desligar_pc.gd`,
  `alarme.gd`).
- **Credenciais:** `with_credentials(key, título, cb)` (zimmy.gd:1869) entrega credenciais
  salvas ou abre o diálogo de login; `confirm_credentials(key, dados)` grava só se novas;
  `forget_credentials(key)` apaga. Ficam em `user://cred_<key>.json` (gitignored).
- **Badges/som:** `set_automation_badge(key, texto)` (zimmy.gd:1678) atualiza o rótulo e,
  quando o valor aumenta, toca o alerta sonoro do submenu correspondente.

## Scripts inclusos (`Automacoes/`)
`alarme.gd` (daily@08:00), `auto_alimentar.gd` (20s), `comemoracao_hora_cheia.gd`
(hourly), `desligar_pc.gd` (daily@23:00) + `cancelar_desligamento.gd`,
`lembrete_pomodoro.gd` (25m), `email_gmail.gd` ([[Sistema - E-mails]]), `whatsapp.gd`,
`cotacao_usd/eur/gbp/jpy/cny.gd` ([[Sistema - Moedas]]). Modelo: `exemplo_automacao.gd.example`.

Relacionado: [[Entrada - Itens do Menu]], [[Entrada - Funções de Ação]], [[Home]].
