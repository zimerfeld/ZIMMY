---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, persistencia, dados, zimmy-pet]
---

# 💾 Sistema - Persistência

> 🇪🇸 Lee esta página en español → [[💾 Sistema - Persistência (ES)]]

Três arquivos JSON em `user://` (no Windows:
`%APPDATA%\Godot\app_userdata\Zimmy Pet\`). Esquemas em [[🗂️ Glossário de Configs]].

| Arquivo | Const | Conteúdo |
|---|---|---|
| `pets.json` | `PETS_FILE` | `{ nome: config_pet }` |
| `accessories.json` | `ACC_FILE` | `{ nome: config_acessório }` |
| `settings.json` | `SETTINGS_FILE` | `{ anchor_x, anchor_y, pet, acc, show_acc, lang, status, wa_sound, gmail_sound, feed_sound, pet_sound, play_sound }` (posição + escolha ativa + idioma + exibição das barras de status + alertas de som de WhatsApp/Gmail + alertas de som das ações Alimentar/Carinho/Brincar) |
| `schedules.json` | `SCHEDULES_FILE` | `{ caminho_automação: true }` (agendadas ligadas) |
| `cred_<key>.json` | `CRED_PREFIX` | `{ user, pass }` por automação (e-mail), **criptografado** (AES). **Gitignored**, nunca versionar |

## 🎨 Serialização de cores
- `_cfg_to_json(cfg)` — converte cada `Color` em `[r,g,b,a]`; o resto passa direto.
- `_json_to_cfg(d, base, color_keys)` — parte de `base` (o default!), e converte de
  volta as chaves em `color_keys` (`PET_COLOR_KEYS` / `ACC_COLOR_KEYS`).
  **Por isso arquivos antigos/parciais ganham as chaves novas** sem quebrar.

## 🔧 Funções (`zimmy.gd:410+`)
- `_save_dict_to_disk(path, store)` + wrappers `_save_pets_to_disk` /
  `_save_accessories_to_disk`. **Exclusão**: `_on_delete_confirmed` faz
  `saved_pets`/`saved_accessories``.erase(nome)` e regrava via esses mesmos wrappers —
  remoção permanente do JSON; ver [[💾 Fluxo - Salvar e Carregar]].
- `_load_pets_from_disk` / `_load_accessories_from_disk` (chamados no
  [[🟢 Fluxo - Inicialização]]).
- `_read_json(path)` — helper tolerante (retorna `null` se faltar/der erro).
- `_save_settings` / `_load_window_pos` — grava/lê `settings.json`; ver
  [[🖱️ Fluxo - Arrastar e Posição]]. `_save_settings` (antigo `_save_window_pos`) agora
  grava também `pet`/`acc`/`show_acc` (a escolha ativa).
- `_load_selection` — restaura a escolha de pet/acessório salva em `settings.json`,
  chamada no [[🟢 Fluxo - Inicialização]] **após** carregar os salvos do disco e **antes**
  de montar o menu (para os checks ✓ refletirem a opção pré-selecionada). Nomes
  `pet`/`acc` vazios (geração aleatória) caem no default — aleatório não é restaurável.
- `_save_schedules` / `_load_schedules` — automações agendadas ligadas
  (`automation_enabled`); ver [[🧭 Sistema - Menu de Contexto]].
- `load_credentials` / `save_credentials` / `forget_credentials` — credenciais de
  automação em `user://cred_<key>.json` (um arquivo por automação, gitignored).
  **Criptografadas** com `FileAccess.open_encrypted_with_pass`; a chave vem de
  `_cred_key()` = `CRED_SALT` + `OS.get_unique_id()` (não fica em texto puro nem vale em
  outra máquina). `load_credentials` **migra** arquivos antigos em texto puro
  (recriptografa na leitura). Gravadas só após validação; ver [[🧭 Sistema - Menu de Contexto]].

Gravações disparadas em: salvar pet/acessório ([[💾 Fluxo - Salvar e Carregar]]), soltar
o pet após arrastar, e **escolher um pet/acessório ou alternar 👓 Mostrar acessórios**
(cada escolha chama `_save_settings`).
