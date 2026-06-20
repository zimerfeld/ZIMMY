---
tags: [fluxo, persistencia, zimmy-pet]
atualizado: 2026-06-20
---

# 💾 Fluxo - Salvar e Carregar

Pets e acessórios são salvos/carregados **independentemente**. Ver
[[Sistema - Persistência]] e [[Sistema - Menu de Contexto]].

## Salvar
1. Menu "💾 Salvar Pet..." ou "🎀 Salvar Acessório..." → `_open_save_dialog(mode)`.
2. `_open_save_dialog` chama `_stop_random_all()` (congela a tela), ajusta título/
   placeholder conforme `save_mode`, centraliza e abre o diálogo.
3. Confirmar → `_on_save_confirmed`:
   - valida nome (rejeita vazio, `Default`, `Selecione...`, `Nenhum`);
   - `pet`: `saved_pets[nm] = current.duplicate(true)` → `_save_pets_to_disk` →
     `_rebuild_pets_menu`;
   - `acc`: idem para `saved_accessories` → `_save_accessories_to_disk` →
     `_rebuild_acc_menu`.

## Carregar
- **Pet**: submenu "📂 Escolher pet" → `_on_pick_pet(id)`. `Default` (1) volta ao
  config padrão; salvos (100+) carregam `saved_pets`. Desliga só a geração de pet.
- **Acessório**: submenu "🧳 Escolher acessório" → `_on_pick_acc(id)`. `Nenhum` (1)
  limpa; salvos carregam `saved_accessories`. Desliga a geração de acessório e **liga
  a exibição**.

> `Selecione...` (id 0) em ambos é só rótulo desabilitado.
Carga inicial do disco: [[Fluxo - Inicialização]].
