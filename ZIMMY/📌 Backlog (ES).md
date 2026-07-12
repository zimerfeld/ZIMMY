---
tipo: backlog
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [meta, backlog, zimmy-pet]
---

# 🗂️ _Backlog priorizado

> 🇧🇷 Lee esta página en portugués → [[📌 Backlog]]
> 🇺🇸 Read this page in English → [[📌 Backlog (EN)]]

> Nota **autosuficiente** para retomar el proyecto en cualquier chat nuevo.
> La regla global hace que Claude lea este cofre al inicio — así que **empieza por aquí** y
> luego por la [[🏠 Home (ES)]] y [[🧭 Como usar este cofre (ES)]].
> Convención de prioridad: **P0** = hacer ya / desbloquea el resto · **P1** = importante,
> siguiente lote · **P2** = cuando sobre tiempo / crecimiento.

## 📸 Snapshot del estado (2026-07-07)
- **Repo:** https://github.com/zimerfeld/ZIMMY · **rama:** `develop` (`0ce994e`) · **`main`:** `6b65440` (en sincronía con el origin).
- **Últimas releases:** tags **`202607071044geracao-30s`** (generación 30s) y **`202607071024reacoes-e-fala`** (lote de reacciones/habla). **GitHub Release** publicada en la tag de 30s con el `ZimmyPet.exe` adjunto (Latest).
- **Engine:** Godot 4.6.2, GDScript. Todo el código en [[📄 zimmy.gd (ES)]] (~4.215 líneas, `_draw()` procedural, sin sprites).
- **Árbol limpio** (aparte del churn de estado de Obsidian en `ZIMMY/.obsidian/*`, dejado fuera de los commits a propósito).
- **Reglas/memoria relevantes:** exportar `.exe` como paso final ([[🚀 Export e Publicação (Prod) (ES)]]); cerrar `ZimmyPet.exe` y el editor de Godot antes de tocar el código; mantener el recuento de clones/descargas; GitFlow (feature → develop → release → main + tag).

## 🔴 P0 — desbloquear
- [x] **P0-1 · Commitear la reestructuración del cofre** (`OBSIDIAN/CLAUDE/` → `OBSIDIAN/`) — hecho el 2026-07-01, commit `bdf60c6`: 62 renombrados (92–100%, historial preservado) + `_Backlog.md`; `git status` limpio para `OBSIDIAN/`.
- [x] **P0-2 · Corregir ruta obsoleta** — hecho el 2026-07-01: `...\OBSIDIAN\CLAUDE` → `...\OBSIDIAN` en [[🧭 Como usar este cofre (ES)]] (PT/EN) y [[📚 Repositório e Branches (ES)]] (PT/EN).

## 🟠 P1 — siguiente lote
- [x] **P1-1 · Cerrar el hueco de documentación del cofre.** Hecho el 2026-07-01: creadas [[⚙️ Sistema - Automações e Agendador (ES)]], [[💱 Sistema - Moedas (ES)]] y [[📧 Sistema - E-mails (ES)]] (par PT + (EN)), con refs `zimmy.gd:línea` verificadas y enlazadas en la [[🏠 Home (ES)]] (PT/EN). Detalles originales abajo, para referencia:
  - `Sistema - Automações e Agendador` — carpeta `Automacoes/`, submenú **⚙️ Automatizaciones** (sueltas) + **⏱️ Temporizadores** (agendadas, `const SCHEDULE`/`SCHEDULE_SECONDS`, persistidas en `user://schedules.json`). Scripts: `alarme.gd`, `comemoracao_hora_cheia.gd` (fuegos vía `celebrate()`), `desligar_pc.gd`, `cancelar_desligamento.gd`, `lembrete_pomodoro.gd`, `whatsapp.gd`, `email_gmail.gd`.
  - `Sistema - Moedas` — submenú **💱 Monedas** (`MENU_GROUP := "moedas"`, iconos de bandera pixel `ICON_FLAG`), scripts `cotacao_usd/eur/gbp/jpy/cny.gd`.
  - `Sistema - E-mails` — submenú **📧 E-mails** (Gmail, contador de no leídos, alerta sonora `🔊`).
  - API de automatización: `run(zimmy)`, `zimmy.notify()` (cola ~5 s) vs `say()` (2,5 s). Base: `Automacoes/LEIAME.md` y README §Automations.
  - Seguir la convención del cofre: crear **par PT + (EN)** de cada nota y **enlazarlas en la [[🏠 Home (ES)]]** (sección 🧩 Sistemas). Verificar líneas de `zimmy.gd` antes de citar `archivo:línea`.
  - **Hecho cuando:** cada submenú del README tiene nota espejo en el cofre y la Home apunta a ellas.
- [x] **P1-2 · Actualizar el recuento de clones/descargas** — hecho el 2026-07-01. `gh` ya estaba instalado **y autenticado** (ya no estaba bloqueado). Snapshot (clones 14d): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293 (descargas de release = 0 en los 4). Registrado en `contagem de downloads.txt` y en [[📈 Adoção e Métricas (ES)]] (PT/EN). **Nota:** clones es una ventana móvil de 14 días (no acumulado); el total histórico/NuGet es responsabilidad del proyecto zimerfeld.com.
- [x] **P1-3 · Exportar release `.exe`** — hecho el 2026-07-01: `build/ZimmyPet.exe` (~100 MB) exportado vía CLI headless de Godot 4.6.2 (preset `Windows Desktop`), **exit 0, sin errores/warnings**. Ninguna instancia estaba abierta. `build/` es gitignored (el `.exe` no se versiona). Ver [[🚀 Export e Publicação (Prod) (ES)]].

## ✅ Hecho recientemente
- [x] **Lote "Reacciones & habla" + generación 30s** — 2026-07-07 (2 releases en esta sesión):
  - **Reacciones al ratón:** hover → expresión feliz/animada; **clicar en un ojo** → se cierra hasta que el cursor salga; **sacudir el ratón** rápido → animación + expresión aleatoria de **mareo/náusea/susto** (`react_expr`, `_trigger_shake`). Ver [[😶‍🌫️ Sistema - Expressões Faciais (ES)]] y [[✨ Sistema - Animação (ES)]].
  - **Sonidos por grupo:** Alimentar/Cariño/Jugar reproducen variaciones aleatorias sorteadas dentro del grupo (`_build_*_sounds` + `_play_group`).
  - **Fuegos artificiales** en la celebración de la hora en punto (`zimmy.celebrate()` + `_draw_fireworks`); eliminada la automatización `auto_alimentar.gd` (20s).
  - **Cola de habla unificada:** reacciones inmediatas (`say`, ~2,5s) + cola de notificaciones (`notify`, 10s cada una, sin solapar); la acción del usuario **adelanta la cola** (`urgent_cd`/`_preempt_with`, cubre web asíncrona); un ítem que espera **>60s se descarta**. Ver [[💬 Sistema - Balão de Fala (ES)]].
  - **`RANDOM_PERIOD` 10s → 30s** (generación aleatoria de mascota/accesorio más espaciada).
  - **Revertido a petición del usuario:** la reorganización dinámica de menús por uso (y el `preferences.json` + ítem "Restaurar predeterminados") — los menús volvieron a ser **estáticos**.
  - **Cierre:** docs sincronizados (3 READMEs + notas del cofre + `LEIAME.md`); `.exe` reexportado (100 MB, icono vía rcedit, smoke-test OK). GitFlow: 2 releases finalizadas en `main` + tags **`202607071024reacoes-e-fala`** y **`202607071044geracao-30s`** (con backmerge `main → develop`). **GitHub Release** creada en la tag de 30s con el `ZimmyPet.exe` adjunto (Latest).
  - **Métricas:** snapshot de adopción 2026-07-07 (ZIMARO 706 · Tree 432 · CommitMsg 305 · ZIMMY 257 clones/14d) en `contagem de downloads.txt` y [[📈 Adoção e Métricas (ES)]]. El `ZimmyPet.exe` se publica en GitHub Release **desde 2026-06-25** (release `202606251217`); las *descargas* de ZIMMY = **acumulado all-time** del asset (hoy 0). Ese rastreo fue **automatizado en el D1 de GitAdoptionMeter** — nuevo host `github-release`, en vivo en `gitadoptionmeter.com/api/adoption` (campo `releaseDownloads`). Detalles en el backlog del proyecto GitAdoptionMeter.
- [x] **Renombrar el cofre `OBSIDIAN/` → `ZIMMY/`** — 2026-07-05: carpeta del cofre renombrada al nombre del proyecto. Referencias actualizadas en `.claude/build-if-changed.ps1` (la exclusión pasó de `\OBSIDIAN\` a `\ZIMMY\ZIMMY\`, ya que el proyecto raíz también es `...\ZIMMY`), en [[🧭 Como usar este cofre (ES)]] (PT/EN, ruta `C:\GODOT\ZIMMY\ZIMMY`) y en el árbol de [[📚 Repositório e Branches (ES)]] (PT/EN). El cofre global del usuario (`C:\Users\Renat\OBSIDIAN`) es otra cosa y no se tocó.
- [x] **Feature Recordatorios recurrentes del usuario** — 2026-07-02: submenú **⏰ Recordatorios** nativo (sin editar `.gd`) — diálogo con mensaje + desplegable de frecuencia (15/30 min, 1 h, hourly, `daily@HH:MM`) + campo de hora; ítems marcables (enciende/apaga), eliminar; persistido en `user://reminders.json`; disparo por el mismo reloj del agendador (parser `_parse_schedule_str` extraído y compartido). Compilado (`--check-only`), **probado en runtime** (18/18 asserts, incl. firing) y smoke test de la app OK. Documentado en README (raíz+PT+EN) y [[⏰ Sistema - Lembretes (ES)]] (PT/EN). Era la idea #2 de [[🚀 Distribuição e Crescimento (ES)]].
- [x] **Feature Clima** — 2026-07-01: `Automacoes/clima.gd` (Open-Meteo gratis/sin clave, geolocalización por IP con fallback, bilingüe). Sintaxis validada (`--check-only`) y **probada en runtime** (harness headless → "☀️ cielo despejado — 21,2°C en Rio de Janeiro"). Documentado en README (raíz+PT+EN), LEIAME y [[⚙️ Sistema - Automações e Agendador (ES)]]. Fue la idea #1 de [[🚀 Distribuição e Crescimento (ES)]].

## 🟡 P2 — crecimiento / cuando sobre
- [x] **P2-1 · Divulgación bilingüe** — hecho el 2026-07-01: copy PT+EN (anuncio corto, post largo y micro-posts por feature) en [[📣 Divulgação — Posts (ES)]]. Falta solo **publicar** en los canales.
- [~] **P2-2 · Evaluar canales de distribución** — análisis hecho en [[🚀 Distribuição e Crescimento (ES)]] (itch.io = mayor ROI → luego Reddit/vídeo → Store/Product Hunt). Descripción de la página **lista para pegar** en [[🎮 itch.io — Página (ES)]] (metadatos + EN/PT + checklist de medios). **Pendiente la ejecución (depende del usuario):** crear la cuenta/página en itch.io, subir el `.exe` y los GIFs.
- [x] **P2-3 · Ideas de producto** — priorizadas por atractivo × esfuerzo en [[🚀 Distribuição e Crescimento (ES)]] (arriba: clima 🔥 y recordatorios recurrentes del usuario 🔥). Validar antes de programar.

## 🔗 Ver también
[[🏠 Home (ES)]] · [[🧭 Como usar este cofre (ES)]] · [[📚 Repositório e Branches (ES)]] · [[🚀 Export e Publicação (Prod) (ES)]] · [[📄 zimmy.gd (ES)]]
</content>
