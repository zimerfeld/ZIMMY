---
tipo: procedimento
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [procedimento, build, export, zimmy-pet]
---

# 🚀 Export e Publicação (Prod)

> **Objetivo:** gerar o binário de produção `build/ZimmyPet.exe` (Windows) e publicá-lo
> nos canais de distribuição (GitHub releases / itch.io).
> Engine: **Godot 4.6.2 stable** em `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (a "exe"
> é, na verdade, uma pasta com `Godot_v4.6.2-stable_win64.exe` e o `_console.exe`).

## ⚡ TL;DR — o comando único
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```
Depois embutir o ícone no `.exe`:
```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## ⚙️ O que o processo faz (em ordem)
1. **Fecha instâncias** — encerrar qualquer `ZimmyPet.exe` em execução e o editor Godot
   antes de mexer no código/exportar (regra global do projeto).
2. **Exporta headless** — o `build/ZimmyPet.exe` embute o código no `.pck`
   (`embed_pck=true`); qualquer mudança no jogo exige re-export.
3. **Embute o ícone** — `rcedit-x64.exe --set-icon` com `zimmy.ico`.
4. **Publica** — o `.exe` mais recente vai para os canais: página no itch.io
   ([[🎮 itch.io — Página]]) e/ou release no GitHub. `build/` é gitignored
   (o `.exe` não é versionado).

## 🤖 Build automático (`.claude/build-if-changed.ps1`)
Disparado pelo **Stop hook**. Re-exporta só se algum `.gd/.tscn/.json/.godot/.cfg` for
mais novo que o `.exe`. **Antes de exportar, encerra qualquer `ZimmyPet.exe` em
execução** (`Stop-Process`) e remove um `ZimmyPet.tmp` residual — senão o rename do
arquivo temporário falha com *"locked by a running instance"*.

## 🎛️ Preset (parâmetros)
Definido em [[📄 export_presets.cfg]]: plataforma Windows Desktop, `embed_pck=true`,
arquitetura `x86_64`, ícone `res://zimmy.ico`, exclui `tools/*`.

## 📏 Regras que respeita
- ⚙️ Convenção do projeto: **sempre re-exportar** ao fim de qualquer mudança no jogo.
- 🎮 Regra global GODOT: fechar o jogo em execução e o editor antes de afetar o código.
- 🌿 GitFlow: desenvolvimento em feature branch; `main` reflete produção.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** ao carregar — são
  **intencionais** (cálculos de posição em pixels inteiros no [[🟢 Fluxo - Inicialização]]
  e no [[🪟 Sistema - Janela Overlay|_relayout]]).
- **"locked by a running instance"** no export — havia um `ZimmyPet.exe` aberto ou um
  `ZimmyPet.tmp` residual; encerrar o processo e apagar o `.tmp`.
- **Transparência quebrada** no binário — o renderer é crítico: Compatibility (OpenGL)
  + MSAA 2D desligado. Ver [[📄 project.godot]] e [[🪟 Sistema - Janela Overlay]].

## 🔗 Ligações
[[💻 Rodar no Editor (Dev)]] · [[📄 export_presets.cfg]] · [[📄 project.godot]] ·
[[🎮 itch.io — Página]] · [[🚀 Distribuição e Crescimento]] · [[🏠 Home]]
