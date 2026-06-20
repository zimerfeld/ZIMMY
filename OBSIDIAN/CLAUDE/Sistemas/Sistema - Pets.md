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

## Aleatório — `_random_cfg()` (`zimmy.gd:148`)
Sorteia, mantendo o estilo "Zimmy":
- **Cores** por matiz (`hue`) coerente: corpo, barriga, orelha (mais escura), bochecha
  (complementar), nariz.
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
