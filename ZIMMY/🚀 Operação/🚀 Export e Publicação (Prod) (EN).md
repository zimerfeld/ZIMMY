---
tipo: procedimento
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [procedimento, build, export, zimmy-pet]
---

# 🚀 Export and Publishing (Prod)

> **Goal:** produce the production binary `build/ZimmyPet.exe` (Windows) and publish it
> to the distribution channels (GitHub releases / itch.io).
> Engine: **Godot 4.6.2 stable** at `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (the "exe"
> is actually a folder containing `Godot_v4.6.2-stable_win64.exe` and `_console.exe`).

## ⚡ TL;DR — the single command
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```
Then embed the icon into the `.exe`:
```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## ⚙️ What the process does (in order)
1. **Closes instances** — terminate any running `ZimmyPet.exe` and the Godot editor
   before touching the code/exporting (project-wide global rule).
2. **Headless export** — `build/ZimmyPet.exe` embeds the code in the `.pck`
   (`embed_pck=true`); any change to the game requires a re-export.
3. **Embeds the icon** — `rcedit-x64.exe --set-icon` with `zimmy.ico`.
4. **Publishes** — the latest `.exe` goes to the channels: itch.io page
   ([[🎮 itch.io — Página (EN)|itch.io — Page]]) and/or a GitHub release. `build/` is
   gitignored (the `.exe` is not versioned).

## 🤖 Automatic build (`.claude/build-if-changed.ps1`)
Triggered by the **Stop hook**. Re-exports only if some `.gd/.tscn/.json/.godot/.cfg` is
newer than the `.exe`. **Before exporting, it terminates any running `ZimmyPet.exe`**
(`Stop-Process`) and removes a leftover `ZimmyPet.tmp` — otherwise renaming the
temporary file fails with *"locked by a running instance"*.

## 🎛️ Preset (parameters)
Defined in [[📄 export_presets.cfg (EN)]]: Windows Desktop platform, `embed_pck=true`,
`x86_64` architecture, icon `res://zimmy.ico`, excludes `tools/*`.

## 📏 Rules it follows
- ⚙️ Project convention: **always re-export** at the end of any change to the game.
- 🎮 GODOT global rule: close the running game and the editor before touching the code.
- 🌿 GitFlow: development happens on a feature branch; `main` reflects production.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** on load — these are
  **intentional** (integer-pixel position calculations in [[🟢 Fluxo - Inicialização (EN)|Init flow]]
  and in [[🪟 Sistema - Janela Overlay (EN)|_relayout]]).
- **"locked by a running instance"** during export — a `ZimmyPet.exe` was open or a
  leftover `ZimmyPet.tmp` existed; terminate the process and delete the `.tmp`.
- **Broken transparency** in the binary — the renderer is critical: Compatibility (OpenGL)
  + 2D MSAA off. See [[📄 project.godot (EN)]] and [[🪟 Sistema - Janela Overlay (EN)]].

## 🔗 Links
[[📦 Atualizar Asset da Release (GitHub) (EN)|Update the Release Asset (GitHub)]] — publish/update the `.exe` on the releases page ·
[[💻 Rodar no Editor (Dev) (EN)|Run in the Editor (Dev)]] · [[📄 export_presets.cfg (EN)]] ·
[[📄 project.godot (EN)]] · [[🎮 itch.io — Página (EN)|itch.io — Page]] ·
[[🚀 Distribuição e Crescimento (EN)|Distribution and Growth]] · [[🏠 Home (EN)|Home]]
