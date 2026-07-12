---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, geracao, zimmy-pet]
---

# 🎲 Flujo - Generación Aleatoria

> 🇧🇷 Lee esta página en portugués → [[🎲 Fluxo - Geração Aleatória]]
> 🇺🇸 Read this page in English → [[🎲 Fluxo - Geração Aleatória (EN)]]

El pet y los accesorios tienen casillas **independientes**, pero comparten un **único
temporizador** (`random_timer`): con los dos activados, cambian **juntos** en el mismo tic.

## 🔀 Activar/desactivar
- `_set_random_pet(on)` — marca `MI_RANDOM`, pone a cero el `random_timer` (compartido); si
  se activa, llama a `_generate_pet()`.
- `_set_random_acc(on)` — marca `MI_RANDOM_ACC`, pone a cero el `random_timer`; si se activa,
  **activa la visualización** (`_set_show_accessories(true)`) y llama a `_generate_acc()`.

## 🎲 Generación + nombre sugerido
- `_generate_pet()` — `current = _random_cfg()`, `current_pet_name = ""`, sortea un
  **nombre sugerente** (`suggested_pet_name = _suggest_name("pet")`) y da la
  **bienvenida** con él (`say(t("welcome_pet") % nombre)`).
- `_generate_acc()` — `current_acc = _random_acc()`, `current_acc_name = ""`, sortea
  `suggested_acc_name` (`_suggest_name("acc")`) y **felicita** (`say(t("congrats_acc") % nombre)`).
- `_suggest_name(kind)` construye un nombre **combinatorio**: sustantivo + adjetivo de los bancos
  del idioma (`STRING_LISTS["<kind>_nouns"/"<kind>_adjs"]`, kind = `pet`/`acc`). ~900
  combinaciones por categoría/idioma (casi nunca se repite). Orden: pt = "Sustantivo
  Adjetivo"; en = "Adjective Noun". Los adjetivos en pt son invariables en género (sin errores de
  concordancia).
- El nombre sugerido **rellena automáticamente** el diálogo de Guardar/Renombrar (ver
  [[💾 Fluxo - Salvar e Carregar (ES)]]); elegir un elemento específico borra la sugerencia.

## 🔁 Generación continua (en el [[🔁 Fluxo - Loop (_process) (ES)]])
Un único `random_timer` avanza cuando **el pet O el accesorio** está activado; cada
`RANDOM_PERIOD = 30s` llama a `_generate_pet()` y/o `_generate_acc()` (los que estén
activados, en el mismo tic).

## 🚫 Interacciones que lo desactivan
- Elegir un **pet** en el menú → `_set_random_pet(false)` (solo pet).
- Elegir un **accesorio** → `_set_random_acc(false)` (solo accesorio).
- **Guardar pet** → `_set_random_pet(false)` al abrir (congela) y de nuevo al
  **confirmar** (desmarca "🐶 Gerar pets"); no afecta a la generación de accesorios.
- **Guardar accesorio** → `_set_random_acc(false)` al abrir y al confirmar (desmarca
  "🎲 Gerar acessórios"); no afecta a la generación de pets. Ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- **Eliminar** pet/accesorio → también desactiva el modo aleatorio correspondiente
  (recarga el Default).

Contenido sorteado: [[🐾 Sistema - Pets (ES)]] / [[🎀 Sistema - Acessórios (ES)]]. El pet aleatorio
sortea ~14 categorías geométricas **independientes** además de la silueta; y en ~55% de los
casos se convierte en un **bichito** reconocible (`_apply_critter`: cat/dog/bunny/bear/frog/fox/
mouse/pig) — ver [[🐾 Sistema - Pets (ES)]].
