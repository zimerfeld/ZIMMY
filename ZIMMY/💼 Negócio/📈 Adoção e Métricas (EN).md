---
tipo: negocio
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-07
tags: [referencia, adocao, metricas, portfolio, zimmy-pet]
---

# 📈 Adoption & Metrics

> 🇪🇸 Lee esta página en español → [[📈 Adoção e Métricas (ES)]]

Tracking the **adoption** of the portfolio's open source products (owner `zimerfeld`).
Global rule: keep the count up to date. Source of truth in the ZIMMY repo:
`contagem de downloads.txt` (dated log).

## 📏 How to measure
Authenticate once (`gh auth login`) and, per repo:
```
gh api repos/zimerfeld/<repo>/traffic/clones
gh api repos/zimerfeld/<repo>/releases --jq '[.[].assets[].download_count]|add // 0'
```
- **`traffic/clones`** requires *push access* and only covers the **last 14 days** (rolling
  window) — the value is **not cumulative**; for the historical total see the zimerfeld.com
  project calculation.
- **ZIMMY publishes a GitHub Release** with `ZimmyPet.exe` **since 2026-06-25** (1st release
  `202606251217`; new release `202607071044geracao-30s` on 2026-07-07). ZIMMY's *downloads* is
  the **cumulative (all-time)** sum of `ZimmyPet.exe` downloads across **all** releases —
  **from the first publication (2026-06-25) until now** — unlike clones, which are a 14-day
  rolling window. Current value = **0** downloads. The other 3 repos still **don't publish
  assets** (*downloads = 0*) and their live metric stays **clones**. The `GitExtensions.*` are
  **NuGet** packages (all-time NuGet adoption lives in zimerfeld.com).

## 📸 Snapshot 2026-07-07 (clones 14d)
| Repo | Clones (14d) | Uniques | Downloads | Total |
|---|---|---|---|---|
| ZIMARO | 706 | 271 | 0 | **706** |
| GitExtensions.ZimerfeldTree | 432 | 167 | 0 | **432** |
| GitExtensions.ZimerfeldCommitMsg | 305 | 146 | 0 | **305** |
| **ZIMMY** | 257 | 107 | 0¹ | **257** |

> ¹ ZIMMY's *downloads* = **all-time** cumulative of `ZimmyPet.exe` (release) **since the 1st
> publication on 2026-06-25** until now = **0** downloads today. Unlike clones (14 days).
>
> Previous (2026-07-01): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293. Clones are a
> **14-day rolling window** (not cumulative); the dated history lives in
> `contagem de downloads.txt` (source of truth).

> Environment: `gh` installed at `C:\Program Files\GitHub CLI\gh.exe`, authenticated as
> `zimerfeld` (keyring). It was no longer blocked — just needed to run.

Related: [[📚 Repositório e Branches (EN)]], [[🏠 Home (EN)]].
