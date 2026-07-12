---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, render, desenho, zimmy-pet]
---

# 🎨 Sistema - Render (_draw)

> 🇧🇷 Lee esta página en portugués → [[🎨 Sistema - Render (_draw)]]
> 🇺🇸 Read this page in English → [[🎨 Sistema - Render (_draw) (EN)]]

Todo se dibuja en código en cada frame (`queue_redraw()` en el
[[🔁 Fluxo - Loop (_process) (ES)]]). Sin sprites.

## 📐 Transform
```gdscript
draw_set_transform(Vector2(pet_x, pet_y), 0.0, Vector2(PET_SCALE, PET_SCALE))
```
El `_draw()` usa un **espacio lógico 200×200** (centro del cuerpo ~ (100,108)); el
transform escala por `PET_SCALE=0.75` y posiciona en `(pet_x, pet_y)` calculados en
[[🪟 Sistema - Janela Overlay (ES)|_relayout]]. `o = Vector2(0, y_off)` aplica el salto
(`y_off` oscila durante el salto — ver [[✨ Sistema - Animação (ES)]]).

## 🖌️ Orden de dibujo
La geometría del cuerpo (`bw`/`bh`/`by`/`head_top`) se calcula **al principio**, para que
las capas traseras y del tope se posicionen respecto al cuerpo.
1. Sombra (se encoge cuando la mascota está en el aire durante el salto).
2. **Alas** (`wings`) y **cola** (`tail`) — bien detrás, antes del cuerpo.
3. Antenas (detrás) — si `has_antennae`.
4. Orejas — `round` (elipses) o `pointy` (triángulos), si `has_ears`.
5. **Patas** (`feet`) — detrás de la base del cuerpo.
6. Cuerpo + barriga (respiran vía `br = sin(bob)*0.025`); `pear` gana un bulto inferior.
7. **Bracitos** (`arms`), **cuerno** (`horn`) y **tupé** (`hair_tuft`) por encima.
8. **Marca en la barriga** (`belly_mark`), mejillas (`has_cheeks`), **pecas** (`freckles`).
9. Nariz (triángulo, `has_nose`) y **bigotes** (`whiskers`).
10. **Ojos + boca** — si hay habla con emoji emotivo, el rostro se sustituye por
   `_draw_expression()` ([[😶‍🌫️ Sistema - Expressões Faciais (ES)]]); si no, dibuja ojos
   (forma por `eye_shape`; pupila por `pupil_style` vía `_draw_pupils`),
   **cejas** (`eyebrow`, solo neutro/ojos abiertos), pestañas (`has_eyelashes`) y
   `_draw_mouth(style)`.
10b. **Rostro de necesidad** — sin habla, si una barra llega a cero, el rostro idle pasa a
    `hungry`/`needy`/`bored` (`_need_expression`) ([[📊 Sistema - Necessidades (ES)]]).
11. **Accesorios** — `if show_accessories` → `_draw_accessories()`
    ([[🎀 Sistema - Acessórios (ES)]]).
12. **Barras de necesidad** — `if show_status: _draw_stat_bars()` — en un **pie** debajo
    de la mascota (transform identidad, px reales), 3 barras con icono 🦴/🤚/🎾 (2×) a la izquierda
    vía `draw_string` ([[📊 Sistema - Necessidades (ES)]]).

## 🧱 Primitivas (helpers)
- `_ellipse(c, r, col, segs=40)` — polígono elíptico relleno.
- `_dome(c, r, col)` — media elipse superior (sombreros).
- `_triangle(a,b,c,col)` — orejas puntiagudas, nariz, lazos.
- `_star(center, outer, inner, points, col)` — gafas "star", brillo de la pupila sparkle.
- `_quad(p0,p1,p2,n)` — curva de Bézier cuadrática (bocas, rizo del tupé).
- `_draw_mouth`, `_draw_eyelashes`, `_draw_antenna`, `_draw_bow`.
- **Esqueleto extra (pet)**: `_draw_tail`, `_draw_horns`, `_draw_hair`, `_draw_feet`,
  `_draw_arms`, `_draw_wings`, `_draw_belly_mark`, `_draw_whiskers`, `_draw_freckles`,
  `_draw_eyebrows`, `_draw_pupils`, `_draw_body_pattern` (el hocico es una elipse inline).
- **Accesorios extra**: `_draw_sash`, `_draw_collar`, `_draw_necklace`, `_draw_tie`,
  `_draw_badge`, `_draw_headphones`, `_draw_flower`, `_draw_earrings`, `_draw_monocle`,
  `_draw_mustache`, `_draw_mask`, `_draw_cheek_sticker`, `_draw_belt`, `_draw_backpack`
  (además de `_draw_bow`).

> Sincronizar con [[📄 tools - make_icon.py (ES)]] (réplica del dibujo p/ el icono).
Colores/elementos vienen de [[🐾 Sistema - Pets (ES)]] y [[🎀 Sistema - Acessórios (ES)]].
