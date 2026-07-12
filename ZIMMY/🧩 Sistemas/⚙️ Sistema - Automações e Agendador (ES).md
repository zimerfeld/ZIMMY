---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, automacoes, agendador, extensibilidade, zimmy-pet]
---

# ⚙️ Sistema - Automatizaciones y Programador

> 🇧🇷 Lee esta página en portugués → [[⚙️ Sistema - Automações e Agendador]]
> 🇺🇸 Read this page in English → [[⚙️ Sistema - Automações e Agendador (EN)]]

Capa de **extensibilidad** de Zimmy: cualquier script `.gd` colocado en la carpeta
`Automacoes/` se convierte en un elemento de menú. Los scripts **sueltos** aparecen en
**⚙️ Automatizaciones** (se ejecutan una vez al hacer clic) y los que declaran una
frecuencia aparecen en **⏱️ Temporizadores** (Zimmy los ejecuta solo). Fuente de verdad del
contrato: `Automacoes/LEIAME.md`.

## 🔍 Descubrimiento — `_scan_automations()` (zimmy.gd:1403)
La carpeta se **reescanea cada vez que se abre el menú contextual**, así que los scripts
nuevos aparecen sin reiniciar. Para cada `.gd` Zimmy lee el **mapa de constantes** del
script y guarda, por ruta, los metadatos en diccionarios: `automation_groups` (`MENU_GROUP`,
zimmy.gd:71), `automation_badge_keys` (`BADGE_KEY`), `automation_cred_keys` (`CRED_KEY`),
`automation_icon_colors` (`ICON_COLOR`), `automation_flags` (`ICON_FLAG`). El menú se
reconstruye con `_rebuild_automations_menu()` (zimmy.gd:1029), respetando el idioma actual.

## 📜 Contrato de una automatización
- `func run(zimmy)` — **obligatorio**; recibe el nodo principal (acceso a `notify()`,
  `say()`, `feed()`, `pet()`, `play()`, `hop()`, `current`, `hunger`, `happy`, etc.).
- `const AUTOMATION_NAME` / `AUTOMATION_NAME_EN` — etiqueta en el menú (pt / en); sin ellos
  el nombre se deriva del archivo.
- `const SCHEDULE` / `SCHEDULE_SECONDS` — frecuencia (ver **Programador**).
- `const MENU_GROUP` — coloca el elemento en un submenú dedicado: `"email"` → 📧 E-mails
  ([[📧 Sistema - E-mails (ES)]]), `"moedas"` → 💱 Monedas ([[💱 Sistema - Moedas (ES)]]),
  `"whatsapp"` → 💬 WhatsApp. Sin grupo, cae en ⚙️ Automatizaciones.
- `const ICON_COLOR` (hex), `const BADGE_KEY` (etiqueta dinámica vía
  `set_automation_badge`), `const CRED_KEY` (credenciales), `const ICON_FLAG` (bandera).
- **Ciclo de vida:** `extends RefCounted` → descartado tras el `run()`; `extends Node` → se
  convierte en hijo de Zimmy y **persiste** (útil para automatizaciones continuas con
  `_process`).

## ⏱️ Programador — `_parse_schedule()` (zimmy.gd:1462)
Convierte `SCHEDULE`/`SCHEDULE_SECONDS` en un descriptor `{kind, every, at_minute, label}`:
- `"30s"` / `"5m"` / `"2h"` → **intervalo** (`_interval_def`, zimmy.gd:1491).
- `"hourly"` → cada **hora en punto** (minuto :00, alineado al reloj).
- `"daily@HH:MM"` → **una vez al día** a la hora indicada.
- número puro (o `SCHEDULE_SECONDS`) → segundos.

Las automatizaciones programadas aparecen en **⏱️ Temporizadores** (`timers_menu`,
`MI_TIMERS=21`, zimmy.gd:258) como elementos **marcables** (✓ = activada) con icono de reloj
y la frecuencia en la etiqueta — es el **programador visual**. El estado
activado/desactivado se **persiste** en `user://schedules.json` (`SCHEDULES_FILE`,
zimmy.gd:44) y se restaura al reabrir. El bucle `_tick_schedules(delta)` (zimmy.gd:1551)
dispara `_run_automation(path)` (zimmy.gd:1612) en el momento justo — el `run()` de una
programada debe hacer la acción **una vez** (la recurrencia es del programador). Ver
[[🔁 Fluxo - Loop (_process) (ES)]].

## 💬 Hablar desde automatizaciones
Usa **`zimmy.notify(msg)`** (zimmy.gd:3549): entra en una **cola**, aparece una a una y
permanece ~5 s (evita solapamientos cuando varias disparan a la vez, p. ej.: cotizaciones).
`say()` muestra al instante y desaparece en 2,5 s, sin cola. Ver
[[💬 Sistema - Balão de Fala (ES)]].

## 🌐 i18n para scripts
`zimmy.lang_text(pt, en)` (zimmy.gd:472), `zimmy.lang` (`"pt"`/`"en"`), y formateadores
localizados `fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (coma vs punto,
`DD/MM/AAAA` vs `MM/DD/YYYY`). Ver [[🧭 Sistema - Menu de Contexto (ES)]] (cambio de idioma).

## 🌐 Web, sistema y credenciales
- **Web:** `http_get_json(url, cb)` (zimmy.gd:1633) → `cb.call(ok, data)`.
- **Web autenticada:** `http_get_auth(url, user, pass, cb)` (zimmy.gd:1656) → HTTP Basic,
  `cb.call(status, body)`. Usado por Gmail ([[📧 Sistema - E-mails (ES)]]).
- **Sistema:** GDScript puede usar `OS.execute`/`OS.create_process` (p. ej.: `desligar_pc.gd`,
  `alarme.gd`).
- **Credenciales:** `with_credentials(key, título, cb)` (zimmy.gd:1869) entrega credenciales
  guardadas o abre el diálogo de inicio de sesión; `confirm_credentials(key, dados)` graba
  solo si son nuevas; `forget_credentials(key)` las borra. Se guardan en
  `user://cred_<key>.json` (gitignored).
- **Badges/sonido:** `set_automation_badge(key, texto)` (zimmy.gd:1678) actualiza la
  etiqueta y, cuando el valor aumenta, reproduce la alerta sonora del submenú
  correspondiente.

## 📜 Scripts incluidos (`Automacoes/`)
`alarme.gd` (daily@08:00), `comemoracao_hora_cheia.gd` (hourly — dispara **fuegos
artificiales** vía `zimmy.celebrate()`, ver [[✨ Sistema - Animação (ES)]]), `desligar_pc.gd`
(daily@23:00) + `cancelar_desligamento.gd`,
`lembrete_pomodoro.gd` (25m), `email_gmail.gd` ([[📧 Sistema - E-mails (ES)]]), `whatsapp.gd`,
`cotacao_usd/eur/gbp/jpy/cny.gd` ([[💱 Sistema - Moedas (ES)]]), `clima.gd` (tiempo actual vía Open-Meteo,
gratis/sin clave; geolocalización por IP con fallback). Plantilla: `exemplo_automacao.gd.example`.

Relacionado: [[🚪 Entrada - Itens do Menu (ES)]], [[🚪 Entrada - Funções de Ação (ES)]], [[🏠 Home (ES)]].
