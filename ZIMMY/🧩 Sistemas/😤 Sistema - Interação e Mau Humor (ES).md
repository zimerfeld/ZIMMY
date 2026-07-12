---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, interacao, gameplay, zimmy-pet]
---

# 😤 Sistema - Interacción y Mal Humor

> 🇧🇷 Lee esta página en portugués → [[😤 Sistema - Interação e Mau Humor]]
> 🇺🇸 Read this page in English → [[😤 Sistema - Interação e Mau Humor (EN)]]

Limita el spam de interacciones y da personalidad al pet. Centralizado en
`_can_act(action)` (`zimmy.gd:846`), llamado al inicio de cada acción
([[🚪 Entrada - Funções de Ação (ES)]]).

## 📏 Reglas
1. **Máx. 1 acción/clic por segundo** — `action_cd` (= `ACTION_COOLDOWN=1.0`),
   decrementado en el [[🔁 Fluxo - Loop (_process) (ES)]].
2. **La misma acción máx. 3x seguidas** — `last_action` + `action_repeats`
   (`MAX_REPEAT=3`). Una acción **diferente** pone la cuenta a cero. La traba también **se
   libera sola tras `REPEAT_RESET=30s`** sin una nueva acción aceptada: `repeat_reset_cd` (reiniciado
   en cada acción aceptada en `_can_act`) se decrementa en el [[🔁 Fluxo - Loop (_process) (ES)]] y, al
   llegar a 0, pone a cero `action_repeats`/`last_action` — la misma acción vuelve a funcionar y
   recuenta hasta 3.
3. **Insistir en la misma acción en <1s → queja** — si `action_cd>0` y la acción es la
   misma, llama a `_complain()`.

## 😤 `_complain()` (`zimmy.gd:864`)
Expresa **repulsión / rabia / tristeza / indiferencia / desdén** (frase aleatoria de
`ta("mood_neg")`, localizada, ej.: "¡para ya! 😠", "me da igual 😑", "...zzz 😴"), reduce `happy` en 6
y respeta un cooldown propio `complain_cd` (`COMPLAIN_COOLDOWN=1.5`) para no
spamear diálogo. El emoji de la frase también **deja la cara** rabiosa/asqueada/triste/
indiferente — ver [[😶‍🌫️ Sistema - Expressões Faciais (ES)]].

## 🧮 Tabla de decisión (misma acción)
| Situación | Resultado |
|---|---|
| 1ª–3ª vez, ≥1s entre ellas | ejecuta |
| repite <1s (insistencia) | bloquea + `_complain()` |
| 4ª+ vez, ≥1s, sin spam | bloquea en silencio |
| acción diferente | pone a cero el contador y ejecuta |
| 30s sin repetir (misma acción) | la traba se libera, recuenta desde cero |

> Solo las acciones de cariño/alimentar/jugar/clic pasan por aquí. Cambiar pet/
> accesorio y abrir el menú **no** están limitados.

Detalle del flujo en [[😼 Fluxo - Interação e Limites (ES)]].
