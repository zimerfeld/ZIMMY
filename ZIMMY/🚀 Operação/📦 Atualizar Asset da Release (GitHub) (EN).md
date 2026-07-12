---
tipo: procedure
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [procedure, release, github, distribution, zimmy-pet]
---

# 📦 Update the Release Asset (GitHub)

> 🇧🇷 Leia esta página em português → [[📦 Atualizar Asset da Release (GitHub)]]
> 🇪🇸 Lee esta página en español → [[📦 Atualizar Asset da Release (GitHub) (ES)]]

> **Goal:** replace/update the `ZimmyPet.exe` binary published on the releases page
> (`https://github.com/zimerfeld/ZIMMY/releases`) and make it visible to the public.

## ⚠️ Golden rule — the binary does NOT go through git

Release assets are **not** versioned in git. The ~101 MB `.exe` **must not be
committed/pushed** — GitHub rejects files **> 100 MB**. The binary is managed
**directly on the release** with `gh` (GitHub CLI). See `.gitignore`: `build/` is
ignored on purpose (the `.exe` is not versioned).

## ⚡ TL;DR — the two commands

```powershell
cd C:/GODOT/ZIMMY
# 1) Replace the .exe (--clobber overwrites the asset with the same name)
gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
# 2) Publish the release (while it's a draft, nobody can see it)
gh release edit 202607071044geracao-30s --draft=false
```

## ⚙️ Step by step

1. **Replace the `.exe`** — `--clobber` overwrites the asset with the same name:
   ```powershell
   cd C:/GODOT/ZIMMY
   gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
   ```
2. **Publish the release** so it shows on the public page (while it's a `draft`,
   only you, logged in, can see it):
   ```powershell
   gh release edit 202607071044geracao-30s --draft=false
   ```

## 🧰 Handy related commands

- **Delete an old asset:** `gh release delete-asset 202607071044geracao-30s ZimmyPet.exe`
- **Open the release in the browser:** `gh release view 202607071044geracao-30s --web`
- **Check state/assets:**
  `gh release view 202607071044geracao-30s --json tagName,isDraft,assets`
- **List releases:** `gh release list`

## ➕ Create a new release (new tag)

When you want to **publish under a new tag** (instead of updating the same asset),
create a fresh release — the **title becomes the tag itself** (no descriptive name
like "Zimmy Pet — …"):

```powershell
cd C:/GODOT/ZIMMY
# the tag must exist on the remote (if local, create/push it first):
git tag 202607072157 origin/main
git push origin refs/tags/202607072157
# title = the tag itself; --notes-file for the body (changelog)
gh release create 202607072157 build/ZimmyPet.exe --title "202607072157" --notes-file notes.md
```

- **Title = tag only:** pass `--title "<TAG>"` — avoids a descriptive name at the top.
- **Reuse a previous release's notes:**
  ```powershell
  gh release view <OLD_TAG> --json body -q .body | Set-Content notes.md
  ```
- Older releases can be **kept** — the newest becomes **Latest** automatically and is
  what the site's **Download** button (`/releases`) serves.

## 🛟 Notes

- **Current Latest release:** `202607072157` (title = tag only; bilingual 🇺🇸/🇧🇷 notes),
  created on `main` (`53a390e`). The previous ones (`202607071044geracao-30s`,
  `202606251217`) were **kept**. The `.exe` on the Latest is what the **Download** button
  on `zimmy.zimerfeld.com` links to (GitHub Pages served from `main`), and it is also
  distributed on itch.io.
- When shipping a **new version**, publish under a **new tag** (pattern
  `YYYYMMddhhmm<name>`) instead of reusing the current one — `--clobber` is for
  fixing/updating the binary of the **same** version.
- If the `.exe` accidentally lands in git history, **do not push it** — undo with
  `git reset --soft HEAD~1`, make sure `build/` is in `.gitignore`, and unstage it
  (`git restore --staged`).

## 🔗 Links
- [[🚀 Export e Publicação (Prod) (EN)]] — build `build/ZimmyPet.exe` before publishing
- [[💻 Rodar no Editor (Dev) (EN)]] · [[🏠 Home (EN)]] · [[📌 Backlog (EN)]]
