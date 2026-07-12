---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, persistencia, dados, zimmy-pet]
---

# 💾 Sistema - Persistencia

> 🇧🇷 Lee esta página en portugués → [[💾 Sistema - Persistência]]
> 🇺🇸 Read this page in English → [[💾 Sistema - Persistência (EN)]]

Tres archivos JSON en `user://` (en Windows:
`%APPDATA%\Godot\app_userdata\Zimmy Pet\`). Esquemas en [[🗂️ Glossário de Configs (ES)]].

| Archivo | Const | Contenido |
|---|---|---|
| `pets.json` | `PETS_FILE` | `{ nombre: config_pet }` |
| `accessories.json` | `ACC_FILE` | `{ nombre: config_accesorio }` |
| `settings.json` | `SETTINGS_FILE` | `{ anchor_x, anchor_y, pet, acc, show_acc, lang, status, wa_sound, gmail_sound, feed_sound, pet_sound, play_sound }` (posición + elección activa + idioma + visualización de las barras de estado + alertas de sonido de WhatsApp/Gmail + alertas de sonido de las acciones Alimentar/Cariño/Jugar) |
| `schedules.json` | `SCHEDULES_FILE` | `{ ruta_automatizacion: true }` (programadas activadas) |
| `cred_<key>.json` | `CRED_PREFIX` | `{ user, pass }` por automatización (correo), **cifrado** (AES). **Gitignored**, nunca versionar |

## 🎨 Serialización de colores
- `_cfg_to_json(cfg)` — convierte cada `Color` en `[r,g,b,a]`; el resto pasa directo.
- `_json_to_cfg(d, base, color_keys)` — parte de `base` (¡el default!), y convierte de
  vuelta las claves en `color_keys` (`PET_COLOR_KEYS` / `ACC_COLOR_KEYS`).
  **Por eso los archivos antiguos/parciales ganan las claves nuevas** sin romperse.

## 🔧 Funciones (`zimmy.gd:410+`)
- `_save_dict_to_disk(path, store)` + wrappers `_save_pets_to_disk` /
  `_save_accessories_to_disk`. **Eliminación**: `_on_delete_confirmed` hace
  `saved_pets`/`saved_accessories``.erase(nombre)` y reescribe mediante esos mismos wrappers —
  eliminación permanente del JSON; ver [[💾 Fluxo - Salvar e Carregar (ES)]].
- `_load_pets_from_disk` / `_load_accessories_from_disk` (llamados en el
  [[🟢 Fluxo - Inicialização (ES)]]).
- `_read_json(path)` — helper tolerante (devuelve `null` si falta/da error).
- `_save_settings` / `_load_window_pos` — escribe/lee `settings.json`; ver
  [[🖱️ Fluxo - Arrastar e Posição (ES)]]. `_save_settings` (antes `_save_window_pos`) ahora
  escribe también `pet`/`acc`/`show_acc` (la elección activa).
- `_load_selection` — restaura la elección de pet/accesorio guardada en `settings.json`,
  llamada en el [[🟢 Fluxo - Inicialização (ES)]] **después** de cargar los guardados del disco y **antes**
  de montar el menú (para que los checks ✓ reflejen la opción preseleccionada). Nombres
  `pet`/`acc` vacíos (generación aleatoria) caen en el default — aleatorio no es restaurable.
- `_save_schedules` / `_load_schedules` — automatizaciones programadas activadas
  (`automation_enabled`); ver [[🧭 Sistema - Menu de Contexto (ES)]].
- `load_credentials` / `save_credentials` / `forget_credentials` — credenciales de
  automatización en `user://cred_<key>.json` (un archivo por automatización, gitignored).
  **Cifradas** con `FileAccess.open_encrypted_with_pass`; la clave viene de
  `_cred_key()` = `CRED_SALT` + `OS.get_unique_id()` (no queda en texto plano ni vale en
  otra máquina). `load_credentials` **migra** archivos antiguos en texto plano
  (recifra en la lectura). Guardadas solo tras validación; ver [[🧭 Sistema - Menu de Contexto (ES)]].

Escrituras disparadas en: guardar pet/accesorio ([[💾 Fluxo - Salvar e Carregar (ES)]]), soltar
el pet tras arrastrar, y **elegir un pet/accesorio o alternar 👓 Mostrar accesorios**
(cada elección llama a `_save_settings`).
