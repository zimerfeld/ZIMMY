---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, pets, zimmy-pet]
---

# 🐾 Sistema - Pets

> 🇺🇸 Read this page in English → [[🐾 Sistema - Pets (EN)]]
> 🇪🇸 Lee esta página en español → [[🐾 Sistema - Pets (ES)]]

Cada pet é um **config** (Dictionary) consumido por `_draw()`. O mesmo código gera o
Default, os aleatórios e os salvos. Esquema completo em [[🗂️ Glossário de Configs]].

## 🔰 Default — `_default_cfg()` (`zimmy.gd:128`)
A carinha original (laranja). **Sempre disponível e nunca removida.** Fixa cores,
proporções e elementos: `has_ears=true/round`, `has_cheeks=true`, sem antenas/nariz/
cílios, `mouth_style="smile"`.

## 🎲 Aleatório — `_random_cfg()`
Busca **estética equilibrada e cores alegres**, mantendo o estilo "Zimmy":
- **Bichinhos** — ~55% das gerações viram um bicho reconhecível (`critter` ∈ {cat, dog,
  bunny, bear, frog, fox, mouse, pig}). `_apply_critter(cfg, kind)` sobrescreve as chaves
  de **forma** (orelha/boca/bigode/cauda/proporções) e limpa adereços fantasia; a **cor
  continua aleatória**. Os outros ~45% seguem combinatórios livres.
- **Cores** — matiz base (`hue`); as cores de destaque (orelha/antena/nariz) vêm de um
  **esquema de harmonia** sorteado: `analogous`/`complementary`/`triadic`/`monochrome`
  (`accent_hue`). Saturação/brilho em faixas vibrantes-porém-suaves (`body_s` 0.42–0.68,
  `body_v` 0.86–0.98) → evita tons sujos/escuros. Barriga = mesmo matiz dessaturado e
  claro (contraste coeso); bochecha = rosado quente translúcido.
- **Geometria** — `body_shape` ∈ {`round`(2×), `tall`, `wide`, `pear`, `chubby`, `slim`}:
  o `_draw()` estica/achata a silhueta e, no `pear`, desenha um bojo inferior extra.
- **Proporções** em faixas (`randf_range`).
- **Formas/elementos** (probabilidades): `has_ears` 85%, `ear_shape` round/pointy/floppy,
  `has_antennae` 40%, `has_cheeks` 70%, `has_nose` 60%, `has_eyelashes` 50%,
  `mouth_style` ∈ {smile, cat, open, line, tongue, fang}.
- **Categorias extras do "esqueleto"** (≈14, sorteadas **de forma independente**, com
  `none` de peso maior p/ não sobrecarregar): `tail` (curl/puff/stub), `horn`
  (unicorn/devil/antlers + `horn_color`), `hair_tuft` (tuft/cowlick/mohawk),
  `eye_shape` (oval/tall/sleepy), `pupil_style` (big/cat/sparkle/heart), `eyebrow`
  (flat/raised/serious), `feet` (paws), `arms` (nubs), `belly_mark` (spot/heart),
  `whiskers` (short/long), `wings` (small), `freckles`, `body_pattern` (spots/stripes),
  `muzzle`. Cada uma tem um helper `_draw_*` próprio; ver [[🎨 Sistema - Render (_draw)]].

## 📦 Estado
- `current` — pet exibido agora.
- `saved_pets[nome]` — pets salvos (em memória, com `Color`).

## 🛠️ Operações
- **Salvar**: `_open_save_dialog("pet", "save")` → `_on_save_confirmed` →
  `saved_pets[nome]=current.duplicate(true)` → [[💾 Sistema - Persistência]].
- **Renomear**: se o pet exibido já está salvo, o item de menu vira "💾 Renomear Pet"
  (mesmo ícone) → `_open_save_dialog("pet", "rename")` → `_do_rename` (troca a chave,
  preserva a ordem, regrava). Ver [[💾 Fluxo - Salvar e Carregar]].
- **Escolher**: submenu "📂 Escolher pet" → `_on_pick_pet` (`Default`/salvos);
  desliga só a geração de pet. Ver [[🧭 Sistema - Menu de Contexto]].
- **Excluir**: submenu "🗑️ Excluir pet" → `_on_del_pet` → confirmação →
  `_on_delete_confirmed` (`saved_pets.erase`). O `Default` é **intocável**; após excluir,
  o Zimmy **recarrega sempre o `Default`**. Ver [[💾 Fluxo - Salvar e Carregar]].
- **Geração contínua**: ver [[🎲 Fluxo - Geração Aleatória]].

Desenho dos elementos: [[🎨 Sistema - Render (_draw)]]. Acessórios são **camada
separada**: [[🎀 Sistema - Acessórios]].
