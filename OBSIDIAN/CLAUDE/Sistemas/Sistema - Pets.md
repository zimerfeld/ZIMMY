---
tags: [sistema, pets, zimmy-pet]
atualizado: 2026-06-20
---

# 🐾 Sistema - Pets

Cada pet é um **config** (Dictionary) consumido por `_draw()`. O mesmo código gera o
Default, os aleatórios e os salvos. Esquema completo em [[Glossário de Configs]].

## Default — `_default_cfg()` (`zimmy.gd:128`)
A carinha original (laranja). **Sempre disponível e nunca removida.** Fixa cores,
proporções e elementos: `has_ears=true/round`, `has_cheeks=true`, sem antenas/nariz/
cílios, `mouth_style="smile"`.

## Aleatório — `_random_cfg()`
Busca **estética equilibrada e cores alegres**, mantendo o estilo "Zimmy":
- **Cores** — matiz base (`hue`); as cores de destaque (orelha/antena/nariz) vêm de um
  **esquema de harmonia** sorteado: `analogous`/`complementary`/`triadic`/`monochrome`
  (`accent_hue`). Saturação/brilho em faixas vibrantes-porém-suaves (`body_s` 0.42–0.68,
  `body_v` 0.86–0.98) → evita tons sujos/escuros. Barriga = mesmo matiz dessaturado e
  claro (contraste coeso); bochecha = rosado quente translúcido.
- **Geometria** — `body_shape` ∈ {`round`(2×), `tall`, `wide`, `pear`}: o `_draw()`
  estica/achata a silhueta e, no `pear`, desenha um bojo inferior extra (corpo em gota).
- **Proporções** em faixas (`randf_range`).
- **Formas/elementos** (probabilidades): `has_ears` 85%, `ear_shape` round/pointy,
  `has_antennae` 40%, `has_cheeks` 70%, `has_nose` 60%, `has_eyelashes` 50%,
  `mouth_style` ∈ {smile, cat, open, line}.

## Estado
- `current` — pet exibido agora.
- `saved_pets[nome]` — pets salvos (em memória, com `Color`).

## Operações
- **Salvar**: `_open_save_dialog("pet")` → `_on_save_confirmed` →
  `saved_pets[nome]=current.duplicate(true)` → [[Sistema - Persistência]].
- **Escolher**: submenu "📂 Escolher pet" → `_on_pick_pet` (`Default`/salvos);
  desliga só a geração de pet. Ver [[Sistema - Menu de Contexto]].
- **Geração contínua**: ver [[Fluxo - Geração Aleatória]].

Desenho dos elementos: [[Sistema - Render (_draw)]]. Acessórios são **camada
separada**: [[Sistema - Acessórios]].
