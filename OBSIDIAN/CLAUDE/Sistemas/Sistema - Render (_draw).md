---
tags: [sistema, render, desenho, zimmy-pet]
atualizado: 2026-06-21
---

# 🎨 Sistema - Render (_draw)

Tudo é desenhado em código a cada frame (`queue_redraw()` no
[[Fluxo - Loop (_process)]]). Sem sprites.

## Transform
```gdscript
draw_set_transform(Vector2(pet_x, pet_y), 0.0, Vector2(PET_SCALE, PET_SCALE))
```
O `_draw()` usa um **espaço lógico 200×200** (centro do corpo ~ (100,108)); o
transform escala por `PET_SCALE=0.75` e posiciona em `(pet_x, pet_y)` calculados no
[[Sistema - Janela Overlay|_relayout]]. `o = Vector2(0, y_off)` aplica o pulo.

## Ordem de desenho
A geometria do corpo (`bw`/`bh`/`by`/`head_top`) é calculada **no início**, para as
camadas traseiras e do topo se posicionarem em relação ao corpo.
1. Sombra (encolhe no ar).
2. **Asas** (`wings`) e **rabo** (`tail`) — bem atrás, antes do corpo.
3. Antenas (atrás) — se `has_antennae`.
4. Orelhas — `round` (elipses) ou `pointy` (triângulos), se `has_ears`.
5. **Patas** (`feet`) — atrás da base do corpo.
6. Corpo + barriga (respiram via `br = sin(bob)*0.025`); `pear` ganha bojo inferior.
7. **Bracinhos** (`arms`), **chifre** (`horn`) e **topete** (`hair_tuft`) por cima.
8. **Marca na barriga** (`belly_mark`), bochechas (`has_cheeks`), **sardas** (`freckles`).
9. Nariz (triângulo, `has_nose`) e **bigodes** (`whiskers`).
10. **Olhos + boca** — se há fala com emoji emotivo, o rosto é substituído por
   `_draw_expression()` ([[Sistema - Expressões Faciais]]); senão desenha olhos
   (formato por `eye_shape`; pupila por `pupil_style` via `_draw_pupils`),
   **sobrancelhas** (`eyebrow`, só neutro/olhos abertos), cílios (`has_eyelashes`) e
   `_draw_mouth(style)`.
10b. **Rosto de necessidade** — sem fala, se uma barra zerou, o rosto idle vira
    `hungry`/`needy`/`bored` (`_need_expression`) ([[Sistema - Necessidades]]).
11. **Acessórios** — `if show_accessories` → `_draw_accessories()`
    ([[Sistema - Acessórios]]).
12. **Barras de necessidade** — `if show_status: _draw_stat_bars()` — num **rodapé** abaixo
    do pet (transform identidade, px reais), 3 barras com ícone 🦴/🤚/🎾 (2×) à esquerda
    via `draw_string` ([[Sistema - Necessidades]]).

## Primitivas (helpers)
- `_ellipse(c, r, col, segs=40)` — polígono elíptico preenchido.
- `_dome(c, r, col)` — meia-elipse superior (chapéus).
- `_triangle(a,b,c,col)` — orelhas pontudas, nariz, laços.
- `_star(center, outer, inner, points, col)` — óculos "star", brilho da pupila sparkle.
- `_quad(p0,p1,p2,n)` — curva de Bézier quadrática (bocas, cacho do topete).
- `_draw_mouth`, `_draw_eyelashes`, `_draw_antenna`, `_draw_bow`.
- **Esqueleto extra (pet)**: `_draw_tail`, `_draw_horns`, `_draw_hair`, `_draw_feet`,
  `_draw_arms`, `_draw_wings`, `_draw_belly_mark`, `_draw_whiskers`, `_draw_freckles`,
  `_draw_eyebrows`, `_draw_pupils`, `_draw_body_pattern` (focinho é elipse inline).
- **Acessórios extras**: `_draw_sash`, `_draw_collar`, `_draw_necklace`, `_draw_tie`,
  `_draw_badge`, `_draw_headphones`, `_draw_flower`, `_draw_earrings`, `_draw_monocle`,
  `_draw_mustache`, `_draw_mask`, `_draw_cheek_sticker`, `_draw_belt`, `_draw_backpack`
  (além de `_draw_bow`).

> Sincronizar com [[tools - make_icon.py]] (réplica do desenho p/ o ícone).
Cores/elementos vêm de [[Sistema - Pets]] e [[Sistema - Acessórios]].
