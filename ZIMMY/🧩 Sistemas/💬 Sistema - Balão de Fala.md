---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [sistema, fala, ui, zimmy-pet]
---

# 💬 Sistema - Balão de Fala

Um `Label` (criado no [[🟢 Fluxo - Inicialização]]) com contorno, usando a **fonte
padrão do Godot** (renderiza acentos e emojis coloridos no renderer Compatibility —
um `SystemFont` faria o texto sumir).

## 🔌 API — duas pistas (reação vs. fila)
O balão tem **duas pistas** resolvidas por prioridade no pump do
[[🔁 Fluxo - Loop (_process)]] (**reação > notificação > nada**), para nada se perder nem
virar spam:
- `say(msg, hold := REACTION_HOLD)` — **reação imediata** (interações do pet, hover,
  sacudida, seleção, salvar/erros, saudação). Define `react_text`/`react_hold` e aparece
  **na hora**, com prioridade sobre a fila. `REACTION_HOLD = 2.5s`.
- `notify(msg)` — **fila de notificações** (automações/e-mails/lembretes). Enfileira em
  `msg_queue` como `{text, wait}`; cada item fica visível `MSG_DURATION = 10s` na sua vez,
  sem se sobreporem. Enquanto uma reação está no ar, a notificação **pausa** (`notify_hold`
  não corre) e retoma depois — assim vê os 10s cheios.
- **Furo de fila por ação do usuário:** ao clicar numa automação, `_on_pick_automation`
  abre uma janela `urgent_cd = URGENT_WINDOW (6s)`. Dentro dela, `notify()` chama
  `_preempt_with(msg)` — a notificação de fundo volta pra frente da fila e a resposta do
  usuário aparece **na hora** (cobre também as web assíncronas, cujo callback chega dentro
  da janela).
- **Descarte por tempo:** a cada frame o `wait` de cada item cresce; itens que esperam
  mais que `MAX_QUEUE_WAIT = 60s` na fila são **descartados** (já não são relevantes).
- No pump, quando não há reação nem notificação e a fila esvazia, o texto é limpo e a
  janela encolhe.

## 📐 Dimensionamento — em `_relayout()` ([[🪟 Sistema - Janela Overlay]])
- Mede o texto com a fonte real; largura cresce só o necessário.
- Acima de `MAX_W=300 px` ativa quebra (`AUTOWRAP_WORD_SMART`) e calcula nº de linhas (fala longa quebra em várias linhas).
- A faixa do texto fica **logo acima do corpo** do pet:
  `speech.position.y = pet_y - SPEECH_GAP - band` (o `HOP_HEADROOM` sobra por cima).
- Constantes: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## 🗣️ Quem fala
Saudação inicial (`t("hello") % nome` — usa o **nome do pet salvo ativo**
`current_pet_name`, ou "Zimmy" se for Default/aleatório); ações (`feed/pet/play/_react`);
geração/seleção de pets e acessórios; salvar/erros; reclamações de mau humor
([[😤 Sistema - Interação e Mau Humor]], lista `mood_neg`); reações ao mouse (hover/sacudida,
ver [[😶‍🌫️ Sistema - Expressões Faciais]]); e as **automações/e-mails** (via `notify()`, fila
de 10s).

## 🪞 Espelha no rosto
`say()` também deduz a emoção do emoji e o rosto a reflete enquanto a fala dura —
ver [[😶‍🌫️ Sistema - Expressões Faciais]].
