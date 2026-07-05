---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, lembretes, agendador, usuario, zimmy-pet]
---

# ⏰ Sistema - Lembretes (recorrentes do usuário)

Lembretes recorrentes que o **usuário cria pela interface, sem editar `.gd`**. É um sistema
**nativo** (não usa a pasta `Automacoes/`), então funciona no `.exe` exportado. Espelha o
padrão do sistema de Notas (item criado por diálogo, persistido, submenu + excluir) e reusa
o **relógio do agendador** de [[⚙️ Sistema - Automações e Agendador]].

## ⏰ Submenu ⏰ Lembretes — `_rebuild_reminders_menu()` (zimmy.gd:1460)
Item `MI_REMINDERS=23` (zimmy.gd:277), logo abaixo de **⏱️ Temporizadores**. Contém:
**➕ Novo lembrete…** (`REM_NEW`), a lista de lembretes como itens **marcáveis** (✓ = ligado)
e **🗑️ Excluir lembrete ▸** (`REM_DEL`, subsubmenu). Cada lembrete mostra
`⏰ <mensagem> · <frequência>` (`_reminder_label`). Vazio → rótulo desabilitado.

## 🗃️ Modelo de dados e persistência
`reminders: Array` de `{text, sched, on}`, persistido em `user://reminders.json`
(`_save_reminders`/`_load_reminders`, zimmy.gd:1679). `sched` é uma **string de frequência**
(ex.: `"30m"`, `"hourly"`, `"daily@08:00"`). `reminder_defs` (paralelo) guarda o descritor
já parseado e `reminder_rt` o runtime (accum/last_day/last_hour) dos ligados —
recalculados por `_refresh_reminder_defs()` após qualquer carga/adição/exclusão/toggle.

## 🆕 Diálogo de criação — `_build_reminders_dialog()` / `_open_reminder_dialog()` (zimmy.gd:1574)
`ConfirmationDialog` com: **mensagem** (`LineEdit`) + **frequência** (`OptionButton` com
presets: a cada 15/30 min, 1 h, de hora em hora, **diariamente às…**) + **hora HH:MM**
(`LineEdit`, só visível no preset diário — `_on_reminder_freq_changed`). Ao confirmar
(`_on_reminder_confirmed`, zimmy.gd:1630) monta a `sched` do preset, valida
(`_parse_hhmm` para a hora; `_parse_schedule_str` para a frequência) e adiciona o lembrete.

## 🔔 Disparo — `_tick_reminders(delta)` (zimmy.gd:1538)
Chamado a cada frame por `_process` (só se houver lembretes). Percorre os **ligados**, e
para cada `def` (interval/hourly/daily) usa a **mesma lógica** de `_tick_schedules`; ao
atingir a frequência chama `_fire_reminder(i)`, que faz `notify("⏰ " + text)` — entra na
**fila de fala** (~5 s), ver [[💬 Sistema - Balão de Fala]].

## ♻️ Reuso — `_parse_schedule_str()` (zimmy.gd:1767)
O parser de frequência foi **extraído** de `_parse_schedule` para uma função que recebe a
string crua, agora **compartilhada** entre as automações (`const SCHEDULE`) e os lembretes.
Sem duplicação de lógica.

> Bilíngue (PT/EN): todos os rótulos/mensagens via `t()`; o submenu e o diálogo se
> re-traduzem na troca de idioma ([[🧭 Sistema - Menu de Contexto]]).

Relacionado: [[⚙️ Sistema - Automações e Agendador]], [[🚪 Entrada - Itens do Menu]], [[🏠 Home]].
