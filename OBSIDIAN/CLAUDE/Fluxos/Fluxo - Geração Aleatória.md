---
tags: [fluxo, geracao, zimmy-pet]
atualizado: 2026-06-21
---

# 🎲 Fluxo - Geração Aleatória

Pet e acessórios têm geração **independente**, com checkboxes e timers separados.

## Ligar/desligar
- `_set_random_pet(on)` — marca `MI_RANDOM`, zera `random_pet_timer`; se ligando,
  gera um pet já (`current = _random_cfg()`) e fala.
- `_set_random_acc(on)` — marca `MI_RANDOM_ACC`, zera `random_acc_timer`; se ligando,
  gera acessório (`current_acc = _random_acc()`) **e liga a exibição**
  (`_set_show_accessories(true)`).

## Geração contínua (no [[Fluxo - Loop (_process)]])
A cada `RANDOM_PERIOD = 9s`, se ligado, troca `current`/`current_acc` e fala
("novo pet! 🎲" / "novos acessórios! 🎲").

## Interações que desligam
- Escolher um **pet** no menu → `_set_random_pet(false)` (só pet).
- Escolher um **acessório** → `_set_random_acc(false)` (só acessório).
- **Salvar pet** → `_set_random_pet(false)` ao abrir (congela) e novamente ao
  **confirmar** (desmarca "🎲 Gerar pets"); não mexe na geração de acessórios.
- **Salvar acessório** → `_set_random_acc(false)` ao abrir e ao confirmar (desmarca
  "🎲 Gerar acessórios"); não mexe na geração de pets. Ver [[Fluxo - Salvar e Carregar]].
- **Excluir** pet/acessório → também desliga o aleatório correspondente
  (recarrega o Default).

Conteúdo sorteado: [[Sistema - Pets]] / [[Sistema - Acessórios]]. O pet aleatório
sorteia ~12 categorias geométricas **independentes** além da silhueta (rabo, chifre,
topete, olho, pupila, sobrancelha, patas, bracinhos, marca, bigodes, asas, sardas).
