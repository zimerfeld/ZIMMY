---
tipo: negocio
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [referencia, adocao, metricas, portfolio, zimmy-pet]
---

# 📈 Adoption & Metrics

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
- The 4 repos **don't publish release assets** on GitHub, so *downloads = 0* and the live
  metric is **clones**. The `GitExtensions.*` are **NuGet** packages (all-time NuGet
  adoption lives in zimerfeld.com).

## 📸 Snapshot 2026-07-01 (clones 14d)
| Repo | Clones (14d) | Uniques | Downloads | Total |
|---|---|---|---|---|
| ZIMARO | 790 | 331 | 0 | **790** |
| GitExtensions.ZimerfeldTree | 532 | 214 | 0 | **532** |
| **ZIMMY** | 318 | 131 | 0 | **318** |
| GitExtensions.ZimerfeldCommitMsg | 293 | 140 | 0 | **293** |

> Environment: `gh` installed at `C:\Program Files\GitHub CLI\gh.exe`, authenticated as
> `zimerfeld` (keyring). It was no longer blocked — just needed to run.

Related: [[📚 Repositório e Branches (EN)]], [[🏠 Home (EN)]].
