---
tags: [fluxo, geracao, zimmy-pet]
atualizado: 2026-06-20
---

# 🎲 Fluxo - Geração Aleatória

Pet e acessórios têm geração **independente**, com checkboxes e timers separados.

## Ligar/desligar
- `_set_random_pet(on)` — marca `MI_RANDOM`, zera `random_pet_timer`; se ligando,
  gera um pet já (`current = _random_cfg()`) e fala.
- `_set_random_acc(on)` — marca `MI_RANDOM_ACC`, zera `random_acc_timer`; se ligando,
  gera acessório (`current_acc = _random_acc()`) **e liga a exibição**
  (`_set_show_accessories(true)`).
- `_stop_random_all()` — desliga os dois (usado ao abrir Salvar).

## Geração contínua (no [[Fluxo - Loop (_process)]])
A cada `RANDOM_PERIOD = 9s`, se ligado, troca `current`/`current_acc` e fala
("novo pet! 🎲" / "novos acessórios! 🎲").

## Interações que desligam
- Escolher um **pet** no menu → `_set_random_pet(false)` (só pet).
- Escolher um **acessório** → `_set_random_acc(false)` (só acessório).
- Abrir **Salvar** (pet ou acessório) → `_stop_random_all()` (ambos), para gravar
  exatamente o que está na tela. Ver [[Fluxo - Salvar e Carregar]].

Conteúdo sorteado: [[Sistema - Pets]] / [[Sistema - Acessórios]].
