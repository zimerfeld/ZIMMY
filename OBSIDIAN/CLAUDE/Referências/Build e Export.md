---
tags: [referencia, build, zimmy-pet]
atualizado: 2026-06-20
---

# 🏗️ Build e Export

Engine: **Godot 4.6.2 stable** em `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (a "exe"
é, na verdade, uma pasta com `Godot_v4.6.2-stable_win64.exe` e o `_console.exe`).

## Rodar pelo editor / linha de comando
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" --path "C:\GODOT\ZIMMY_PET"
```
Rodando assim **não precisa exportar** — o [[zimmy.gd]] é lido direto.

## Re-exportar o .exe (após mudanças)
O `build/ZimmyPet.exe` embute o código no `.pck`; mudanças exigem re-export:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY_PET" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY_PET\build\ZimmyPet.exe"
```
Depois embutir o ícone no `.exe`:
```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY_PET\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY_PET\zimmy.ico"
```
> ⚙️ Convenção do projeto: **sempre re-exportar** ao fim de qualquer mudança no jogo.

## Preset
Definido em [[export_presets.cfg]]: plataforma Windows Desktop, `embed_pck=true`,
arquitetura `x86_64`, ícone `res://zimmy.ico`, exclui `tools/*`.

## Avisos esperados
Ao carregar, o Godot emite alguns `WARNING: Integer division. Decimal part will be
discarded.` — são **intencionais** (cálculos de posição em pixels inteiros no
[[Fluxo - Inicialização]] e no [[Sistema - Janela Overlay|_relayout]]).

## Renderer (crítico p/ transparência)
Compatibility (OpenGL) + MSAA 2D desligado. Ver [[project.godot]] e
[[Sistema - Janela Overlay]].
