---
tags: [arquivo, build, zimmy-pet]
caminho: export_presets.cfg
atualizado: 2026-06-20
---

# 📄 export_presets.cfg

Único preset: **`Windows Desktop`** (`preset.0`).

| Campo | Valor |
|---|---|
| `platform` | Windows Desktop |
| `export_path` | `build/ZimmyPet.exe` |
| `export_filter` | `all_resources` |
| `exclude_filter` | `tools/*, *.tpz, templates.tpz` |
| `binary_format/embed_pck` | `true` (binário standalone) |
| `binary_format/architecture` | `x86_64` |
| `application/icon` | `res://zimmy.ico` |
| `application/product_name` | `Zimmy Pet` |
| `application/company_name` | `Zimerfeld` |
| `application/file_description` | `Zimmy — desktop pet overlay` |

Como o `.pck` é embutido, **mudanças no código exigem re-export** — ver
[[Build e Export]]. O `tools/` (gerador de ícone, [[tools - make_icon.py]]) é
excluído do pacote.
