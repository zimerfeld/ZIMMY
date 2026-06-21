---
tags: [fluxo, ciclo-de-vida, zimmy-pet]
atualizado: 2026-06-20
---

# 🔁 Fluxo - Loop (`_process`)

`_process(delta)` (`zimmy.gd:483`) roda todo frame, na ordem:

1. **Respiração** — `bob += delta*2.2` ([[Sistema - Animação]]).
2. **Cooldowns** — decrementa `action_cd` e `complain_cd`
   ([[Sistema - Interação e Mau Humor]]).
3. **Pulo** — integra `y_off`/`vy` com gravidade 900; trava no chão.
4. **Piscada** — `blink_timer`/`blink_t`.
5. **Olhos seguem o cursor** — calcula `pupil_off` a partir do centro real do pet.
6. **Geração aleatória contínua** — `random_pet_timer` e `random_acc_timer`
   (período `RANDOM_PERIOD=9s`), independentes ([[Fluxo - Geração Aleatória]]).
7. **Agendador de automações** — `_tick_schedules(delta)` dispara as automações
   agendadas ligadas conforme a frequência ([[Sistema - Menu de Contexto]]).
8. **Necessidades** — `hunger` sobe; se >70, `happy` cai.
9. **Limpa a fala** — ao expirar `speech_clear`, limpa e `_relayout()`
   ([[Sistema - Balão de Fala]]).
10. **`queue_redraw()`** — agenda o [[Sistema - Render (_draw)]].
