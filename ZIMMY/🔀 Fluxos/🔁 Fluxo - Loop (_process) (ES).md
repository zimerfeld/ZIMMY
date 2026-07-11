---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, ciclo-de-vida, zimmy-pet]
---

# 🔁 Flujo - Loop (`_process`)

> 🇧🇷 Lee esta página en portugués → [[🔁 Fluxo - Loop (_process)]]
> 🇺🇸 Read this page in English → [[🔁 Fluxo - Loop (_process) (EN)]]

`_process(delta)` (`zimmy.gd:483`) se ejecuta en cada frame, en este orden:

1. **Respiración** — `bob += delta*2.2` ([[✨ Sistema - Animação (ES)]]).
2. **Cooldowns** — decrementa `action_cd` y `complain_cd`
   ([[😤 Sistema - Interação e Mau Humor (ES)]]).
3. **Salto** — integra `y_off`/`vy` con gravedad 900; se detiene en el suelo.
4. **Parpadeo** — `blink_timer`/`blink_t`.
5. **Los ojos siguen el cursor** — calcula `pupil_off` a partir del centro real del pet.
6. **Generación aleatoria continua** — un único `random_timer` (período `RANDOM_PERIOD=30s`)
   para pet y accesorio; con ambos activados, cambian juntos ([[🎲 Fluxo - Geração Aleatória (ES)]]).
7. **Planificador de automatizaciones** — `_tick_schedules(delta)` dispara las automatizaciones
   programadas activadas según la frecuencia ([[🧭 Sistema - Menu de Contexto (ES)]]).
8. **Necesidades** — `hunger` sube; si >70, `happy` baja.
9. **Barras de necesidad** — `stat_decay_timer`; cada `STAT_DECAY_PERIOD=1800s`
   (30 min) cada barra (`stat_feed`/`stat_pet`/`stat_play`) baja 1; con las tres a 0,
   `get_tree().quit()` ([[📊 Sistema - Necessidades (ES)]]).
10. **Bloqueo de repeticiones** — `repeat_reset_cd` (libera el bloqueo de 3x tras 30s; ver
    [[😤 Sistema - Interação e Mau Humor (ES)]]).
11. **Limpia el habla** — al expirar `speech_clear`, limpia y `_relayout()`
    ([[💬 Sistema - Balão de Fala (ES)]]).
12. **`queue_redraw()`** — programa el [[🎨 Sistema - Render (_draw) (ES)]].
