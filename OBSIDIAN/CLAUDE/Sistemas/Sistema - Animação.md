---
tags: [sistema, animacao, zimmy-pet]
atualizado: 2026-06-20
---

# ✨ Sistema - Animação

Animações procedurais tocadas no [[Fluxo - Loop (_process)]] e aplicadas no
[[Sistema - Render (_draw)]].

## Respiração
`bob += delta * 2.2`; no `_draw`, `br = sin(bob) * 0.025` modula a altura do
corpo/barriga.

## Pulo ("hop") com gravidade
- `hop(force=320)` faz `vy = -force`.
- No `_process`: `y_off += vy*delta; vy += 900*delta;` e trava em `y_off=0` no chão.
- Forças por ação: clique/`_react`/`feed` = 320, `pet` = 220, `play` = 420.
- Altura máxima do `play` ≈ 98 px lógicos → motivou o `HOP_HEADROOM=80` no
  [[Sistema - Janela Overlay]] para não cortar.

## Piscada
`blink_timer` conta até piscar; `blink_t=0.16s` mantém os olhos fechados; intervalo
aleatório `randf_range(2.0, 5.0)`.

## Olhos seguem o cursor
`pupil_off = (mouse - centro_do_pet).limit_length(120)/120 * 3.5`. O centro usa
`pet_x/pet_y + PET_DRAW/2` na posição global da janela.

## Necessidades (humor/fome)
`hunger` sobe com o tempo (`+0.7/s`); acima de 70 derruba `happy` (`-0.5/s`). `happy`
muda a curva da boca (`smile`). Ver também [[Sistema - Interação e Mau Humor]].
