---
tipo: procedimento
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [procedimento, dev, editor, godot, zimmy-pet]
---

# 💻 Rodar no Editor (Dev)

> 🇺🇸 Read this page in English → [[💻 Rodar no Editor (Dev) (EN)]]
> 🇪🇸 Lee esta página en español → [[💻 Rodar no Editor (Dev) (ES)]]

> **Objetivo:** abrir e rodar o Zimmy Pet no **editor Godot** durante o desenvolvimento
> (loop rápido de código → rodar → ver), sem passar pelo export de produção.
> Engine: **Godot 4.6.2 stable** em `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (a "exe" é,
> na verdade, uma pasta com `Godot_v4.6.2-stable_win64.exe` e o `_console.exe`).
> Projeto: `C:\GODOT\ZIMMY` · cena inicial `res://main.tscn` ([[📄 main.tscn]]).

## ⚡ TL;DR — o comando único
Abrir o projeto no editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --editor --path "C:\GODOT\ZIMMY"
```
Com o editor aberto, rodar a cena principal com **F5** (ou o botão ▶). Para rodar direto,
sem abrir o editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --path "C:\GODOT\ZIMMY"
```

## ⚙️ O que o processo faz (em ordem)
1. **Fecha instâncias** — encerrar qualquer `ZimmyPet.exe` (build de prod) em execução e
   qualquer editor Godot já aberto antes de mexer no código (regra global do projeto GODOT).
2. **Abre o projeto** — o Godot carrega `project.godot` ([[📄 project.godot]]) e a cena
   inicial `main.tscn`, com o script [[📄 zimmy.gd]] anexado ao nó raiz.
3. **Roda no editor** — F5 executa a cena principal; o pet aparece como janela overlay
   transparente sem bordas, sempre no topo ([[🪟 Sistema - Janela Overlay]]).
4. **Itera** — editar o `.gd`/`.tscn`, salvar e rodar de novo. Nenhum re-export é necessário
   em Dev; o `.exe` de produção só entra no fluxo de [[🚀 Export e Publicação (Prod)]].

## 🎛️ Dados de runtime (onde o app grava)
O app persiste em `user://` (perfil do usuário do Godot), não no repo:
`state.json`, `schedules.json`, `reminders.json`, etc. Ver [[💾 Sistema - Persistência]].

## 📏 Regras que respeita
- 🎮 Regra global GODOT: **fechar o jogo em execução e o editor antes de afetar o código.**
- 🌿 GitFlow: desenvolvimento em feature branch; `main` reflete produção.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** ao rodar — são
  **intencionais** (cálculos de posição em pixels inteiros no [[🟢 Fluxo - Inicialização]]
  e no [[🪟 Sistema - Janela Overlay|_relayout]]).
- **Janela com quadrado preto / transparência quebrada** — o renderer precisa ser
  **Compatibility (OpenGL)** e o MSAA 2D desligado. Ver [[📄 project.godot]] e
  [[🪟 Sistema - Janela Overlay]].
- **Checagem de sintaxe sem rodar** — validar um script headless:
  ```powershell
  & "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
    --headless --path "C:\GODOT\ZIMMY" --check-only --script "res://zimmy.gd"
  ```

## 🔗 Ligações
[[🚀 Export e Publicação (Prod)]] · [[📄 project.godot]] · [[📄 main.tscn]] ·
[[📄 zimmy.gd]] · [[🪟 Sistema - Janela Overlay]] · [[🏠 Home]]
