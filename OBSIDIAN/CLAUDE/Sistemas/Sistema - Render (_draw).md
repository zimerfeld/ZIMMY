---
tags: [sistema, render, desenho, zimmy-pet]
atualizado: 2026-06-20
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

## Ordem de desenho (`zimmy.gd:589`)
1. Sombra (encolhe no ar).
2. Antenas (atrás) — se `has_antennae`.
3. Orelhas — `round` (elipses) ou `pointy` (triângulos), se `has_ears`.
4. Corpo + barriga (respiram via `br = sin(bob)*0.025`).
5. Bochechas — se `has_cheeks`.
6. Nariz (triângulo) — se `has_nose`.
7. Olhos — fechados (piscada) ou abertos com pupila+brilho seguindo `pupil_off`.
8. Cílios — se `has_eyelashes`.
7–9. **Olhos + boca** — se há fala com emoji emotivo, o rosto é substituído por
   `_draw_expression()` ([[Sistema - Expressões Faciais]]); senão desenha olhos
   (piscada/cursor), cílios (`has_eyelashes`) e `_draw_mouth(style)`: `smile` (curva
   reflete `happy`), `cat`, `open`, `line`.
10. **Acessórios** — `if show_accessories` → `_draw_accessories()`
    ([[Sistema - Acessórios]]).

## Primitivas (helpers)
- `_ellipse(c, r, col, segs=40)` — polígono elíptico preenchido.
- `_dome(c, r, col)` — meia-elipse superior (chapéus).
- `_triangle(a,b,c,col)` — orelhas pontudas, nariz, laços.
- `_star(center, outer, inner, points, col)` — óculos "star".
- `_quad(p0,p1,p2,n)` — curva de Bézier quadrática (bocas).
- `_draw_mouth`, `_draw_eyelashes`, `_draw_antenna`, `_draw_bow`.

> Sincronizar com [[tools - make_icon.py]] (réplica do desenho p/ o ícone).
Cores/elementos vêm de [[Sistema - Pets]] e [[Sistema - Acessórios]].
