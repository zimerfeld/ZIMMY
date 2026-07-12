---
tipo: fluxo
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [fluxo, persistencia, zimmy-pet]
---

# 💾 Flujo - Guardar y Cargar

> 🇧🇷 Lee esta página en portugués → [[💾 Fluxo - Salvar e Carregar]]
> 🇺🇸 Read this page in English → [[💾 Fluxo - Salvar e Carregar (EN)]]

Los pets y los accesorios se guardan/cargan de forma **independiente**. Ver
[[💾 Sistema - Persistência (ES)]] y [[🧭 Sistema - Menu de Contexto (ES)]].

## 💾 Guardar
1. Menú "💾 Salvar Pet..." o "🎀 Salvar Acessório..." → `_open_save_dialog(mode, "save")`.
2. `_open_save_dialog` **congela solo la generación del tipo que se está guardando** (`_set_random_pet`
   o `_set_random_acc` `(false)`), ajusta el título/placeholder según `save_mode`,
   **rellena automáticamente** la caja con el nombre sugerido del elemento generado
   (`suggested_pet_name`/`suggested_acc_name`, seleccionado para cambiarlo fácilmente), lo centra y
   abre el diálogo. Ver [[🎲 Fluxo - Geração Aleatória (ES)]].
3. Confirmar → `_on_save_confirmed`:
   - valida el nombre (rechaza vacío, `Default`, `Selecione...`, `Nenhum`);
   - `pet`: **`_set_random_pet(false)`** (desmarca "🐶 Gerar pets"),
     `saved_pets[nm] = current.duplicate(true)`, `current_pet_name = nm` (pasa a ser el activo →
     el elemento cambia a "Renomear") → `_save_pets_to_disk` → `_rebuild_pets_menu` →
     `_save_settings`;
   - `acc`: **`_set_random_acc(false)`** (desmarca "🎲 Gerar acessórios"), ídem para
     `saved_accessories` → `_save_accessories_to_disk` → `_rebuild_acc_menu` →
     `_save_settings`.

## ✏️ Renombrar (elemento ya guardado)
Cuando el pet/accesorio mostrado ya está guardado, el elemento de menú cambia a **Renomear** (mismo
icono), mediante `_refresh_save_labels()`. `_open_save_dialog(mode, "rename")` rellena el
nombre actual; confirmar → `_on_save_confirmed` → `_do_rename(nuevo)`:
- valida; ignora si el nombre no ha cambiado; **rechaza un nombre ya existente**;
- `_rename_key()` cambia la clave **preservando el orden** del desplegable; actualiza
  `current_*_name`, reescribe el JSON + `settings.json` y reconstruye el menú.

## 📂 Cargar
- **Pet**: submenú "📂 Escolher pet" → `_on_pick_pet(id)`. `Default` (1) vuelve a la
  configuración por defecto; los guardados (100+) cargan `saved_pets`. Desactiva solo la generación de pets.
- **Accesorio**: submenú "🧳 Escolher acessório" → `_on_pick_acc(id)`. `Nenhum` (1)
  limpia; los guardados cargan `saved_accessories`. Desactiva la generación de accesorios y **activa
  la visualización**.

> `Selecione...` (id 0) en ambos es solo una etiqueta deshabilitada.
Carga inicial desde el disco: [[🟢 Fluxo - Inicialização (ES)]].

## 🗑️ Eliminar (permanente)
- Los submenús **🗑️ Excluir pet** (`pets_del_menu`) / **🗑️ Excluir acessório**
  (`acc_del_menu`) listan **solo los guardados** — `Default`/`Nenhum`/`Selecione...` son
  **intocables** y nunca aparecen.
- `_on_del_pet`/`_on_del_acc` → `_open_delete_dialog(mode, nombre)` (confirmación).
- `_on_delete_confirmed`: `erase(nombre)` en `saved_pets`/`saved_accessories`, reescribe el
  JSON (`_save_*_to_disk`), reconstruye los menús y **siempre recarga el Default**
  (`_default_cfg`/`_default_acc`, `current_*_name` = `Default`/`Nenhum`), desactivando el
  aleatorio (`_set_random_*(false)`) y persistiendo mediante `_save_settings`.

## 🧠 Elección recordada entre sesiones
- `_on_pick_pet` y `_on_pick_acc` llaman a `_save_settings()` al final, guardando la
  elección (`pet`/`acc`/`show_acc`) en `settings.json` ([[💾 Sistema - Persistência (ES)]]).
- En la siguiente apertura, `_load_selection()` restaura el pet/accesorio elegido y este
  reaparece **preseleccionado** (✓) en el desplegable. Ver [[🟢 Fluxo - Inicialização (ES)]].
