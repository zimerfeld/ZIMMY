---
tags: [referencia, adocao, metricas, portfolio, zimmy-pet]
atualizado: 2026-07-01
---

# 📈 Adoção e Métricas

Acompanhamento de **adoção** dos produtos open source do portfólio (owner `zimerfeld`).
Regra global: manter a contagem sempre atualizada. Fonte de verdade no repo ZIMMY:
`contagem de downloads.txt` (log datado).

## Como medir
Autenticar uma vez (`gh auth login`) e, por repo:
```
gh api repos/zimerfeld/<repo>/traffic/clones
gh api repos/zimerfeld/<repo>/releases --jq '[.[].assets[].download_count]|add // 0'
```
- **`traffic/clones`** exige *push access* e cobre só os **últimos 14 dias** (janela móvel) —
  o valor **não é acumulado**; para o total histórico ver o cálculo do projeto zimerfeld.com.
- Os 4 repos **não publicam assets de release** no GitHub, então *downloads = 0* e a métrica
  viva é **clones**. Os `GitExtensions.*` são pacotes **NuGet** (adoção all-time via NuGet
  fica no zimerfeld.com).

## Snapshot 2026-07-01 (clones 14d)
| Repo | Clones (14d) | Uniques | Downloads | Total |
|---|---|---|---|---|
| ZIMARO | 790 | 331 | 0 | **790** |
| GitExtensions.ZimerfeldTree | 532 | 214 | 0 | **532** |
| **ZIMMY** | 318 | 131 | 0 | **318** |
| GitExtensions.ZimerfeldCommitMsg | 293 | 140 | 0 | **293** |

> Ambiente: `gh` instalado em `C:\Program Files\GitHub CLI\gh.exe`, autenticado como
> `zimerfeld` (keyring). Não estava mais bloqueado — era só rodar.

Relacionado: [[Repositório e Branches]], [[Home]].
