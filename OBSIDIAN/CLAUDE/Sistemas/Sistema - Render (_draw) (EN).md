---
tags: [sistema, render, desenho, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🎨 System - Render (_draw)

Everything is drawn in code every frame (`queue_redraw()` in the
[[Fluxo - Loop (_process) (EN)]]). No sprites.

## Transform
```gdscript
draw_set_transform(Vector2(pet_x, pet_y), 0.0, Vector2(PET_SCALE, PET_SCALE))
```
`_draw()` uses a **200×200 logical space** (body center ~ (100,108)); the
transform scales by `PET_SCALE=0.75` and positions at `(pet_x, pet_y)` computed in the
[[Sistema - Janela Overlay (EN)|_relayout]]. `o = Vector2(0, y_off)` applies the jump.

## Drawing order
The body geometry (`bw`/`bh`/`by`/`head_top`) is computed **at the start**, so the
back and top layers position themselves relative to the body.
1. Shadow (shrinks in the air).
2. **Wings** (`wings`) and **tail** (`tail`) — far behind, before the body.
3. Antennae (behind) — if `has_antennae`.
4. Ears — `round` (ellipses) or `pointy` (triangles), if `has_ears`.
5. **Feet** (`feet`) — behind the base of the body.
6. Body + belly (breathe via `br = sin(bob)*0.025`); `pear` gains a lower bulge.
7. **Little arms** (`arms`), **horn** (`horn`) and **tuft** (`hair_tuft`) on top.
8. **Belly mark** (`belly_mark`), cheeks (`has_cheeks`), **freckles** (`freckles`).
9. Nose (triangle, `has_nose`) and **whiskers** (`whiskers`).
10. **Eyes + mouth** — if there is speech with an emotive emoji, the face is replaced by
   `_draw_expression()` ([[Sistema - Expressões Faciais (EN)]]); otherwise it draws eyes
   (shape by `eye_shape`; pupil by `pupil_style` via `_draw_pupils`),
   **eyebrows** (`eyebrow`, only neutral/open eyes), eyelashes (`has_eyelashes`) and
   `_draw_mouth(style)`.
11. **Accessories** — `if show_accessories` → `_draw_accessories()`
    ([[Sistema - Acessórios (EN)]]).

## Primitives (helpers)
- `_ellipse(c, r, col, segs=40)` — filled elliptical polygon.
- `_dome(c, r, col)` — upper half-ellipse (hats).
- `_triangle(a,b,c,col)` — pointy ears, nose, bows.
- `_star(center, outer, inner, points, col)` — "star" glasses, sparkle pupil glint.
- `_quad(p0,p1,p2,n)` — quadratic Bézier curve (mouths, tuft curl).
- `_draw_mouth`, `_draw_eyelashes`, `_draw_antenna`, `_draw_bow`.
- **Extra skeleton (pet)**: `_draw_tail`, `_draw_horns`, `_draw_hair`, `_draw_feet`,
  `_draw_arms`, `_draw_wings`, `_draw_belly_mark`, `_draw_whiskers`, `_draw_freckles`,
  `_draw_eyebrows`, `_draw_pupils`.
- **Extra accessories**: `_draw_sash`, `_draw_collar`, `_draw_necklace`, `_draw_tie`,
  `_draw_badge`, `_draw_headphones`, `_draw_flower`, `_draw_earrings`, `_draw_monocle`,
  `_draw_mustache`, `_draw_mask`, `_draw_cheek_sticker` (besides `_draw_bow`).

> Keep in sync with [[tools - make_icon.py (EN)]] (a replica of the drawing for the icon).
Colors/elements come from [[Sistema - Pets (EN)]] and [[Sistema - Acessórios (EN)]].
