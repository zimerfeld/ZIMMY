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
deixa o menu **colado no pet** e decide a **direção da cascata** (`lvl = max(menu.x, 300)`,
`cascade = 2·lvl` ≈ 2 níveis de submenu): **(1)** se a cascata cabe **à direita** (pet à
esquerda/centro), menu à direita do pet, submenus p/ a direita (nativo); **(2)** se não cabe
à direita mas cabe **à esquerda** (pet na direita da tela), menu à esquerda do pet e
`_cascade_left = true` → os submenus abrem p/ a **ESQUERDA**; **(3)** nenhum dos dois (tela
estreita) → recua p/ a direita o necessário (melhor esforço). Se o menu cobrir o pet nessa
posição, desce (ou sobe). **Cascata p/ a esquerda** (`_flip_submenu_if_left`): como os
submenus do Godot só abrem p/ a direita, cada submenu (mapeado em `_submenu_parent`) conecta
`about_to_popup` e, quando `_cascade_left`, sobrescreve o **X** para `pai.position.x −
sub.size.x` (mantendo o Y que o Godot alinhou ao item). Assim o menu fica junto do pet à
direita e a cascata flui p/ a esquerda, sem sobrepor. As prévias de nota são limitadas a 30
chars p/ os submenus não ficarem largos demais. O empilhamento/captura de mouse-over entre
submenus é nativo (cada submenu é uma **janela do SO**, `gui_embed_subwindows = false`): o
último aberto fica no topo e captura o mouse, sem repassar eventos para os menus atrás.

## Itens e ids (`MI_*`) — ver [[Entrada - Itens do Menu]]
```
📊 Status (16, check, OFF padrão, persistido) → mostra/oculta as barras
🦴 Alimentar (0)   🤚 Carinho (1)   🎾 Brincar (2)   ← mesmo grupo (sem separador)
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
   └ 💱 Moedas ▸ (17) → submenu moedas_menu (cotações; só aparece se houver alguma)
📝 Notas ▸ (18) → submenu notes_menu (bloquinho de texto; manual + área de transferência)
📧 E-mails ▸ (12) → submenu email_menu
💬 WhatsApp ▸ (19) → submenu whatsapp_menu (conversas não lidas, lendo o título da janela)
🌐 Idioma ▸ (15) → submenu lang_menu
❤️ Doação ▸ (20) → submenu donate_menu (GitHub Sponsors, Ko-fi — abrem links)
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
  **⚙️ Automações** fica **desabilitado** quando a pasta não tem scripts (nem avulsas
  nem moedas); o submenu é reescaneado a cada abertura do menu (no clique direito).
- **moedas_menu** (parte de `_rebuild_automations_menu`): scripts com
  `MENU_GROUP := "moedas"` (as cotações `cotacao_*`) são roteados para o submenu
  **💱 Moedas** (`MI_MOEDAS = 17`), aninhado no topo de **⚙️ Automações**. O item de
  submenu só é criado quando há pelo menos uma cotação; mesmo handler `_on_pick_automation`.
- **notes_menu** (`_rebuild_notes_menu`): bloquinho de notas de texto (`MI_NOTES = 18`),
  acima de 📧 E-mails. Itens fixos `➕ Nova nota...` (`NOTE_NEW`) e
  `📋 Colar da área de transferência` (`NOTE_PASTE`); depois a lista de notas (ids 100+
  ↔ `note_ids` → índice em `notes`) — **clicar copia** o texto para a área de transferência
  (`DisplayServer.clipboard_set`). Subsubmenu `🗑️ Excluir nota` (`notes_del_menu`,
  `MI_NOTES_DEL`, ids 100+ ↔ `note_del_ids`) remove a nota. Sem notas, mostra o rótulo
  desabilitado `(nenhuma nota)`. `➕ Nova nota...` abre o `notes_dialog` (ConfirmationDialog
  com `TextEdit` multilinha); `📋 Colar` lê `DisplayServer.clipboard_get()`. Persistência:
  `user://notes.json` (array de strings — `_save_notes`/`_load_notes`). A prévia no menu
  é uma linha só (`_note_preview`: tira quebras e limita a 40 chars).

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
`email_menu`; `moedas` → `moedas_menu`, aninhado em ⚙️ Automações; `whatsapp` →
`whatsapp_menu`, top-level `MI_WHATSAPP = 19`), `ICON_COLOR` (ícone à esquerda via `add_icon_check_item` + `_provider_icon`,
cacheado), `BADGE_KEY` (rótulo mostra `automation_badges[key]`, setado por
`set_automation_badge`), `CRED_KEY` (arquivo de credencial). Mapas: `automation_groups`,
`automation_icon_colors`, `automation_badge_keys`, `automation_cred_keys`,
`automation_item_menu` (id → menu onde o item está, p/ marcar o ✓ no menu certo).
**Credenciais** (`CRED_PREFIX = user://cred_`): `with_credentials(key, title, cb, help_steps:="", help_url:="")`/`confirm_credentials`/
`forget_credentials`/`load`/`save`; diálogo `cred_dialog` (passo-a-passo opcional `cred_help` +
link `cred_link`→`OS.shell_open(help_url)` no topo, e-mail + App Password mascarada). O
`email_gmail` passa o passo-a-passo de como gerar a App Password (exibido na 1ª vez);
pede ao ligar se não houver salva, grava só após validar. **Gmail** (`email_gmail`) usa o
**feed Atom**: `http_get_auth(url, user, pass, cb)` (GET com `Authorization: Basic`, devolve
`cb.call(status, body)`) em `mail/feed/atom`, e um regex extrai `<fullcount>N</fullcount>` —
sem IMAP. **Outlook** (`email_outlook`) usa **IMAP**: `imap_unread(host, port, user, pass,
cb)` (TCP+TLS, `LOGIN` + `STATUS INBOX (UNSEEN)`). Ambos exigem App Password (Basic no feed,
`LOGIN` no IMAP). Contrato em `Automacoes/LEIAME.md`.

## Submenu 💬 WhatsApp (conversas não lidas)
Drop-in `whatsapp.gd` (`MENU_GROUP = "whatsapp"` → submenu top-level `💬 WhatsApp`,
`BADGE_KEY`, `ICON_COLOR = 25d366`, `SCHEDULE = "1m"`). **Não há API nem credencial**: o
WhatsApp Web prende a sessão ao navegador vinculado por QR. A automação só **lê o título
da janela** do WhatsApp Web (`OS.execute("tasklist", ["/v","/fo","csv","/nh"])`) — quando
há não lidas o título vira `"(N) WhatsApp"`; um `RegEx` `(?i)\((\d+)\)\s*whatsapp` extrai N
(comparação em minúsculas / `(?i)` p/ casar qualquer caixa — `WhatsApp`, `web.whatsapp.com`,
janela PWA; sem parênteses ⇒ 0; janela ausente ⇒ badge `?` + aviso "não está aberto"). É
observação passiva (não toca nos servidores do WhatsApp, não viola os termos). Requer o
WhatsApp Web aberto e idealmente **como UMA janela própria** (atalho `chrome --app=...` ou
⋮ ▸ Criar atalho ▸ Abrir como janela): com a aba normal + uma 2ª janela abertas ao mesmo
tempo, o WhatsApp mostra "aberto em outra janela" e não põe o `(N)` no título.

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
