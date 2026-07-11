---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [endpoint, api, zimmy-pet]
---

# 🚪 Punto de Entrada - Funciones de Acción

> 🇧🇷 Lee esta página en portugués → [[🚪 Entrada - Funções de Ação]]
> 🇺🇸 Read this page in English → [[🚪 Entrada - Funções de Ação (EN)]]

La "API pública" del comportamiento del pet. Todas las de interacción pasan por
`_can_act()` ([[😤 Sistema - Interação e Mau Humor (ES)]]).

| Función | ¿Pública? | ¿Limitada? | Resumen |
|---|---|---|---|
| `feed()` | sí | sí | come: −hambre, +humor, habla, **sonido** (si está activado) |
| `pet()` | sí | sí | caricia: +humor, **sonido** (si está activado) |
| `play()` | sí | sí | juega: +humor, +hambre, **sonido** (si está activado) |
| `_react()` | no | sí | clic simple: +humor leve |
| `_complain()` | no | — | mal humor (insistencia), −humor |
| `hop(force=320)` | sí | no | saltito: `vy = -force` (el pet salta) |
| `say(t)` | sí | no | muestra texto y re-maqueta |

## ⚡ Disparadores
- Menú → [[🚪 Entrada - Itens do Menu (ES)]] (`feed/pet/play`).
- Clic en el pet → `_react` ([[🚪 Entrada - Eventos de Input (ES)]]).
- `hop`/`say` son llamadas por casi todo (generación, guardar, etc.). `hop` es llamada por
  `feed`/`pet`/`play`/`_react`/`alarme.gd` y hace que el pet **salte** (`vy = -force`); el pet
  también puede ser arrastrado por el usuario.

## 🔊 Sonido de la acción (🔊 Alertas de som)
Al final, `feed`/`pet`/`play` reproducen `_feed_player`/`_pet_player`/`_play_player` (mediante
`_play_alert`) cuando el toggle de la acción está activado (`sound_feed_on`/`sound_pet_on`/
`sound_play_on`, submenú **🔊 Alertas de som** = `MI_SOUNDS`). **El mismo sonido** también sirve de
**recordatorio** cuando la necesidad correspondiente cae por debajo de `STAT_LOW = 20`
([[📊 Sistema - Necessidades (ES)]], [[🧭 Sistema - Menu de Contexto (ES)]]).

> Idea de evolución: ZIMARO podría lanzar el pet mediante `OS.create_process()` y, en el
> futuro, comandar `say()`/acciones por algún IPC. Hoy no existe tal endpoint externo.

Efectos numéricos en [[😼 Fluxo - Interação e Limites (ES)]].
