---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, necessidades, gameplay, zimmy-pet]
---

# 📊 Sistema - Necesidades (Alimentar/Cariño/Jugar)

> 🇧🇷 Lee esta página en portugués → [[📊 Sistema - Necessidades]]
> 🇺🇸 Read this page in English → [[📊 Sistema - Necessidades (EN)]]

Tres necesidades estilo tamagotchi, mostradas como **barras sutiles en el pie** del pet.
Estado en `stat_feed` / `stat_pet` / `stat_play` (0..100, `STAT_MAX=100`). **No se
persisten**: empiezan llenas (100%) en cada apertura.

## 📊 Barras — `_draw_stat_bars()`
Dibujadas en un **pie reservado debajo del pet** (`STATUS_FOOTER=58px`, añadido al
`win_h` en `_relayout` solo cuando `show_status`). El `_draw_stat_bars()` resetea el transform
a **identidad** (px reales — no escala con `PET_SCALE` ni con el `y_off` del salto) y apila 3
líneas (`row_h=16`, barra `bh=8`): raíl `Color(0,0,0,0.18)` + relleno de color con
ancho = `bw * stat/100` (sin números). El conjunto **icono+barra tiene el ancho del pet**
(`PET_DRAW`) y queda **centrado bajo él** (a partir de `pet_x`) — **no se estira** con el
globo de diálogo. Cada barra tiene el **icono del menú a la izquierda**
(🦴/🤚/🎾, `icon_fs=17` ≈ 2× el anterior) vía `draw_string` con `speech.get_theme_font("font")`:
- Alimentar → `COL_FEED` (blanco), Cariño → `COL_PET` (amarillo), Jugar → `COL_PLAY` (rosa rojizo).
El pet queda **anclado por el centro-inferior** (el pie crece hacia abajo, sin mover el pet).
Solo con `show_status` (checkbox **📊 Status**, encima de Alimentar; **OFF por defecto**,
persistido en settings.json `status` vía `_set_show_status` → `_relayout`). Ver
[[🎨 Sistema - Render (_draw) (ES)]] y [[🧭 Sistema - Menu de Contexto (ES)]].

## 📉 Decaimiento y cierre — `_process`
Cada `STAT_DECAY_PERIOD = 1800s` (30 min) cada barra pierde **1 punto**
(`stat_decay_timer`). Hacer la acción correspondiente rellena **solo esa** barra a 100
(`feed()`/`pet()`/`play()` en [[🚪 Entrada - Funções de Ação (ES)]]). Cuando **las tres** llegan a
cero, `get_tree().quit()` **cierra la ventana y termina el proceso**.

**Alerta sonora de necesidad baja**: aún en el decaimiento, cuando una barra **cruza
`STAT_LOW = 20` hacia abajo** (solo en la **transición** — guarda el valor anterior y compara, así que
suena una vez por cruce, no en cada ciclo por debajo del umbral), Zimmy reproduce el sonido de esa
acción (`_feed_player`/`_pet_player`/`_play_player`), siempre que el toggle correspondiente esté
activado (`sound_feed_on`/`sound_pet_on`/`sound_play_on`). Es **el mismo sonido** que se reproduce al ejecutar
la acción; el submenú **🔊 Alertas de sonido** (`MI_SOUNDS`) controla los dos disparadores. Ver
[[🧭 Sistema - Menu de Contexto (ES)]] y [[🚪 Entrada - Funções de Ação (ES)]].

## 😖 Cara de necesidad — `_need_expression()`
Sin diálogo, si una barra está en 0 la cara cambia (prioridad hambre > necesitado > aburrido),
vía `_draw_expression` ([[😶‍🌫️ Sistema - Expressões Faciais (ES)]]):
- `stat_feed=0` → **hungry**: cara de hambre, **boca bien abierta** + lengüecita.
- `stat_pet=0` → **needy**: cara de necesitado, **llorando** (dos lágrimas) + boca triste.
- `stat_play=0` → **bored**: cara de aburrido, **ojos cerrados** (—) + boca recta.

> El diálogo (emoji emotivo) todavía tiene prioridad sobre la cara de necesidad.

Relacionado: [[😤 Sistema - Interação e Mau Humor (ES)]], [[🔁 Fluxo - Loop (_process) (ES)]].
