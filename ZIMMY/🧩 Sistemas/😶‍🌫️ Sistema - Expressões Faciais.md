---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [sistema, expressao, rosto, zimmy-pet]
---

# 😶‍🌫️ Sistema - Expressões Faciais

> 🇪🇸 Lee esta página en español → [[😶‍🌫️ Sistema - Expressões Faciais (ES)]]

Enquanto o pet fala, **o rosto espelha a emoção do emoji** da frase. Adicionado em
2026-06-20.

## 🔍 Como funciona
- `say(t)` guarda a fala; ao ser exibida, o pump calcula `expression` via
  `_expression_from_text(t)` (varre a frase por emojis conhecidos, em ordem de prioridade,
  e retorna a expressão ou `"neutral"`).
- **Prioridade do rosto** no [[🎨 Sistema - Render (_draw)]]:
  `react_expr` (reação de hover/sacudida) **>** emoji da fala **>** necessidade zerada
  **>** neutro. A primeira não-neutra vira `_draw_expression(expr, ...)` (olhos + boca +
  extras); o rosto neutro desenha olhos seguindo o cursor + boca do config + cílios.
- Ao limpar a fala/reação no [[🔁 Fluxo - Loop (_process)]], `expression` volta a `"neutral"`.

## 🗺️ Mapa emoji → expressão
| Expressão | Gatilhos | Rosto |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | olhos ∩, blush, sorrisão |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | olhos arregalados + brilho, boca aberta |
| `angry` | 😠 😤 😡 💢 | sobrancelhas \ /, olhos estreitos, boca ∩ |
| `sad` | 😢 😞 😭 🥺 | sobrancelhas / \, olhar p/ baixo, lágrima |
| `disgust` | 🤢 🤮 😖 | olho torto, boca ondulada, línguinha |
| `indifferent` | 😑 🙄 😒 🫤 | olhos em traço, boca reta |
| `sleepy` | 😴 💤 🥱 | olhos ∪, boquinha |

## 😖 Rostos de necessidade (sem fala) — via `_need_expression()`
Quando uma barra de necessidade zera, o **rosto idle** muda (mesma `_draw_expression`):
| Expressão | Gatilho | Rosto |
|---|---|---|
| `hungry` | `stat_feed=0` | olhos tristes, **boca bem aberta** + línguinha |
| `needy` | `stat_pet=0` | **chorando** (duas lágrimas), boca triste |
| `bored` | `stat_play=0` | **olhos fechados** (—), sobrancelha caída, boca reta |
Ver [[📊 Sistema - Necessidades]].

## 🖱️ Reações ao mouse (sem menu) — `react_expr` + clique no olho
Reações disparadas direto pelo cursor (ver [[🚪 Entrada - Eventos de Input]] e
[[✨ Sistema - Animação]]), com expressão temporária `react_expr` (prioridade máxima):
| Reação | Gatilho | Rosto |
|---|---|---|
| `happy`/`excited` | **hover** — cursor entra sobre o pet | expressão feliz/animada por ~1,1s |
| `dizzy` | **sacudir** o mouse rápido perto do pet | olhos em **espiral** (@_@) + boca ondulada |
| `nausea` | idem (sorteado) | olhos semicerrados + **bochechas esverdeadas** + boca ondulada |
| `scared` | idem (sorteado) | olhos **arregalados** (pupila pequena) + sobrancelhas altas + gota de suor |

**Clique no olho:** clicar sobre um olho fecha aquele olho (`eye_closed_l`/`eye_closed_r`,
arco ∪) e o mantém fechado **enquanto o cursor fica sobre ele** — reabre ao sair
(hit-test por elipse no espaço lógico; pupila desenhada por `_draw_pupil`, só no olho aberto).

## 🤝 Sinergia
As frases de [[😤 Sistema - Interação e Mau Humor|mau humor]] (`MOOD_NEG`) usam
🤢/😠/😤/😢/😞/😑/🙄/😴 — então **insistir numa ação** deixa o rosto raivoso/enojado/
triste/indiferente, não só o texto. As ações normais (`feed`🦴😋, `pet`🥰, `play`🎾🚀)
disparam happy/excited.

> ⚠️ Desenho novo no rosto → atualizar também [[📄 tools - make_icon.py]] **não** é
> necessário (o ícone usa só o rosto feliz padrão), mas mudanças no rosto **neutro**
> sim. Ver [[🎨 Sistema - Render (_draw)]].
