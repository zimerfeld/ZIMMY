---
tipo: procedimento
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [procedimento, build, export, zimmy-pet]
---

# 🚀 Export e Publicação (Prod)

> 🇧🇷 Lee esta página en portugués → [[🚀 Export e Publicação (Prod)]]
> 🇺🇸 Read this page in English → [[🚀 Export e Publicação (Prod) (EN)]]

> **Objetivo:** generar el binario de producción `build/ZimmyPet.exe` (Windows) y publicarlo
> en los canales de distribución (GitHub releases / itch.io).
> Engine: **Godot 4.6.2 stable** en `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (el "exe"
> es, en realidad, una carpeta con `Godot_v4.6.2-stable_win64.exe` y el `_console.exe`).

## ⚡ TL;DR — el comando único
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```
Después incrustar el icono en el `.exe`:
```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## ⚙️ Qué hace el proceso (en orden)
1. **Cierra instancias** — cerrar cualquier `ZimmyPet.exe` en ejecución y el editor de Godot
   antes de tocar el código/exportar (regla global del proyecto).
2. **Exporta headless** — el `build/ZimmyPet.exe` incrusta el código en el `.pck`
   (`embed_pck=true`); cualquier cambio en el juego exige re-export.
3. **Incrusta el icono** — `rcedit-x64.exe --set-icon` con `zimmy.ico`.
4. **Publica** — el `.exe` más reciente va a los canales: página en itch.io
   ([[🎮 itch.io — Página (ES)]]) y/o release en GitHub. `build/` es gitignored
   (el `.exe` no se versiona).

## 🤖 Build automático (`.claude/build-if-changed.ps1`)
Disparado por el **Stop hook**. Re-exporta solo si algún `.gd/.tscn/.json/.godot/.cfg` es
más nuevo que el `.exe`. **Antes de exportar, cierra cualquier `ZimmyPet.exe` en
ejecución** (`Stop-Process`) y elimina un `ZimmyPet.tmp` residual — de lo contrario el rename del
archivo temporal falla con *"locked by a running instance"*.

## 🎛️ Preset (parámetros)
Definido en [[📄 export_presets.cfg (ES)]]: plataforma Windows Desktop, `embed_pck=true`,
arquitectura `x86_64`, icono `res://zimmy.ico`, excluye `tools/*`.

## 📏 Reglas que respeta
- ⚙️ Convención del proyecto: **siempre re-exportar** al final de cualquier cambio en el juego.
- 🎮 Regla global GODOT: cerrar el juego en ejecución y el editor antes de afectar al código.
- 🌿 GitFlow: desarrollo en feature branch; `main` refleja producción.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** al cargar — son
  **intencionales** (cálculos de posición en píxeles enteros en el [[🟢 Fluxo - Inicialização (ES)]]
  y en el [[🪟 Sistema - Janela Overlay (ES)|_relayout]]).
- **"locked by a running instance"** en el export — había un `ZimmyPet.exe` abierto o un
  `ZimmyPet.tmp` residual; cerrar el proceso y borrar el `.tmp`.
- **Transparencia rota** en el binario — el renderer es crítico: Compatibility (OpenGL)
  + MSAA 2D desactivado. Ver [[📄 project.godot (ES)]] y [[🪟 Sistema - Janela Overlay (ES)]].

## 🔗 Enlaces
[[💻 Rodar no Editor (Dev) (ES)]] · [[📄 export_presets.cfg (ES)]] · [[📄 project.godot (ES)]] ·
[[🎮 itch.io — Página (ES)]] · [[🚀 Distribuição e Crescimento (ES)]] · [[🏠 Home (ES)]]
</content>
