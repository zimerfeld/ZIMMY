---
tipo: procedimento
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [procedimento, dev, editor, godot, zimmy-pet]
---

# 💻 Run in the Editor (Dev)

> 🇧🇷 Leia esta página em português → [[💻 Rodar no Editor (Dev)]]
> 🇪🇸 Lee esta página en español → [[💻 Rodar no Editor (Dev) (ES)]]

> **Goal:** open and run Zimmy Pet in the **Godot editor** during development (a fast
> code → run → see loop), without going through the production export.
> Engine: **Godot 4.6.2 stable** at `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (the "exe" is
> actually a folder containing `Godot_v4.6.2-stable_win64.exe` and `_console.exe`).
> Project: `C:\GODOT\ZIMMY` · initial scene `res://main.tscn` ([[📄 main.tscn (EN)]]).

## ⚡ TL;DR — the single command
Open the project in the editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --editor --path "C:\GODOT\ZIMMY"
```
With the editor open, run the main scene with **F5** (or the ▶ button). To run it directly,
without opening the editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --path "C:\GODOT\ZIMMY"
```

## ⚙️ What the process does (in order)
1. **Closes instances** — terminate any running `ZimmyPet.exe` (prod build) and any Godot
   editor already open before touching the code (GODOT project-wide global rule).
2. **Opens the project** — Godot loads `project.godot` ([[📄 project.godot (EN)]]) and the
   initial scene `main.tscn`, with the [[📄 zimmy.gd (EN)]] script attached to the root node.
3. **Runs in the editor** — F5 runs the main scene; the pet appears as a transparent,
   borderless overlay window, always on top ([[🪟 Sistema - Janela Overlay (EN)|Overlay Window system]]).
4. **Iterates** — edit the `.gd`/`.tscn`, save and run again. No re-export is needed in Dev;
   the production `.exe` only enters via the [[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]] flow.

## 🎛️ Runtime data (where the app writes)
The app persists to `user://` (Godot's user profile), not the repo:
`state.json`, `schedules.json`, `reminders.json`, etc. See [[💾 Sistema - Persistência (EN)|Persistence system]].

## 📏 Rules it follows
- 🎮 GODOT global rule: **close the running game and the editor before touching the code.**
- 🌿 GitFlow: development happens on a feature branch; `main` reflects production.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** on run — these are
  **intentional** (integer-pixel position calculations in [[🟢 Fluxo - Inicialização (EN)|Init flow]]
  and in [[🪟 Sistema - Janela Overlay (EN)|_relayout]]).
- **Black square window / broken transparency** — the renderer must be
  **Compatibility (OpenGL)** with 2D MSAA off. See [[📄 project.godot (EN)]] and
  [[🪟 Sistema - Janela Overlay (EN)]].
- **Syntax check without running** — validate a script headless:
  ```powershell
  & "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
    --headless --path "C:\GODOT\ZIMMY" --check-only --script "res://zimmy.gd"
  ```

## 🔗 Links
[[🚀 Export e Publicação (Prod) (EN)|Export and Publishing (Prod)]] · [[📄 project.godot (EN)]] ·
[[📄 main.tscn (EN)]] · [[📄 zimmy.gd (EN)]] ·
[[🪟 Sistema - Janela Overlay (EN)|Overlay Window system]] · [[🏠 Home (EN)|Home]]
