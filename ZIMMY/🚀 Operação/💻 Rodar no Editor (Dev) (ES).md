---
tipo: procedimento
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [procedimento, dev, editor, godot, zimmy-pet]
---

# 💻 Rodar no Editor (Dev)

> 🇧🇷 Lee esta página en portugués → [[💻 Rodar no Editor (Dev)]]
> 🇺🇸 Read this page in English → [[💻 Rodar no Editor (Dev) (EN)]]

> **Objetivo:** abrir y ejecutar el Zimmy Pet en el **editor de Godot** durante el desarrollo
> (bucle rápido de código → ejecutar → ver), sin pasar por el export de producción.
> Engine: **Godot 4.6.2 stable** en `C:\GODOT\Godot_v4.6.2-stable_win64.exe\` (el "exe" es,
> en realidad, una carpeta con `Godot_v4.6.2-stable_win64.exe` y el `_console.exe`).
> Proyecto: `C:\GODOT\ZIMMY` · escena inicial `res://main.tscn` ([[📄 main.tscn (ES)]]).

## ⚡ TL;DR — el comando único
Abrir el proyecto en el editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --editor --path "C:\GODOT\ZIMMY"
```
Con el editor abierto, ejecutar la escena principal con **F5** (o el botón ▶). Para ejecutar directamente,
sin abrir el editor:
```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" `
  --path "C:\GODOT\ZIMMY"
```

## ⚙️ Qué hace el proceso (en orden)
1. **Cierra instancias** — cerrar cualquier `ZimmyPet.exe` (build de prod) en ejecución y
   cualquier editor de Godot ya abierto antes de tocar el código (regla global del proyecto GODOT).
2. **Abre el proyecto** — Godot carga `project.godot` ([[📄 project.godot (ES)]]) y la escena
   inicial `main.tscn`, con el script [[📄 zimmy.gd (ES)]] adjuntado al nodo raíz.
3. **Ejecuta en el editor** — F5 ejecuta la escena principal; la mascota aparece como ventana overlay
   transparente sin bordes, siempre encima ([[🪟 Sistema - Janela Overlay (ES)]]).
4. **Itera** — editar el `.gd`/`.tscn`, guardar y ejecutar de nuevo. No hace falta ningún re-export
   en Dev; el `.exe` de producción solo entra en el flujo de [[🚀 Export e Publicação (Prod) (ES)]].

## 🎛️ Datos de runtime (dónde graba la app)
La app persiste en `user://` (perfil del usuario de Godot), no en el repo:
`state.json`, `schedules.json`, `reminders.json`, etc. Ver [[💾 Sistema - Persistência (ES)]].

## 📏 Reglas que respeta
- 🎮 Regla global GODOT: **cerrar el juego en ejecución y el editor antes de afectar al código.**
- 🌿 GitFlow: desarrollo en feature branch; `main` refleja producción.

## 🛠️ Troubleshooting
- **`WARNING: Integer division. Decimal part will be discarded.`** al ejecutar — son
  **intencionales** (cálculos de posición en píxeles enteros en el [[🟢 Fluxo - Inicialização (ES)]]
  y en el [[🪟 Sistema - Janela Overlay (ES)|_relayout]]).
- **Ventana con cuadrado negro / transparencia rota** — el renderer debe ser
  **Compatibility (OpenGL)** y el MSAA 2D desactivado. Ver [[📄 project.godot (ES)]] y
  [[🪟 Sistema - Janela Overlay (ES)]].
- **Comprobación de sintaxis sin ejecutar** — validar un script en headless:
  ```powershell
  & "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
    --headless --path "C:\GODOT\ZIMMY" --check-only --script "res://zimmy.gd"
  ```

## 🔗 Enlaces
[[🚀 Export e Publicação (Prod) (ES)]] · [[📄 project.godot (ES)]] · [[📄 main.tscn (ES)]] ·
[[📄 zimmy.gd (ES)]] · [[🪟 Sistema - Janela Overlay (ES)]] · [[🏠 Home (ES)]]
</content>
