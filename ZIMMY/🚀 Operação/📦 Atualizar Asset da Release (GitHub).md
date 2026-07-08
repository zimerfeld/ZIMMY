---
tipo: procedimento
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [procedimento, release, github, distribuicao, zimmy-pet]
---

# 📦 Atualizar Asset da Release (GitHub)

> **Objetivo:** trocar/atualizar o binário `ZimmyPet.exe` publicado na página de releases
> (`https://github.com/zimerfeld/ZIMMY/releases`) e deixá-lo visível ao público.

## ⚠️ Regra de ouro — binário NÃO vai pelo git

Assets de release **não** são versionados no git. O `.exe` (~101 MB) **não pode ser
commitado/enviado** — o GitHub rejeita arquivos **> 100 MB**. O binário é gerenciado
**direto na release** com o `gh` (GitHub CLI). Ver `.gitignore`: `build/` é ignorado
de propósito (o `.exe` não é versionado).

## ⚡ TL;DR — os dois comandos

```powershell
cd C:/GODOT/ZIMMY
# 1) Substituir o .exe (--clobber sobrescreve o asset de mesmo nome)
gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
# 2) Publicar a release (enquanto for draft, ninguém a vê)
gh release edit 202607071044geracao-30s --draft=false
```

## ⚙️ Passo a passo

1. **Substituir o `.exe`** — `--clobber` sobrescreve o asset de mesmo nome:
   ```powershell
   cd C:/GODOT/ZIMMY
   gh release upload 202607071044geracao-30s build/ZimmyPet.exe --clobber
   ```
2. **Publicar a release** para ela aparecer na página pública (enquanto for `draft`,
   só você, logado, a vê):
   ```powershell
   gh release edit 202607071044geracao-30s --draft=false
   ```

## 🧰 Comandos úteis relacionados

- **Remover um asset antigo:** `gh release delete-asset 202607071044geracao-30s ZimmyPet.exe`
- **Ver a release no navegador:** `gh release view 202607071044geracao-30s --web`
- **Conferir estado/assets:**
  `gh release view 202607071044geracao-30s --json tagName,isDraft,assets`
- **Listar releases:** `gh release list`

## ➕ Criar uma nova release (nova tag)

Quando quiser **publicar sob uma nova tag** (em vez de atualizar o asset da mesma),
crie uma release nova — o **título fica sendo a própria tag** (sem nome descritivo
tipo "Zimmy Pet — …"):

```powershell
cd C:/GODOT/ZIMMY
# a tag precisa existir no remoto (se for local, criar/enviar antes):
git tag 202607072157 origin/main
git push origin refs/tags/202607072157
# título = a própria tag; --notes-file para o corpo (changelog)
gh release create 202607072157 build/ZimmyPet.exe --title "202607072157" --notes-file notas.md
```

- **Título só com a tag:** passe `--title "<TAG>"` — evita o nome descritivo no topo.
- **Reaproveitar as notas de uma release anterior:**
  ```powershell
  gh release view <TAG_ANTIGA> --json body -q .body | Set-Content notas.md
  ```
- Releases antigas podem ser **mantidas** — a mais nova vira **Latest** automaticamente e
  é a que o botão **Download** do site (`/releases`) passa a servir.

## 🛟 Notas

- **Release Latest atual:** `202607072157` (título = só a tag; notas bilíngues 🇺🇸/🇧🇷),
  criada em `main` (`53a390e`). As anteriores (`202607071044geracao-30s`,
  `202606251217`) foram **mantidas**. O `.exe` publicado na Latest é lido pelo botão
  **Download** do site `zimmy.zimerfeld.com` (GitHub Pages a partir de `main`) e também
  distribuído no itch.io.
- Ao criar uma **nova versão**, publicar sob uma **nova tag** (padrão `YYYYMMddhhmm<nome>`)
  em vez de reaproveitar a atual — o `--clobber` é para corrigir/atualizar o binário da
  **mesma** versão.
- Se por engano o `.exe` entrar no histórico do git, **não envie** — desfaça com
  `git reset --soft HEAD~1`, garanta `build/` no `.gitignore` e retire-o do staging
  (`git restore --staged`).

## 🔗 Ligações
- [[🚀 Export e Publicação (Prod)]] — gerar o `build/ZimmyPet.exe` antes de publicar
- [[💻 Rodar no Editor (Dev)]] · [[🏠 Home]] · [[📌 Backlog]]
