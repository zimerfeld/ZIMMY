---
tags: [sistema, fala, ui, zimmy-pet]
atualizado: 2026-06-21
---

# 💬 Sistema - Balão de Fala

Um `Label` (criado no [[Fluxo - Inicialização]]) com contorno, usando a **fonte
padrão do Godot** (renderiza acentos e emojis coloridos no renderer Compatibility —
um `SystemFont` faria o texto sumir).

## API
- `say(msg, hold := 2.5)` — define o texto, agenda a limpeza (`speech_clear = hold`) e
  chama `_relayout()`. Mostra **na hora** (interações do pet, seleção, salvar/erros).
- `notify(msg)` — **fila de avisos** para automações/e-mails: enfileira em `notify_queue`
  e o [[Fluxo - Loop (_process)]] solta a próxima a cada `NOTIFY_GAP = 5s` (`notify_cd`),
  chamando `say(msg, NOTIFY_HOLD)` — a mensagem fica visível **5s** (`NOTIFY_HOLD`) antes
  de sumir. Evita que várias mensagens (ex.: várias cotações) se sobreponham. A 1ª
  aparece já; as seguintes esperam 5s.
- No [[Fluxo - Loop (_process)]], ao expirar `speech_clear` o texto é limpo e a janela
  encolhe.

## Dimensionamento — em `_relayout()` ([[Sistema - Janela Overlay]])
- Mede o texto com a fonte real; largura cresce só o necessário.
- Acima de `MAX_W=640 px` ativa quebra (`AUTOWRAP_WORD_SMART`) e calcula nº de linhas.
- A faixa do texto fica **logo acima do corpo** do pet:
  `speech.position.y = pet_y - SPEECH_GAP - band` (o `HOP_HEADROOM` sobra por cima).
- Constantes: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## Quem fala
Saudação inicial (`t("hello") % nome` — usa o **nome do pet salvo ativo**
`current_pet_name`, ou "Zimmy" se for Default/aleatório); ações (`feed/pet/play/_react`);
geração/seleção de pets e acessórios; salvar/erros; reclamações de mau humor
([[Sistema - Interação e Mau Humor]], lista `mood_neg`); e as **automações/e-mails** (via
`notify()`, com espaçamento de 5s).

## Espelha no rosto
`say()` também deduz a emoção do emoji e o rosto a reflete enquanto a fala dura —
ver [[Sistema - Expressões Faciais]].
