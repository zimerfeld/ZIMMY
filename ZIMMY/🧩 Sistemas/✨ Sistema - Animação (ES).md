---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [sistema, animacao, zimmy-pet]
---

# ✨ Sistema - Animación

> 🇧🇷 Lee esta página en portugués → [[✨ Sistema - Animação]]
> 🇺🇸 Read this page in English → [[✨ Sistema - Animação (EN)]]

Animaciones procedurales reproducidas en el [[🔁 Fluxo - Loop (_process) (ES)]] y aplicadas
en el [[🎨 Sistema - Render (_draw) (ES)]].

## 🌬️ Respiración
`bob += delta * 2.2`; en `_draw`, `br = sin(bob) * 0.025` modula la altura del
cuerpo/barriga.

## ⬆️ Salto ("hop")
- La mascota **da un saltito** al interactuar. `hop(force=320)` es
  `func hop(force := 320.0) -> void: vy = -force`, llamada por
  `feed`/`pet`/`play`/`_react` y por la alarma (`alarme.gd`).
- La "gravedad" en `_process` (`y_off += vy*delta; vy += 900*delta; ...`) está activa y
  produce el salto: `vy` recibe el impulso negativo y la gravedad devuelve la mascota al
  suelo. La mascota también puede ser **arrastrada** por el usuario (botón izquierdo — ver
  [[🖱️ Fluxo - Arrastar e Posição (ES)]]).
- El `HOP_HEADROOM=80` en la [[🪟 Sistema - Janela Overlay (ES)]] reserva el espacio por
  encima de la mascota para que el salto no se corte.

## 🎬 Animaciones de reacción por acción (`ACTION_ANIMS`)
- Cada **acción de menú distinta** dispara una animación **sorteada** (`pick_random`) de un
  conjunto acorde a la "energía" de la acción — antes solo existía el saltito. Despacho en
  `play_action_anim(action)` → `play_anim(name)`.
- Repertorio (`play_anim`): `hop`, `double_hop`, `triple_hop`, `spin`, `spin_jump`,
  `backflip`, `wiggle`, `nod`, `squish`, `tilt`, `dance` — saltos físicos (vía `hop`/cola
  `hop_queue`) combinados con rotación / squash-stretch / balanceo calculados por fase en el
  `_draw` mientras `anim != ""`.
- Mapa `ACTION_ANIMS`: `feed` (alegría contenida: hop/nod/wiggle/squish); `pet`
  (se derrite/balancea: nod/wiggle/tilt/squish); `play` (energía alta: double/triple hop,
  spin_jump, backflip, dance); `react` (clic en la mascota: hop/wiggle/spin/tilt); `newpet`
  ("ta-chán": spin/spin_jump/dance); `newacc` (spin/wiggle/nod); `choose` (mascota/accesorio
  guardado: hop/spin/tilt); `save` (guardar/renombrar/notas: nod/hop); `sad` (eliminación:
  squish/tilt); `happy` (celebración genérica: hop/spin/dance).
- La **sombra permanece en el suelo** (dibujada antes del transform animado) y las barras de
  estado no se ven afectadas. Ver [[🎨 Sistema - Render (_draw) (ES)]].

## 😵 Animaciones de sacudida (`dizzy`/`nausea`/`scared`)
Agitar el ratón rápido cerca de la mascota (ver [[🚪 Entrada - Eventos de Input (ES)]]) llama
a `_trigger_shake()`, que sortea una de tres reacciones — `dizzy` (tambaleo: rotación
oscilante amplia), `nausea` (balanceo lento + squish vertical pulsante), `scared` (temblor
rápido/jitter + encogimiento con saltito) — combinadas con la expresión facial homónima
(`react_expr`, ver [[😶‍🌫️ Sistema - Expressões Faciais (ES)]]) y una frase corta.

## 🎆 Fuegos artificiales (`celebrate()`)
`celebrate(duration=3)` (llamado por `comemoracao_hora_cheia.gd`) dispara **fuegos
artificiales**: mientras `fw_time>0`, `_spawn_burst()` lanza ~14 chispas radiales de un color
en la franja por encima de la mascota; `_update_fireworks` mueve las partículas (`{p,v,life}`)
con una leve gravedad y `_draw_fireworks` las dibuja por encima de todo, con estela y brillo
que se desvanece. Va acompañado de un salto + bailecito. Barato — solo se ejecuta cuando hay
fuegos activos.

## 👁️ Parpadeo
`blink_timer` cuenta hasta parpadear; `blink_t=0.16s` mantiene los ojos cerrados; intervalo
aleatorio `randf_range(2.0, 5.0)`.

## 👀 Los ojos siguen el cursor
`pupil_off = (mouse - centro_do_pet).limit_length(120)/120 * 3.5`. El centro usa
`pet_x/pet_y + PET_DRAW/2` en la posición global de la ventana.

## 📊 Necesidades (humor/hambre)
`hunger` sube con el tiempo (`+0.7/s`); por encima de 70 baja `happy` (`-0.5/s`). `happy`
cambia la curva de la boca (`smile`). Ver también [[😤 Sistema - Interação e Mau Humor (ES)]].
