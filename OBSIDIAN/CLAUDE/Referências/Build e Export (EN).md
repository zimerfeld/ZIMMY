---
tags: [referencia, build, zimmy-pet]
atualizado: 2026-06-21
lang: en
---

# 🏗️ Build and Export

Engine: **Godot 4.6.2 stable** at `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (the "exe"
is actually a folder containing `Godot_v4.6.2-stable_win64.exe` and `_console.exe`).

## Run from the editor / command line
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" --path "C:\GODOT\ZIMMY"
```
Running it this way **does not require exporting** — [[zimmy.gd (EN)]] is read directly.

## Re-export the .exe (after changes)
`build/ZimmyPet.exe` embeds the code in the `.pck`; changes require a re-export:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```
Then embed the icon into the `.exe`:
```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```
> ⚙️ Project convention: **always re-export** at the end of any change to the game.

## Automatic build (`.claude/build-if-changed.ps1`)
Triggered by the **Stop hook**. Re-exports only if some `.gd/.tscn/.json/.godot/.cfg` is
newer than the `.exe`. **Before exporting, it terminates any running `ZimmyPet.exe`**
(`Stop-Process`) and removes a leftover `ZimmyPet.tmp` — otherwise renaming the
temporary file fails with *"locked by a running instance"*.

## Preset
Defined in [[export_presets.cfg (EN)]]: Windows Desktop platform, `embed_pck=true`,
`x86_64` architecture, icon `res://zimmy.ico`, excludes `tools/*`.

## Expected warnings
On load, Godot emits a few `WARNING: Integer division. Decimal part will be
discarded.` — these are **intentional** (integer-pixel position calculations in
[[Fluxo - Inicialização (EN)]] and in [[Sistema - Janela Overlay (EN)|_relayout]]).

## Renderer (critical for transparency)
Compatibility (OpenGL) + 2D MSAA off. See [[project.godot (EN)]] and
[[Sistema - Janela Overlay (EN)]].
