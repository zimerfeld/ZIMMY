---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [sistema, expressao, rosto, zimmy-pet]
---

# 😶‍🌫️ Sistema - Expresiones Faciales

> 🇧🇷 Lee esta página en portugués → [[😶‍🌫️ Sistema - Expressões Faciais]]
> 🇺🇸 Read this page in English → [[😶‍🌫️ Sistema - Expressões Faciais (EN)]]

Mientras el pet habla, **la cara refleja la emoción del emoji** de la frase. Añadido en
2026-06-20.

## 🔍 Cómo funciona
- `say(t)` guarda el diálogo; al mostrarse, el pump calcula `expression` vía
  `_expression_from_text(t)` (recorre la frase en busca de emojis conocidos, en orden de prioridad,
  y devuelve la expresión o `"neutral"`).
- **Prioridad de la cara** en [[🎨 Sistema - Render (_draw) (ES)]]:
  `react_expr` (reacción de hover/sacudida) **>** emoji del diálogo **>** necesidad a cero
  **>** neutro. La primera no neutra se convierte en `_draw_expression(expr, ...)` (ojos + boca +
  extras); la cara neutra dibuja ojos siguiendo el cursor + boca del config + pestañas.
- Al limpiar el diálogo/reacción en el [[🔁 Fluxo - Loop (_process) (ES)]], `expression` vuelve a `"neutral"`.

## 🗺️ Mapa emoji → expresión
| Expresión | Disparadores | Cara |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | ojos ∩, blush, sonrisota |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | ojos muy abiertos + brillo, boca abierta |
| `angry` | 😠 😤 😡 💢 | cejas \ /, ojos estrechos, boca ∩ |
| `sad` | 😢 😞 😭 🥺 | cejas / \, mirada hacia abajo, lágrima |
| `disgust` | 🤢 🤮 😖 | ojo torcido, boca ondulada, lengüecita |
| `indifferent` | 😑 🙄 😒 🫤 | ojos en línea, boca recta |
| `sleepy` | 😴 💤 🥱 | ojos ∪, boquita |

## 😖 Caras de necesidad (sin diálogo) — vía `_need_expression()`
Cuando una barra de necesidad llega a cero, la **cara idle** cambia (misma `_draw_expression`):
| Expresión | Disparador | Cara |
|---|---|---|
| `hungry` | `stat_feed=0` | ojos tristes, **boca bien abierta** + lengüecita |
| `needy` | `stat_pet=0` | **llorando** (dos lágrimas), boca triste |
| `bored` | `stat_play=0` | **ojos cerrados** (—), ceja caída, boca recta |
Ver [[📊 Sistema - Necessidades (ES)]].

## 🖱️ Reacciones al ratón (sin menú) — `react_expr` + clic en el ojo
Reacciones disparadas directamente por el cursor (ver [[🚪 Entrada - Eventos de Input (ES)]] y
[[✨ Sistema - Animação (ES)]]), con expresión temporal `react_expr` (prioridad máxima):
| Reacción | Disparador | Cara |
|---|---|---|
| `happy`/`excited` | **hover** — el cursor entra sobre el pet | expresión feliz/animada por ~1,1s |
| `dizzy` | **sacudir** el ratón rápido cerca del pet | ojos en **espiral** (@_@) + boca ondulada |
| `nausea` | ídem (sorteado) | ojos entreabiertos + **mejillas verdosas** + boca ondulada |
| `scared` | ídem (sorteado) | ojos **muy abiertos** (pupila pequeña) + cejas altas + gota de sudor |

**Clic en el ojo:** hacer clic sobre un ojo cierra ese ojo (`eye_closed_l`/`eye_closed_r`,
arco ∪) y lo mantiene cerrado **mientras el cursor sigue sobre él** — se reabre al salir
(hit-test por elipse en el espacio lógico; pupila dibujada por `_draw_pupil`, solo en el ojo abierto).

## 🤝 Sinergia
Las frases de [[😤 Sistema - Interação e Mau Humor (ES)|mal humor]] (`MOOD_NEG`) usan
🤢/😠/😤/😢/😞/😑/🙄/😴 — así que **insistir en una acción** deja la cara rabiosa/asqueada/
triste/indiferente, no solo el texto. Las acciones normales (`feed`🦴😋, `pet`🥰, `play`🎾🚀)
disparan happy/excited.

> ⚠️ Dibujo nuevo en la cara → actualizar también [[📄 tools - make_icon.py (ES)]] **no** es
> necesario (el icono usa solo la cara feliz por defecto), pero cambios en la cara **neutra**
> sí. Ver [[🎨 Sistema - Render (_draw) (ES)]].
