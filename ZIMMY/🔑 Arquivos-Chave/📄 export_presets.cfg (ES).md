---
tipo: arquivo-chave
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [arquivo, build, zimmy-pet]
caminho: export_presets.cfg
---

# 📄 export_presets.cfg

> 🇧🇷 Lee esta página en portugués → [[📄 export_presets.cfg]]
> 🇺🇸 Read this page in English → [[📄 export_presets.cfg (EN)]]

Único preset: **`Windows Desktop`** (`preset.0`).

| Campo | Valor |
|---|---|
| `platform` | Windows Desktop |
| `export_path` | `build/ZimmyPet.exe` |
| `export_filter` | `all_resources` |
| `exclude_filter` | `tools/*, *.tpz, templates.tpz` |
| `binary_format/embed_pck` | `true` (binario standalone) |
| `binary_format/architecture` | `x86_64` |
| `application/icon` | `res://zimmy.ico` |
| `application/product_name` | `Zimmy Pet` |
| `application/company_name` | `Zimerfeld` |
| `application/file_description` | `Zimmy — desktop pet overlay` |

Como el `.pck` va embebido, **los cambios en el código exigen re-exportar** — ver
[[🚀 Export e Publicação (Prod) (ES)]]. La carpeta `tools/` (generador de icono, [[📄 tools - make_icon.py (ES)]]) queda
excluida del paquete.
