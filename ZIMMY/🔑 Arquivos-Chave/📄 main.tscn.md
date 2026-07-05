---
tipo: arquivo-chave
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [arquivo, cena, zimmy-pet]
caminho: main.tscn
---

# 📄 main.tscn

Cena raiz, mínima. Um único nó `Node2D` chamado **Zimmy** com o script
[[📄 zimmy.gd]] anexado.

```
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://zimmy.gd" id="1"]
[node name="Zimmy" type="Node2D"]
script = ExtResource("1")
```

É a `main_scene` definida em [[📄 project.godot]]. Toda a lógica e o desenho ficam no
script — a cena não tem outros nós (o `Label` da fala é criado em runtime no
[[🟢 Fluxo - Inicialização]]).
