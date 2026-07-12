---
tipo: procedimento
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [procedimiento, release, github, distribucion, zimmy-pet]
---

# 📦 Atualizar Asset da Release (GitHub)

> 🇧🇷 Lee esta página en portugués → [[📦 Atualizar Asset da Release (GitHub)]]
> 🇺🇸 Read this page in English → [[📦 Atualizar Asset da Release (GitHub) (EN)]]

> **Objetivo:** reemplazar/actualizar el binario `ZimmyPet.exe` publicado en la página de
> releases (`https://github.com/zimerfeld/ZIMMY/releases`) y dejarlo visible al público.

## ⚠️ Regla de oro — el binario NO va por git

Los assets de release **no** se versionan en git. El `.exe` (~101 MB) **no puede
commitearse/subirse** — GitHub rechaza archivos **> 100 MB**. El binario se gestiona
**directamente en la release** con `gh` (GitHub CLI). Ver `.gitignore`: `build/` se
ignora a propósito (el `.exe` no se versiona).

## ⚡ TL;DR — los dos comandos

```powershell
cd C:/GODOT/ZIMMY
# 1) Reemplazar el .exe (--clobber sobrescribe el asset con el mismo nombre)
gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
# 2) Publicar la release (mientras sea borrador, nadie la ve)
gh release edit 202607071044geracao-30s --draft=false
```

## ⚙️ Paso a paso

1. **Reemplazar el `.exe`** — `--clobber` sobrescribe el asset con el mismo nombre:
   ```powershell
   cd C:/GODOT/ZIMMY
   gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
   ```
2. **Publicar la release** para que aparezca en la página pública (mientras sea `draft`,
   solo tú, con sesión iniciada, la ves):
   ```powershell
   gh release edit 202607071044geracao-30s --draft=false
   ```

## 🧰 Comandos útiles relacionados

- **Eliminar un asset antiguo:** `gh release delete-asset 202607071044geracao-30s ZimmyPet.exe`
- **Ver la release en el navegador:** `gh release view 202607071044geracao-30s --web`
- **Comprobar estado/assets:**
  `gh release view 202607071044geracao-30s --json tagName,isDraft,assets`
- **Listar releases:** `gh release list`

## ➕ Crear una nueva release (nueva tag)

Cuando quieras **publicar bajo una nueva tag** (en lugar de actualizar el mismo asset),
crea una release nueva — el **título pasa a ser la propia tag** (sin nombre descriptivo
tipo "Zimmy Pet — …"):

```powershell
cd C:/GODOT/ZIMMY
# la tag debe existir en el remoto (si es local, crearla/enviarla antes):
git tag 202607072157 origin/main
git push origin refs/tags/202607072157
# título = la propia tag; --notes-file para el cuerpo (changelog)
gh release create 202607072157 build/ZimmyPet.exe --title "202607072157" --notes-file notas.md
```

- **Título solo con la tag:** pasa `--title "<TAG>"` — evita el nombre descriptivo arriba.
- **Reutilizar las notas de una release anterior:**
  ```powershell
  gh release view <TAG_ANTIGUA> --json body -q .body | Set-Content notas.md
  ```
- Las releases antiguas pueden **mantenerse** — la más nueva pasa a ser **Latest**
  automáticamente y es la que sirve el botón **Download** del sitio (`/releases`).

## 🛟 Notas

- **Release Latest actual:** `202607072157` (título = solo la tag; notas bilingües 🇺🇸/🇧🇷),
  creada en `main` (`53a390e`). Las anteriores (`202607071044geracao-30s`,
  `202606251217`) se **mantuvieron**. El `.exe` publicado en la Latest lo lee el botón
  **Download** del sitio `zimmy.zimerfeld.com` (GitHub Pages a partir de `main`) y también
  se distribuye en itch.io.
- Al crear una **nueva versión**, publicar bajo una **nueva tag** (patrón `YYYYMMddhhmm<nombre>`)
  en lugar de reutilizar la actual — el `--clobber` es para corregir/actualizar el binario de
  la **misma** versión.
- Si por error el `.exe` entra en el historial de git, **no lo subas** — deshaz con
  `git reset --soft HEAD~1`, asegura `build/` en el `.gitignore` y retíralo del staging
  (`git restore --staged`).

## 🔗 Enlaces
- [[🚀 Export e Publicação (Prod) (ES)]] — generar el `build/ZimmyPet.exe` antes de publicar
- [[💻 Rodar no Editor (Dev) (ES)]] · [[🏠 Home (ES)]] · [[📌 Backlog (ES)]]
