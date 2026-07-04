---
tipo: arquivo-chave
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [arquivo, build, zimmy-pet]
caminho: export_presets.cfg
---

# 📄 export_presets.cfg

Single preset: **`Windows Desktop`** (`preset.0`).

| Field | Value |
|---|---|
| `platform` | Windows Desktop |
| `export_path` | `build/ZimmyPet.exe` |
| `export_filter` | `all_resources` |
| `exclude_filter` | `tools/*, *.tpz, templates.tpz` |
| `binary_format/embed_pck` | `true` (standalone binary) |
| `binary_format/architecture` | `x86_64` |
| `application/icon` | `res://zimmy.ico` |
| `application/product_name` | `Zimmy Pet` |
| `application/company_name` | `Zimerfeld` |
| `application/file_description` | `Zimmy — desktop pet overlay` |

Because the `.pck` is embedded, **code changes require a re-export** — see
[[🚀 Export e Publicação (Prod) (EN)]]. The `tools/` folder (icon generator, [[📄 tools - make_icon.py (EN)]]) is
excluded from the package.
