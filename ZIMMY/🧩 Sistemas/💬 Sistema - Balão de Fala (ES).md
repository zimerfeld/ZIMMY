---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [sistema, fala, ui, zimmy-pet]
---

# 💬 Sistema - Bocadillo de Diálogo

> 🇧🇷 Lee esta página en portugués → [[💬 Sistema - Balão de Fala]]
> 🇺🇸 Read this page in English → [[💬 Sistema - Balão de Fala (EN)]]

Un `Label` (creado en la [[🟢 Fluxo - Inicialização (ES)]]) con contorno, usando la **fuente
predeterminada de Godot** (renderiza acentos y emojis en color en el renderer Compatibility —
un `SystemFont` haría desaparecer el texto).

## 🔌 API — dos carriles (reacción vs. cola)
El bocadillo tiene **dos carriles** resueltos por prioridad en el pump del
[[🔁 Fluxo - Loop (_process) (ES)]] (**reacción > notificación > nada**), para que nada se
pierda ni se convierta en spam:
- `say(msg, hold := REACTION_HOLD)` — **reacción inmediata** (interacciones con la mascota,
  hover, sacudida, selección, guardar/errores, saludo). Define `react_text`/`react_hold` y
  aparece **al instante**, con prioridad sobre la cola. `REACTION_HOLD = 2.5s`.
- `notify(msg)` — **cola de notificaciones** (automatizaciones/e-mails/recordatorios).
  Encola en `msg_queue` como `{text, wait}`; cada elemento permanece visible
  `MSG_DURATION = 10s` en su turno, sin solaparse. Mientras una reacción está en pantalla, la
  notificación **se pausa** (`notify_hold` no corre) y se reanuda después — así se ven los
  10 s completos.
- **Salto de cola por acción del usuario:** al hacer clic en una automatización,
  `_on_pick_automation` abre una ventana `urgent_cd = URGENT_WINDOW (6s)`. Dentro de ella,
  `notify()` llama a `_preempt_with(msg)` — la notificación de fondo vuelve al frente de la
  cola y la respuesta del usuario aparece **al instante** (cubre también las web asíncronas,
  cuyo callback llega dentro de la ventana).
- **Descarte por tiempo:** en cada frame el `wait` de cada elemento crece; los elementos que
  esperan más de `MAX_QUEUE_WAIT = 60s` en la cola se **descartan** (ya no son relevantes).
- En el pump, cuando no hay reacción ni notificación y la cola se vacía, el texto se limpia y
  la ventana se encoge.

## 📐 Dimensionamiento — en `_relayout()` ([[🪟 Sistema - Janela Overlay (ES)]])
- Mide el texto con la fuente real; el ancho crece solo lo necesario.
- Por encima de `MAX_W=300 px` activa el ajuste de línea (`AUTOWRAP_WORD_SMART`) y calcula el nº de líneas (el habla larga se parte en varias líneas).
- La franja del texto queda **justo encima del cuerpo** de la mascota:
  `speech.position.y = pet_y - SPEECH_GAP - band` (el `HOP_HEADROOM` sobra por encima).
- Constantes: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## 🗣️ Quién habla
Saludo inicial (`t("hello") % nome` — usa el **nombre de la mascota guardada activa**
`current_pet_name`, o "Zimmy" si es Default/aleatoria); acciones (`feed/pet/play/_react`);
generación/selección de mascotas y accesorios; guardar/errores; quejas de mal humor
([[😤 Sistema - Interação e Mau Humor (ES)]], lista `mood_neg`); reacciones al ratón (hover/sacudida,
ver [[😶‍🌫️ Sistema - Expressões Faciais (ES)]]); y las **automatizaciones/e-mails** (vía `notify()`, cola
de 10 s).

## 🪞 Se refleja en el rostro
`say()` también deduce la emoción del emoji y el rostro la refleja mientras dura el habla —
ver [[😶‍🌫️ Sistema - Expressões Faciais (ES)]].
