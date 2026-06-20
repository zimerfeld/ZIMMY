---
tags: [sistema, fala, ui, zimmy-pet]
atualizado: 2026-06-20
---

# 💬 Sistema - Balão de Fala

Um `Label` (criado no [[Fluxo - Inicialização]]) com contorno, usando a **fonte
padrão do Godot** (renderiza acentos e emojis coloridos no renderer Compatibility —
um `SystemFont` faria o texto sumir).

## API
- `say(t)` (`zimmy.gd:904`) — define o texto, agenda limpeza (`speech_clear=2.5s`) e
  chama `_relayout()`.
- No [[Fluxo - Loop (_process)]], ao expirar `speech_clear` o texto é limpo e a janela
  encolhe.

## Dimensionamento — em `_relayout()` ([[Sistema - Janela Overlay]])
- Mede o texto com a fonte real; largura cresce só o necessário.
- Acima de `MAX_W=640 px` ativa quebra (`AUTOWRAP_WORD_SMART`) e calcula nº de linhas.
- A faixa do texto fica **logo acima do corpo** do pet:
  `speech.position.y = pet_y - SPEECH_GAP - band` (o `HOP_HEADROOM` sobra por cima).
- Constantes: `SPEECH_PAD_X=18`, `SPEECH_PAD_Y=7`, `SPEECH_GAP=4`.

## Quem fala
Saudação inicial; ações (`feed/pet/play/_react`); geração/seleção de pets e
acessórios; salvar/erros; e as reclamações de mau humor
([[Sistema - Interação e Mau Humor]], lista `MOOD_NEG`).

## Espelha no rosto
`say()` também deduz a emoção do emoji e o rosto a reflete enquanto a fala dura —
ver [[Sistema - Expressões Faciais]].
