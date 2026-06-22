---
tags: [sistema, expressao, rosto, zimmy-pet]
atualizado: 2026-06-21
---

# 😶‍🌫️ Sistema - Expressões Faciais

Enquanto o pet fala, **o rosto espelha a emoção do emoji** da frase. Adicionado em
2026-06-20.

## Como funciona
- `say(t)` chama `_expression_from_text(t)` e guarda em `expression`.
- `_expression_from_text` (`zimmy.gd`) varre a frase por emojis conhecidos, em ordem
  de prioridade, e retorna a expressão (ou `"neutral"`).
- No [[Sistema - Render (_draw)]], se há fala (`speech.text != ""`) e
  `expression != "neutral"`, o rosto padrão é **substituído** por
  `_draw_expression(expr, ...)` (olhos + boca + extras). Senão, desenha o rosto
  normal (olhos seguindo o cursor + boca do config + cílios).
- Ao limpar a fala no [[Fluxo - Loop (_process)]], `expression` volta a `"neutral"`.

## Mapa emoji → expressão
| Expressão | Gatilhos | Rosto |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | olhos ∩, blush, sorrisão |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | olhos arregalados + brilho, boca aberta |
| `angry` | 😠 😤 😡 💢 | sobrancelhas \ /, olhos estreitos, boca ∩ |
| `sad` | 😢 😞 😭 🥺 | sobrancelhas / \, olhar p/ baixo, lágrima |
| `disgust` | 🤢 🤮 😖 | olho torto, boca ondulada, línguinha |
| `indifferent` | 😑 🙄 😒 🫤 | olhos em traço, boca reta |
| `sleepy` | 😴 💤 🥱 | olhos ∪, boquinha |

## Rostos de necessidade (sem fala) — via `_need_expression()`
Quando uma barra de necessidade zera, o **rosto idle** muda (mesma `_draw_expression`):
| Expressão | Gatilho | Rosto |
|---|---|---|
| `hungry` | `stat_feed=0` | olhos tristes, **boca bem aberta** + línguinha |
| `needy` | `stat_pet=0` | **chorando** (duas lágrimas), boca triste |
| `bored` | `stat_play=0` | **olhos fechados** (—), sobrancelha caída, boca reta |
Ver [[Sistema - Necessidades]].

## Sinergia
As frases de [[Sistema - Interação e Mau Humor|mau humor]] (`MOOD_NEG`) usam
🤢/😠/😤/😢/😞/😑/🙄/😴 — então **insistir numa ação** deixa o rosto raivoso/enojado/
triste/indiferente, não só o texto. As ações normais (`feed`🦴😋, `pet`🥰, `play`🎾🚀)
disparam happy/excited.

> ⚠️ Desenho novo no rosto → atualizar também [[tools - make_icon.py]] **não** é
> necessário (o ícone usa só o rosto feliz padrão), mas mudanças no rosto **neutro**
> sim. Ver [[Sistema - Render (_draw)]].
