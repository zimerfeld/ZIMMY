---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, interacao, gameplay, zimmy-pet]
---

# 😤 Sistema - Interação e Mau Humor

> 🇪🇸 Lee esta página en español → [[😤 Sistema - Interação e Mau Humor (ES)]]

Limita o spam de interações e dá personalidade ao pet. Centralizado em
`_can_act(action)` (`zimmy.gd:846`), chamado no início de cada ação
([[🚪 Entrada - Funções de Ação]]).

## 📏 Regras
1. **Máx. 1 ação/clique por segundo** — `action_cd` (= `ACTION_COOLDOWN=1.0`),
   decrementado no [[🔁 Fluxo - Loop (_process)]].
2. **A mesma ação no máx. 3x seguidas** — `last_action` + `action_repeats`
   (`MAX_REPEAT=3`). Uma ação **diferente** zera a contagem. A trava também **libera
   sozinha após `REPEAT_RESET=30s`** sem nova ação aceita: `repeat_reset_cd` (reiniciado
   a cada ação aceita em `_can_act`) é decrementado no [[🔁 Fluxo - Loop (_process)]] e, ao
   chegar a 0, zera `action_repeats`/`last_action` — a mesma ação volta a funcionar e
   reconta até 3.
3. **Insistir na mesma ação em <1s → reclamação** — se `action_cd>0` e a ação é a
   mesma, chama `_complain()`.

## 😤 `_complain()` (`zimmy.gd:864`)
Expressa **repulsa / raiva / tristeza / indiferença / descaso** (frase aleatória de
`ta("mood_neg")`, localizada, ex.: "para com isso! 😠", "tanto faz 😑", "...zzz 😴"), reduz `happy` em 6
e respeita um cooldown próprio `complain_cd` (`COMPLAIN_COOLDOWN=1.5`) para não
spammar fala. O emoji da frase também **deixa o rosto** raivoso/enojado/triste/
indiferente — ver [[😶‍🌫️ Sistema - Expressões Faciais]].

## 🧮 Tabela de decisão (mesma ação)
| Situação | Resultado |
|---|---|
| 1ª–3ª vez, ≥1s entre elas | executa |
| repete <1s (insistência) | bloqueia + `_complain()` |
| 4ª+ vez, ≥1s, sem spam | bloqueia em silêncio |
| ação diferente | zera contador e executa |
| 30s sem repetir (mesma ação) | trava libera, reconta do zero |

> Só as ações de carinho/alimentar/brincar/clique passam por aqui. Trocar pet/
> acessório e abrir menu **não** são limitados.

Detalhe do fluxo em [[😼 Fluxo - Interação e Limites]].
