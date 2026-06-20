---
tags: [sistema, persistencia, dados, zimmy-pet]
atualizado: 2026-06-20
---

# 💾 Sistema - Persistência

Três arquivos JSON em `user://` (no Windows:
`%APPDATA%\Godot\app_userdata\Zimmy Pet\`). Esquemas em [[Glossário de Configs]].

| Arquivo | Const | Conteúdo |
|---|---|---|
| `pets.json` | `PETS_FILE` | `{ nome: config_pet }` |
| `accessories.json` | `ACC_FILE` | `{ nome: config_acessório }` |
| `settings.json` | `SETTINGS_FILE` | `{ anchor_x, anchor_y }` (última posição) |
| `schedules.json` | `SCHEDULES_FILE` | `{ caminho_automação: true }` (agendadas ligadas) |
| `cred_<key>.json` | `CRED_PREFIX` | `{ user, pass }` por automação (e-mail). **Gitignored**, nunca versionar |

## Serialização de cores
- `_cfg_to_json(cfg)` — converte cada `Color` em `[r,g,b,a]`; o resto passa direto.
- `_json_to_cfg(d, base, color_keys)` — parte de `base` (o default!), e converte de
  volta as chaves em `color_keys` (`PET_COLOR_KEYS` / `ACC_COLOR_KEYS`).
  **Por isso arquivos antigos/parciais ganham as chaves novas** sem quebrar.

## Funções (`zimmy.gd:410+`)
- `_save_dict_to_disk(path, store)` + wrappers `_save_pets_to_disk` /
  `_save_accessories_to_disk`.
- `_load_pets_from_disk` / `_load_accessories_from_disk` (chamados no
  [[Fluxo - Inicialização]]).
- `_read_json(path)` — helper tolerante (retorna `null` se faltar/der erro).
- `_save_window_pos` / `_load_window_pos` — ver [[Fluxo - Arrastar e Posição]].
- `_save_schedules` / `_load_schedules` — automações agendadas ligadas
  (`automation_enabled`); ver [[Sistema - Menu de Contexto]].
- `load_credentials` / `save_credentials` / `forget_credentials` — credenciais de
  automação em `user://cred_<key>.json` (um arquivo por automação, gitignored). Gravadas
  só após validação; ver [[Sistema - Menu de Contexto]].

Gravações disparadas em: salvar pet/acessório ([[Fluxo - Salvar e Carregar]]) e soltar
o pet após arrastar.
