---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, ui, menu, zimmy-pet]
---

# 🧭 Sistema - Menú Contextual

> 🇧🇷 Lee esta página en portugués → [[🧭 Sistema - Menu de Contexto]]
> 🇺🇸 Read this page in English → [[🧭 Sistema - Menu de Contexto (EN)]]

`PopupMenu` nativo (botón derecho) con submenús (`pets_menu`, `acc_menu`,
`pets_del_menu`, `acc_del_menu`) y dos `ConfirmationDialog` (guardar / eliminar).
Montado en `_build_menu()` (`zimmy.gd:242`).
Las subventanas son nativas (`gui_embed_subwindows = false`).

## 📍 Posicionamiento (al abrir)
En el clic derecho, antes del `popup()`: `_rebuild_automations_menu()`,
`_refresh_save_labels()`, `menu.reset_size()` y luego
`menu.position = _context_menu_position(menu.size)`. **`_context_menu_position`** calcula
el rectángulo real del pet en la pantalla (`get_window().position + (pet_x, pet_y)`, `PET_DRAW²`),
deja el menú **pegado al pet** y decide la **dirección de la cascada** (`lvl = max(menu.x, 300)`,
`cascade = 2·lvl` ≈ 2 niveles de submenú): **(1)** si la cascada cabe **a la derecha** (pet a la
izquierda/centro), menú a la derecha del pet, submenús hacia la derecha (nativo); **(2)** si no cabe
a la derecha pero cabe **a la izquierda** (pet a la derecha de la pantalla), menú a la izquierda del pet y
`_cascade_left = true` → los submenús abren hacia la **IZQUIERDA**; **(3)** ninguno de los dos (pantalla
estrecha) → retrocede hacia la derecha lo necesario (mejor esfuerzo). Si el menú cubre el pet en esa
posición, baja (o sube). **Cascada hacia la izquierda** (`_flip_submenu_if_left`): como los
submenús de Godot solo abren hacia la derecha, cada submenú (mapeado en `_submenu_parent`) conecta
`about_to_popup` y, cuando `_cascade_left`, sobrescribe la **X** por `padre.position.x −
sub.size.x` (manteniendo la Y que Godot alineó al ítem). Así el menú queda junto al pet a la
derecha y la cascada fluye hacia la izquierda, sin solaparse. Las previsualizaciones de nota se limitan a 30
chars para que los submenús no queden demasiado anchos. El apilamiento/captura de mouse-over entre
submenús es nativo (cada submenú es una **ventana del SO**, `gui_embed_subwindows = false`): el
último abierto queda encima y captura el ratón, sin repasar eventos a los menús de atrás.

## 🆔 Ítems e ids (`MI_*`) — ver [[🚪 Entrada - Itens do Menu (ES)]]
```
📊 Status (16, check, OFF padrão, persistido) → mostra/oculta as barras
🦴 Alimentar (0)   🤚 Carinho (1)   🎾 Brincar (2)   ← mesmo grupo (sem separador)
🔊 Alertas de som ▸ (22) → submenu sounds_menu (1 toggle por ação: Alimentar/Carinho/Brincar)
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
💱 Moedas ▸ (17) → submenu moedas_menu (cotações; item do menu principal logo abaixo de Automações; desabilitado se não houver nenhuma)
📝 Notas ▸ (18) → submenu notes_menu (bloquinho de texto; manual + área de transferência)
📧 E-mails ▸ (12) → submenu email_menu (🔊 Alerta de som no topo + Gmail)
💬 WhatsApp ▸ (19) → submenu whatsapp_menu (🔊 Alerta de som no topo + conversas não lidas, lendo o título da janela)
🌐 Idioma ▸ (15) → submenu lang_menu
❤️ Doação ▸ (20) → submenu donate_menu (GitHub Sponsors, Ko-fi — abrem links)
──
Sair (9)
```

## 🌐 Idioma (i18n)
Todos los textos del sistema vienen de la tabla `STRINGS`/`STRING_LISTS` (pt/en) vía `t(key)`
/`ta(key)`. El submenú **🌐 Idioma** (`lang_menu`) tiene dos radio-checks
(`LANG_PT`/`LANG_EN`); `_on_pick_language` cambia `lang`, persiste (`_save_settings`,
clave `lang` en settings.json) y llama a `_apply_menu_labels()` (reaplica etiquetas del menú
+ submenús + diálogos). `lang` se carga en `_load_selection()` **antes** de
`_build_menu()`. Los diálogos del pet (`say`) y las listas (mood/feed/pet/play) también usan
`t`/`ta`. Ver [[🗂️ Glossário de Configs (ES)]] y [[💾 Sistema - Persistência (ES)]].

## 📂 Submenús
- **pets_menu** (`_rebuild_pets_menu`): `Selecione...` (0, deshabilitado, etiqueta),
  `Default` (1), luego guardados (ids 100+ ↔ `pet_menu_ids`). Handler `_on_pick_pet`.
  `Default`/guardados son **radio-check items**; la opción activa queda marcada (✓) vía
  `_refresh_pets_menu_checks()` según `current_pet_name` (`""` cuando el pet es
  aleatorio → nada marcado).
- **acc_menu** (`_rebuild_acc_menu`): `Selecione...` (0), `Nenhum` (1, limpia), guardados
  (100+ ↔ `acc_menu_ids`). Handler `_on_pick_acc`. `Nenhum`/guardados son radio-check;
  realce de la opción activa vía `_refresh_acc_menu_checks()` (`current_acc_name`, `""`
  cuando aleatorio).
- **pets_del_menu / acc_del_menu** (`_rebuild_pets_del_menu`/`_rebuild_acc_del_menu`,
  llamados al final de los respectivos `_rebuild_*_menu`): listan **solo los ítems guardados**
  (ids 100+ ↔ `pet_del_ids`/`acc_del_ids`) — `Default`/`Nenhum`/`Selecione...` **nunca
  entran** (intocables). Sin ítems, muestran una etiqueta deshabilitada "(nenhum … salvo)".
  Los handlers `_on_del_pet`/`_on_del_acc` abren el `delete_dialog`; al confirmar,
  `_on_delete_confirmed` borra de `saved_pets`/`saved_accessories`, reescribe el JSON y
  **siempre recarga el Default** (`Default`/`Nenhum`). Ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- **automations_menu** (`_rebuild_automations_menu`): scripts `.gd` de
  `res://Automacoes/` (ids 100+ ↔ `automation_ids` → ruta). `_scan_automations()`
  lista `{name, path, sched}` y rellena `schedule_defs`. **Sueltas** (sin `SCHEDULE`)
  → ítem normal; handler `_on_pick_automation` → `_run_automation` (instancia y llama a
  `run(self)`). **Programadas** (con `SCHEDULE`) → `add_check_item` (✓ = activada, etiqueta
  con la frecuencia); el handler alterna `_set_automation_enabled(path, on)`. El ítem
  **⚙️ Automações** queda **deshabilitado** cuando la carpeta no tiene scripts (ni sueltas
  ni monedas); el submenú se reescanea en cada apertura del menú (en el clic derecho).
- **moedas_menu** (parte de `_rebuild_automations_menu`): scripts con
  `MENU_GROUP := "moedas"` (las cotizaciones `cotacao_*`) se enrutan al submenú
  **💱 Moedas**. Ese submenú es un **ítem del menú principal** (`MI_MOEDAS := 17`),
  posicionado **justo debajo de ⚙️ Automações** (añadido en `_build_menu` vía
  `menu.add_submenu_node_item(t("mi_moedas"), moedas_menu, MI_MOEDAS)`; en el mapa
  `_submenu_parent` el padre del `moedas_menu` es el `menu` principal, no el `automations_menu`).
  El ítem queda **deshabilitado** cuando no hay cotizaciones
  (`menu.set_item_disabled(menu.get_item_index(MI_MOEDAS), n_moedas == 0)`); mismo
  handler `_on_pick_automation`. Cada cotización muestra una **banderita (icono de textura) a la
  izquierda** vía `const ICON_FLAG := "us"/"eu"/"gb"/"jp"/"cn"` (leído en `_scan_automations`
  para `automation_flags`, dibujado por `_flag_icon()` — los emojis de bandera son pares de
  *regional indicators* que **no** se renderizan en los `PopupMenu`, por eso usamos textura).
  Los nombres quedan **sin emoji** (`AUTOMATION_NAME`: "Cotação USD", "Cotação EUR", ...; EN:
  "USD rate", etc.). Las cotizaciones **no usan `ICON_COLOR`** (el icono es la bandera de `ICON_FLAG`).
- **notes_menu** (`_rebuild_notes_menu`): bloc de notas de texto (`MI_NOTES = 18`),
  encima de 📧 E-mails. Ítems fijos `➕ Nova nota...` (`NOTE_NEW`) y
  `📋 Colar da área de transferência` (`NOTE_PASTE`); luego la lista de notas (ids 100+
  ↔ `note_ids` → índice en `notes`) — **hacer clic copia** el texto al portapapeles
  (`DisplayServer.clipboard_set`). Subsubmenú `🗑️ Excluir nota` (`notes_del_menu`,
  `MI_NOTES_DEL`, ids 100+ ↔ `note_del_ids`) elimina la nota. Sin notas, muestra la etiqueta
  deshabilitada `(nenhuma nota)`. `➕ Nova nota...` abre el `notes_dialog` (ConfirmationDialog
  con `TextEdit` multilínea); `📋 Colar` lee `DisplayServer.clipboard_get()`. Persistencia:
  `user://notes.json` (array de strings — `_save_notes`/`_load_notes`). La previsualización en el menú
  es una sola línea (`_note_preview`: quita saltos y limita a 30 chars, añadiendo "..." al final
cuando es mayor).

## ⚙️ Automatizaciones + Programador (carpeta `Automacoes/`)
Drop-in de scripts: cada `.gd` en `Automacoes/` con `run(zimmy)` se convierte en un ítem.
`extends RefCounted` se descarta tras `run()`; `extends Node` se añade como hijo
y persiste. **Programador**: una automatización con `const SCHEDULE` (`"30s"`/`"5m"`/`"2h"`/
`"hourly"`/`"daily@HH:MM"`, o `SCHEDULE_SECONDS`) corre sola — `_parse_schedule()`
genera `{kind, every, at_minute, label}`; `_tick_schedules(delta)` (en el `_process`) dispara
vía `_fire_automation()`; el estado activado/desactivado persiste en `user://schedules.json`
(`_load_schedules`/`_save_schedules`, `automation_enabled`/`sched_runtime`).
**Web/sistema**: las automatizaciones pueden usar `zimmy.http_get_json(url, cb)` (helper que
encapsula `HTTPRequest` → JSON) y `OS.execute/create_process`. Ejemplos:
`lembrete_pomodoro`, `comemoracao_hora_cheia`, `cotacao_usd/eur/gbp/jpy/cny` (AwesomeAPI,
el "submenú de monedas"), `desligar_pc`/`cancelar_desligamento` (`shutdown`), `alarme`.

**i18n en las automatizaciones**: el nombre en el menú es bilingüe — `_automation_name_from` usa
`AUTOMATION_NAME_EN` cuando `lang == "en"` (si no, `AUTOMATION_NAME`). Los diálogos usan los
helpers `zimmy.lang_text(pt, en)` / `zimmy.lang`; los valores y fechas de las cotizaciones usan
`zimmy.fmt_num`/`fmt_pct`/`fmt_money_brl`/`fmt_quote_date` (separador decimal y formato de
fecha por idioma). `_apply_menu_labels()` llama a `_rebuild_automations_menu()`, así que los
nombres cambian de idioma al instante. Contrato en `Automacoes/LEIAME.md`.

## 📧 Submenú 📧 Correos (grupos, badges, credenciales)
Consts opcionales leídas en el scan: `MENU_GROUP` (enruta a un submenú dedicado — `email` →
`email_menu`; `moedas` → `moedas_menu`, ítem del menú principal justo debajo de ⚙️ Automações; `whatsapp` →
`whatsapp_menu`, top-level `MI_WHATSAPP = 19`), `ICON_COLOR` (icono a la izquierda vía `add_icon_check_item` + `_provider_icon`,
cacheado), `BADGE_KEY` (la etiqueta muestra `automation_badges[key]`, seteado por
`set_automation_badge`), `CRED_KEY` (archivo de credencial). Mapas: `automation_groups`,
`automation_icon_colors`, `automation_badge_keys`, `automation_cred_keys`,
`automation_item_menu` (id → menú donde está el ítem, para marcar el ✓ en el menú correcto).
**Credenciales** (`CRED_PREFIX = user://cred_`): `with_credentials(key, title, cb, help_steps:="", help_url:="")`/`confirm_credentials`/
`forget_credentials`/`load`/`save`; diálogo `cred_dialog` (paso a paso opcional `cred_help` +
enlace `cred_link`→`OS.shell_open(help_url)` arriba, correo + App Password enmascarada). El
`email_gmail` pasa el paso a paso de cómo generar la App Password (mostrado la 1ª vez);
la pide al activar si no hay guardada, graba solo tras validar. **Gmail** (`email_gmail`) usa el
**feed Atom**: `http_get_auth(url, user, pass, cb)` (GET con `Authorization: Basic`, devuelve
`cb.call(status, body)`) en `mail/feed/atom`, y un regex extrae `<fullcount>N</fullcount>` —
sin IMAP. Gmail es el único proveedor del submenú; exige App Password (Basic en el feed).
Contrato en `Automacoes/LEIAME.md`.

## 🔊 Alerta de sonido (no leídas)
En la **parte superior** de los submenús **💬 WhatsApp** y **📧 Correos** (antes del ítem contador) hay un
checkbox **🔊 Alerta de sonido** (clave de traducción `mi_sound_alert`, "🔊 Alerta de som" / "🔊 Sound alert"). Cuando el badge de no
leídos **aumenta** (llegó un mensaje nuevo), Zimmy reproduce un sonido bajo: teléfono sonando
(WhatsApp) o entrega de correo (Gmail). Los toggles usan los ids `SND_WHATSAPP := 50` y
`SND_GMAIL := 51` (por debajo de 100, donde empiezan los ids de las automatizaciones), tratados en
`_on_pick_automation`; el estado persiste en settings.json como `wa_sound` / `gmail_sound`
(variables `whatsapp_sound_on` / `gmail_sound_on`, por defecto activado). El sonido se sintetiza en
código (sin archivos de audio) vía `AudioStreamWAV` en las funciones
`_build_audio`/`_build_ring_sound`/`_build_chime_sound`/`_make_wav`/`_play_alert`, reproducido por
dos nodos `AudioStreamPlayer` (`_ring_player`/`_chime_player`). La reproducción se dispara dentro
de `set_automation_badge(key, text)` al detectar el aumento numérico del badge de las claves
`whatsapp` o `email_gmail`.

## 🔊 Alertas de sonido de las acciones (Alimentar/Cariño/Jugar)
Submenú **🔊 Alertas de sonido** (`sounds_menu`, ítem `MI_SOUNDS := 22`, **justo debajo de
🎾 Brincar**; clave de traducción `mi_sounds`) con **un checkbox por acción**: `🦴 Alimentar`
(`SND_FEED := 1`), `🤚 Carinho` (`SND_PET := 2`), `🎾 Brincar` (`SND_PLAY := 3`) — ids
propios del submenú (no colisionan con los de las automatizaciones), handler `_on_pick_sound`. Cada
toggle (`sound_feed_on` / `sound_pet_on` / `sound_play_on`, **por defecto activado**, persistidos
en settings.json como `feed_sound` / `pet_sound` / `play_sound`) gobierna **dos** disparadores del
mismo sonido:
- **al ejecutar la acción** — `feed()` / `pet()` / `play()` reproducen el player al final
  ([[🚪 Entrada - Funções de Ação (ES)]]);
- **recordatorio de necesidad baja** — en el decaimiento (`_process`), cuando la barra **cruza
  `STAT_LOW = 20` hacia abajo** (solo en la transición, una vez por cruce) — ver
  [[📊 Sistema - Necessidades (ES)]].

Sonidos **sintetizados en código** (`AudioStreamWAV`), al mismo estilo que los de WhatsApp/Gmail:
`_build_feed_sound` (dos mordisquitos graves), `_build_pet_sound` (ronroneo — tono grave con
trémolo) y `_build_play_sound` (arpegio alegre ascendente), creados en `_build_audio` y
reproducidos por `_feed_player` / `_pet_player` / `_play_player` (vía `_play_alert`). Las etiquetas
se reaplican en el idioma en `_apply_menu_labels`; el submenú entra en el mapa `_submenu_parent`
(cascada hacia la izquierda).

## 💬 Submenú 💬 WhatsApp (conversaciones no leídas)
Drop-in `whatsapp.gd` (`MENU_GROUP = "whatsapp"` → submenú top-level `💬 WhatsApp`,
`BADGE_KEY`, `ICON_COLOR = 25d366`, `SCHEDULE = "1m"`). **No hay API ni credencial**: el
WhatsApp Web ata la sesión al navegador vinculado por QR. La automatización solo **lee el título
de la ventana** de WhatsApp Web (`OS.execute("tasklist", ["/v","/fo","csv","/nh"])`) — cuando
hay no leídas el título pasa a `"(N) WhatsApp"`; un `RegEx` `(?i)\((\d+)\)\s*whatsapp` extrae N
(comparación en minúsculas / `(?i)` para casar cualquier caja — `WhatsApp`, `web.whatsapp.com`,
ventana PWA; sin paréntesis ⇒ 0; ventana ausente ⇒ badge `?` + aviso "no está abierto"). Es
observación pasiva (no toca los servidores de WhatsApp, no viola los términos). Requiere el
WhatsApp Web abierto e idealmente **como UNA ventana propia** (atajo `chrome --app=...` o
⋮ ▸ Crear atajo ▸ Abrir como ventana): con la pestaña normal + una 2ª ventana abiertas al mismo
tiempo, WhatsApp muestra "abierto en otra ventana" y no pone el `(N)` en el título.

## 💾 Diálogo de guardar / renombrar
`_build_save_dialog` + `_open_save_dialog(mode, action)` reaprovechan el mismo
`ConfirmationDialog` para "pet" o "acc" (`save_mode`) en dos acciones (`save_action`):
- **save** — al abrir **congela solo la generación del tipo que se está guardando** (`_set_random_pet` o
  `_set_random_acc` `(false)`) para grabar lo que está en pantalla; campo vacío con
  placeholder. Al **confirmar**, desmarca de nuevo el checkbox del tipo guardado.
- **rename** — solo cuando el ítem mostrado **ya está guardado**; rellena previamente el nombre actual
  (`name_edit.select_all()`), botón "Renomear".

Las etiquetas del menú cambian **Salvar → Renomear** (mismo icono 💾/🎀) vía
`_refresh_save_labels()`, llamado antes de abrir el menú (en el clic derecho), según
`saved_pets.has(current_pet_name)` / `saved_accessories.has(current_acc_name)`.

`_on_save_confirmed` valida el nombre (rechaza vacío/`Default`/`Selecione...`/`Nenhum`) y
despacha: **save** graba `saved_*[nombre]` (y hace el ítem activo); **rename** llama a
`_do_rename` → `_rename_key` (cambia la clave **preservando el orden** del dropdown),
rechaza nombre duplicado, reescribe el JSON + `settings.json` y reconstruye los menús.

## 🗑️ Diálogo de eliminar
`_build_delete_dialog` + `_open_delete_dialog(mode, nome)` reaprovechan un
`ConfirmationDialog` (botones "Excluir"/"Cancelar") para "pet" o "acc"
(`delete_mode` + `delete_name`). Solo los ítems guardados llegan aquí, así que **no hay forma de
eliminar `Default`/`Nenhum`**. Confirmar dispara `_on_delete_confirmed`.

Relacionado: [[🐾 Sistema - Pets (ES)]], [[🎀 Sistema - Acessórios (ES)]],
[[💾 Fluxo - Salvar e Carregar (ES)]], [[🎲 Fluxo - Geração Aleatória (ES)]].
