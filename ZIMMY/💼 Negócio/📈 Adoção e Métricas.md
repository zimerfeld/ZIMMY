---
tipo: negocio
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [referencia, adocao, metricas, portfolio, zimmy-pet]
---

# 📈 Adoção e Métricas

> 🇪🇸 Lee esta página en español → [[📈 Adoção e Métricas (ES)]]

Acompanhamento de **adoção** dos produtos open source do portfólio (owner `zimerfeld`).
Regra global: manter a contagem sempre atualizada. Fonte de verdade no repo ZIMMY:
`contagem de downloads.txt` (log datado).

## 📏 Como medir
Autenticar uma vez (`gh auth login`) e, por repo:
```
gh api repos/zimerfeld/<repo>/traffic/clones
gh api repos/zimerfeld/<repo>/releases --jq '[.[].assets[].download_count]|add // 0'
```
- **`traffic/clones`** exige *push access* e cobre só os **últimos 14 dias** (janela móvel) —
  o valor **não é acumulado**; para o total histórico ver o cálculo do projeto zimerfeld.com.
- **ZIMMY publica GitHub Release** com o `ZimmyPet.exe` **desde 2026-06-25** (1ª release
  `202606251217`; nova release `202607071044geracao-30s` em 2026-07-07). O *downloads* do ZIMMY
  é a soma **acumulada (all-time)** das baixadas do `ZimmyPet.exe` em **todas** as releases —
  **desde a 1ª publicação (2026-06-25) até agora** — ao contrário dos clones, que são janela
  móvel de 14 dias. Valor atual = **0** baixadas. Os outros 3 repos ainda **não publicam assets**
  (*downloads = 0*) e a métrica viva deles continua sendo **clones**. Os `GitExtensions.*` são
  pacotes **NuGet** (adoção all-time via NuGet fica no zimerfeld.com).

## 📸 Snapshot 2026-07-07 (clones 14d)
| Repo | Clones (14d) | Uniques | Downloads | Total |
|---|---|---|---|---|
| ZIMARO | 706 | 271 | 0 | **706** |
| GitExtensions.ZimerfeldTree | 432 | 167 | 0 | **432** |
| GitExtensions.ZimerfeldCommitMsg | 305 | 146 | 0 | **305** |
| **ZIMMY** | 257 | 107 | 0¹ | **257** |

> ¹ *Downloads* do ZIMMY = acumulado **all-time** do `ZimmyPet.exe` (release) **desde a 1ª
> publicação em 2026-06-25** até agora = **0** baixadas hoje. Diferente dos clones (14 dias).
>
> Anterior (2026-07-01): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293. Clones são
> **janela móvel de 14 dias** (não acumulam); o histórico datado fica em
> `contagem de downloads.txt` (fonte de verdade).

> Ambiente: `gh` instalado em `C:\Program Files\GitHub CLI\gh.exe`, autenticado como
> `zimerfeld` (keyring). Não estava mais bloqueado — era só rodar.

Relacionado: [[📚 Repositório e Branches]], [[🏠 Home]].
