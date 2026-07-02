---
tags: [fluxo, geracao, zimmy-pet]
atualizado: 2026-06-21
---

# 🎲 Fluxo - Geração Aleatória

Pet e acessórios têm checkboxes **independentes**, mas compartilham um **único
temporizador** (`random_timer`): com os dois ligados, trocam **juntos** no mesmo tique.

## Ligar/desligar
- `_set_random_pet(on)` — marca `MI_RANDOM`, zera o `random_timer` (compartilhado); se
  ligando, chama `_generate_pet()`.
- `_set_random_acc(on)` — marca `MI_RANDOM_ACC`, zera o `random_timer`; se ligando,
  **liga a exibição** (`_set_show_accessories(true)`) e chama `_generate_acc()`.

## Geração + nome sugerido
- `_generate_pet()` — `current = _random_cfg()`, `current_pet_name = ""`, sorteia um
  **nome sugestivo** (`suggested_pet_name = _suggest_name("pet")`) e dá as
  **boas-vindas** com ele (`say(t("welcome_pet") % nome)`).
- `_generate_acc()` — `current_acc = _random_acc()`, `current_acc_name = ""`, sorteia
  `suggested_acc_name` (`_suggest_name("acc")`) e **parabeniza** (`say(t("congrats_acc") % nome)`).
- `_suggest_name(kind)` monta um nome **combinatório**: substantivo + adjetivo dos bancos
  do idioma (`STRING_LISTS["<kind>_nouns"/"<kind>_adjs"]`, kind = `pet`/`acc`). ~900
  combinações por categoria/idioma (quase nunca repete). Ordem: pt = "Substantivo
  Adjetivo"; en = "Adjective Noun". Adjetivos pt são invariáveis em gênero (sem erro de
  concordância).
- O nome sugerido **pré-preenche** o diálogo de Salvar/Renomear (ver
  [[Fluxo - Salvar e Carregar]]); escolher um item específico limpa a sugestão.

## Geração contínua (no [[Fluxo - Loop (_process)]])
Um único `random_timer` avança quando **pet OU acessório** está ligado; a cada
`RANDOM_PERIOD = 10s` chama `_generate_pet()` e/ou `_generate_acc()` (os que estiverem
ligados, no mesmo tique).

## Interações que desligam
- Escolher um **pet** no menu → `_set_random_pet(false)` (só pet).
- Escolher um **acessório** → `_set_random_acc(false)` (só acessório).
- **Salvar pet** → `_set_random_pet(false)` ao abrir (congela) e novamente ao
  **confirmar** (desmarca "🐶 Gerar pets"); não mexe na geração de acessórios.
- **Salvar acessório** → `_set_random_acc(false)` ao abrir e ao confirmar (desmarca
  "🎲 Gerar acessórios"); não mexe na geração de pets. Ver [[Fluxo - Salvar e Carregar]].
- **Excluir** pet/acessório → também desliga o aleatório correspondente
  (recarrega o Default).

Conteúdo sorteado: [[Sistema - Pets]] / [[Sistema - Acessórios]]. O pet aleatório
sorteia ~14 categorias geométricas **independentes** além da silhueta; e em ~55% das
vezes vira um **bichinho** reconhecível (`_apply_critter`: cat/dog/bunny/bear/frog/fox/
mouse/pig) — ver [[Sistema - Pets]].
