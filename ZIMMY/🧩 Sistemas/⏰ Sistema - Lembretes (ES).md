---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, lembretes, agendador, usuario, zimmy-pet]
---

# ⏰ Sistema - Recordatorios (recurrentes del usuario)

> 🇧🇷 Lee esta página en portugués → [[⏰ Sistema - Lembretes]]
> 🇺🇸 Read this page in English → [[⏰ Sistema - Lembretes (EN)]]

Recordatorios recurrentes que el **usuario crea desde la interfaz, sin editar `.gd`**. Es un
sistema **nativo** (no usa la carpeta `Automacoes/`), así que funciona en el `.exe`
exportado. Refleja el patrón del sistema de Notas (elemento creado por diálogo, persistido,
submenú + eliminar) y reutiliza el **reloj del programador** de
[[⚙️ Sistema - Automações e Agendador (ES)]].

## ⏰ Submenú ⏰ Recordatorios — `_rebuild_reminders_menu()` (zimmy.gd:1460)
Elemento `MI_REMINDERS=23` (zimmy.gd:277), justo debajo de **⏱️ Temporizadores**. Contiene:
**➕ Nuevo recordatorio…** (`REM_NEW`), la lista de recordatorios como elementos
**marcables** (✓ = activado) y **🗑️ Eliminar recordatorio ▸** (`REM_DEL`, subsubmenú). Cada
recordatorio muestra `⏰ <mensaje> · <frecuencia>` (`_reminder_label`). Vacío → etiqueta
deshabilitada.

## 🗃️ Modelo de datos y persistencia
`reminders: Array` de `{text, sched, on}`, persistido en `user://reminders.json`
(`_save_reminders`/`_load_reminders`, zimmy.gd:1679). `sched` es una **cadena de
frecuencia** (p. ej.: `"30m"`, `"hourly"`, `"daily@08:00"`). `reminder_defs` (paralelo)
guarda el descriptor ya parseado y `reminder_rt` el runtime (accum/last_day/last_hour) de
los activados — recalculados por `_refresh_reminder_defs()` tras cualquier
carga/adición/eliminación/conmutación.

## 🆕 Diálogo de creación — `_build_reminders_dialog()` / `_open_reminder_dialog()` (zimmy.gd:1574)
`ConfirmationDialog` con: **mensaje** (`LineEdit`) + **frecuencia** (`OptionButton` con
preajustes: cada 15/30 min, 1 h, cada hora en punto, **diariamente a las…**) + **hora
HH:MM** (`LineEdit`, solo visible en el preajuste diario — `_on_reminder_freq_changed`). Al
confirmar (`_on_reminder_confirmed`, zimmy.gd:1630) construye la `sched` del preajuste,
valida (`_parse_hhmm` para la hora; `_parse_schedule_str` para la frecuencia) y añade el
recordatorio.

## 🔔 Disparo — `_tick_reminders(delta)` (zimmy.gd:1538)
Llamado en cada frame por `_process` (solo si hay recordatorios). Recorre los **activados**
y, para cada `def` (interval/hourly/daily), usa la **misma lógica** que `_tick_schedules`;
al alcanzar la frecuencia llama a `_fire_reminder(i)`, que hace `notify("⏰ " + text)` —
entra en la **cola de habla** (~5 s), ver [[💬 Sistema - Balão de Fala (ES)]].

## ♻️ Reutilización — `_parse_schedule_str()` (zimmy.gd:1767)
El parser de frecuencia se **extrajo** de `_parse_schedule` a una función que recibe la
cadena en crudo, ahora **compartida** entre las automatizaciones (`const SCHEDULE`) y los
recordatorios. Sin duplicación de lógica.

> Bilingüe (PT/EN): todas las etiquetas/mensajes vía `t()`; el submenú y el diálogo se
> re-traducen al cambiar de idioma ([[🧭 Sistema - Menu de Contexto (ES)]]).

Relacionado: [[⚙️ Sistema - Automações e Agendador (ES)]], [[🚪 Entrada - Itens do Menu (ES)]], [[🏠 Home (ES)]].
