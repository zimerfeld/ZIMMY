---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [sistema, animacao, zimmy-pet]
---

# ✨ Sistema - Animação

Animações procedurais tocadas no [[🔁 Fluxo - Loop (_process)]] e aplicadas no
[[🎨 Sistema - Render (_draw)]].

## 🌬️ Respiração
`bob += delta * 2.2`; no `_draw`, `br = sin(bob) * 0.025` modula a altura do
corpo/barriga.

## ⬆️ Pulo ("hop")
- O pet **dá um pulinho** ao interagir. `hop(force=320)` é
  `func hop(force := 320.0) -> void: vy = -force`, chamada por
  `feed`/`pet`/`play`/`_react` e pelo alarme (`alarme.gd`).
- A "gravidade" no `_process` (`y_off += vy*delta; vy += 900*delta; ...`) está ativa e
  produz o salto: `vy` recebe o impulso negativo e a gravidade traz o pet de volta ao chão.
  O pet também pode ser **arrastado** pelo usuário (botão esquerdo — ver
  [[🖱️ Fluxo - Arrastar e Posição]]).
- O `HOP_HEADROOM=80` no [[🪟 Sistema - Janela Overlay]] reserva o espaço acima do pet
  para o pulo não ser cortado.

## 🎬 Animações de reação por ação (`ACTION_ANIMS`)
- Cada **ação de menu distinta** dispara uma animação **sorteada** (`pick_random`) de um
  conjunto combinado à "energia" da ação — antes só havia o pulinho. Despacho em
  `play_action_anim(action)` → `play_anim(name)`.
- Repertório (`play_anim`): `hop`, `double_hop`, `triple_hop`, `spin`, `spin_jump`,
  `backflip`, `wiggle`, `nod`, `squish`, `tilt`, `dance` — pulos físicos (via `hop`/fila
  `hop_queue`) combinados com rotação / squash-stretch / balanço calculados por fase no
  `_draw` enquanto `anim != ""`.
- Mapa `ACTION_ANIMS`: `feed` (alegria contida: hop/nod/wiggle/squish); `pet`
  (derrete/balança: nod/wiggle/tilt/squish); `play` (energia alta: double/triple hop,
  spin_jump, backflip, dance); `react` (clique no pet: hop/wiggle/spin/tilt); `newpet`
  ("ta-dá": spin/spin_jump/dance); `newacc` (spin/wiggle/nod); `choose` (pet/acessório
  salvo: hop/spin/tilt); `save` (salvar/renomear/notas: nod/hop); `sad` (exclusão:
  squish/tilt); `happy` (comemoração genérica: hop/spin/dance).
- A **sombra fica no chão** (desenhada antes do transform animado) e as barras de status
  não são afetadas. Ver [[🎨 Sistema - Render (_draw)]].

## 😵 Animações de sacudida (`dizzy`/`nausea`/`scared`)
Sacudir o mouse rápido perto do pet (ver [[🚪 Entrada - Eventos de Input]]) chama
`_trigger_shake()`, que sorteia uma de três reações — `dizzy` (cambaleio: rotação
oscilante ampla), `nausea` (balanço lento + squish vertical pulsante), `scared` (tremor
rápido/jitter + encolhida com pulinho) — casadas com a expressão facial homônima
(`react_expr`, ver [[😶‍🌫️ Sistema - Expressões Faciais]]) e uma fala curta.

## 🎆 Fogos de artifício (`celebrate()`)
`celebrate(duration=3)` (chamado por `comemoracao_hora_cheia.gd`) dispara **fogos**:
enquanto `fw_time>0`, `_spawn_burst()` lança ~14 fagulhas radiais de uma cor na faixa
acima do pet; `_update_fireworks` move as partículas (`{p,v,life}`) com leve gravidade e
`_draw_fireworks` as desenha por cima de tudo, com rastro e brilho que some. Acompanha um
pulo + dancinha. Barato — só roda quando há fogos ativos.

## 👁️ Piscada
`blink_timer` conta até piscar; `blink_t=0.16s` mantém os olhos fechados; intervalo
aleatório `randf_range(2.0, 5.0)`.

## 👀 Olhos seguem o cursor
`pupil_off = (mouse - centro_do_pet).limit_length(120)/120 * 3.5`. O centro usa
`pet_x/pet_y + PET_DRAW/2` na posição global da janela.

## 📊 Necessidades (humor/fome)
`hunger` sobe com o tempo (`+0.7/s`); acima de 70 derruba `happy` (`-0.5/s`). `happy`
muda a curva da boca (`smile`). Ver também [[😤 Sistema - Interação e Mau Humor]].
