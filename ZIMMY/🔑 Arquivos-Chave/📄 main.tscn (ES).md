---
tipo: arquivo-chave
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [arquivo, cena, zimmy-pet]
caminho: main.tscn
---

# 📄 main.tscn

> 🇧🇷 Lee esta página en portugués → [[📄 main.tscn]]
> 🇺🇸 Read this page in English → [[📄 main.tscn (EN)]]

Escena raíz, mínima. Un único nodo `Node2D` llamado **Zimmy** con el script
[[📄 zimmy.gd (ES)]] adjunto.

```
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://zimmy.gd" id="1"]
[node name="Zimmy" type="Node2D"]
script = ExtResource("1")
```

Es la `main_scene` definida en [[📄 project.godot (ES)]]. Toda la lógica y el dibujo están en el
script — la escena no tiene otros nodos (el `Label` del diálogo se crea en runtime en el
[[🟢 Fluxo - Inicialização (ES)]]).
