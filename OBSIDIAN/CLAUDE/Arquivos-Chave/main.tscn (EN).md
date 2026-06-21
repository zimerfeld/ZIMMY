---
tags: [arquivo, cena, zimmy-pet]
caminho: main.tscn
atualizado: 2026-06-20
lang: en
---

# 📄 main.tscn

Root scene, minimal. A single `Node2D` node named **Zimmy** with the script
[[zimmy.gd (EN)]] attached.

```
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://zimmy.gd" id="1"]
[node name="Zimmy" type="Node2D"]
script = ExtResource("1")
```

It is the `main_scene` defined in [[project.godot (EN)]]. All the logic and drawing live in the
script — the scene has no other nodes (the speech `Label` is created at runtime in the
[[Fluxo - Inicialização (EN)]]).
