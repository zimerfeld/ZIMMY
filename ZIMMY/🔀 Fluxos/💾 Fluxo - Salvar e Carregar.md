---
tipo: fluxo
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [fluxo, persistencia, zimmy-pet]
---

# 💾 Fluxo - Salvar e Carregar

> 🇪🇸 Lee esta página en español → [[💾 Fluxo - Salvar e Carregar (ES)]]

Pets e acessórios são salvos/carregados **independentemente**. Ver
[[💾 Sistema - Persistência]] e [[🧭 Sistema - Menu de Contexto]].

## 💾 Salvar
1. Menu "💾 Salvar Pet..." ou "🎀 Salvar Acessório..." → `_open_save_dialog(mode, "save")`.
2. `_open_save_dialog` **congela só a geração do tipo sendo salvo** (`_set_random_pet`
   ou `_set_random_acc` `(false)`), ajusta título/placeholder conforme `save_mode`,
   **pré-preenche** a caixa com o nome sugerido do item gerado
   (`suggested_pet_name`/`suggested_acc_name`, selecionado p/ trocar fácil), centraliza e
   abre o diálogo. Ver [[🎲 Fluxo - Geração Aleatória]].
3. Confirmar → `_on_save_confirmed`:
   - valida nome (rejeita vazio, `Default`, `Selecione...`, `Nenhum`);
   - `pet`: **`_set_random_pet(false)`** (desmarca "🐶 Gerar pets"),
     `saved_pets[nm] = current.duplicate(true)`, `current_pet_name = nm` (vira o ativo →
     item passa a "Renomear") → `_save_pets_to_disk` → `_rebuild_pets_menu` →
     `_save_settings`;
   - `acc`: **`_set_random_acc(false)`** (desmarca "🎲 Gerar acessórios"), idem para
     `saved_accessories` → `_save_accessories_to_disk` → `_rebuild_acc_menu` →
     `_save_settings`.

## ✏️ Renomear (item já salvo)
Quando o pet/acessório exibido já está salvo, o item de menu vira **Renomear** (mesmo
ícone), via `_refresh_save_labels()`. `_open_save_dialog(mode, "rename")` pré-preenche o
nome atual; confirmar → `_on_save_confirmed` → `_do_rename(novo)`:
- valida; ignora se o nome não mudou; **rejeita nome já existente**;
- `_rename_key()` troca a chave **preservando a ordem** do dropdown; atualiza
  `current_*_name`, regrava o JSON + `settings.json` e reconstrói o menu.

## 📂 Carregar
- **Pet**: submenu "📂 Escolher pet" → `_on_pick_pet(id)`. `Default` (1) volta ao
  config padrão; salvos (100+) carregam `saved_pets`. Desliga só a geração de pet.
- **Acessório**: submenu "🧳 Escolher acessório" → `_on_pick_acc(id)`. `Nenhum` (1)
  limpa; salvos carregam `saved_accessories`. Desliga a geração de acessório e **liga
  a exibição**.

> `Selecione...` (id 0) em ambos é só rótulo desabilitado.
Carga inicial do disco: [[🟢 Fluxo - Inicialização]].

## 🗑️ Excluir (permanente)
- Submenus **🗑️ Excluir pet** (`pets_del_menu`) / **🗑️ Excluir acessório**
  (`acc_del_menu`) listam **só os salvos** — `Default`/`Nenhum`/`Selecione...` são
  **intocáveis** e nunca aparecem.
- `_on_del_pet`/`_on_del_acc` → `_open_delete_dialog(mode, nome)` (confirmação).
- `_on_delete_confirmed`: `erase(nome)` em `saved_pets`/`saved_accessories`, regrava o
  JSON (`_save_*_to_disk`), reconstrói os menus e **sempre recarrega o Default**
  (`_default_cfg`/`_default_acc`, `current_*_name` = `Default`/`Nenhum`), desligando o
  aleatório (`_set_random_*(false)`) e persistindo via `_save_settings`.

## 🧠 Escolha lembrada entre sessões
- `_on_pick_pet` e `_on_pick_acc` chamam `_save_settings()` ao final, gravando a
  escolha (`pet`/`acc`/`show_acc`) em `settings.json` ([[💾 Sistema - Persistência]]).
- Na próxima abertura, `_load_selection()` restaura o pet/acessório escolhido e ele
  reaparece **pré-selecionado** (✓) no dropdown. Ver [[🟢 Fluxo - Inicialização]].
