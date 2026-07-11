---
tipo: negocio
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-07
tags: [referencia, adocao, metricas, portfolio, zimmy-pet]
---

# 📈 Adopción y Métricas

> 🇧🇷 Lee esta página en portugués → [[📈 Adoção e Métricas]]
> 🇺🇸 Read this page in English → [[📈 Adoção e Métricas (EN)]]

Seguimiento de la **adopción** de los productos open source del portafolio (owner `zimerfeld`).
Regla global: mantener el conteo siempre actualizado. Fuente de verdad en el repo ZIMMY:
`contagem de downloads.txt` (registro con fecha).

## 📏 Cómo medir
Autenticarse una vez (`gh auth login`) y, por repo:
```
gh api repos/zimerfeld/<repo>/traffic/clones
gh api repos/zimerfeld/<repo>/releases --jq '[.[].assets[].download_count]|add // 0'
```
- **`traffic/clones`** exige *push access* y cubre solo los **últimos 14 días** (ventana móvil) —
  el valor **no es acumulado**; para el total histórico ver el cálculo del proyecto zimerfeld.com.
- **ZIMMY publica GitHub Release** con el `ZimmyPet.exe` **desde 2026-06-25** (1.ª release
  `202606251217`; nueva release `202607071044geracao-30s` el 2026-07-07). El *downloads* de ZIMMY
  es la suma **acumulada (all-time)** de las descargas del `ZimmyPet.exe` en **todas** las releases —
  **desde la 1.ª publicación (2026-06-25) hasta ahora** — al contrario que los clones, que son ventana
  móvil de 14 días. Valor actual = **0** descargas. Los otros 3 repos aún **no publican assets**
  (*downloads = 0*) y su métrica viva sigue siendo **clones**. Los `GitExtensions.*` son
  paquetes **NuGet** (adopción all-time vía NuGet está en zimerfeld.com).

## 📸 Snapshot 2026-07-07 (clones 14d)
| Repo | Clones (14d) | Únicos | Descargas | Total |
|---|---|---|---|---|
| ZIMARO | 706 | 271 | 0 | **706** |
| GitExtensions.ZimerfeldTree | 432 | 167 | 0 | **432** |
| GitExtensions.ZimerfeldCommitMsg | 305 | 146 | 0 | **305** |
| **ZIMMY** | 257 | 107 | 0¹ | **257** |

> ¹ *Downloads* de ZIMMY = acumulado **all-time** del `ZimmyPet.exe` (release) **desde la 1.ª
> publicación el 2026-06-25** hasta ahora = **0** descargas hoy. Diferente de los clones (14 días).
>
> Anterior (2026-07-01): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293. Los clones son
> **ventana móvil de 14 días** (no se acumulan); el histórico con fecha está en
> `contagem de downloads.txt` (fuente de verdad).

> Entorno: `gh` instalado en `C:\Program Files\GitHub CLI\gh.exe`, autenticado como
> `zimerfeld` (keyring). Ya no estaba bloqueado — solo había que ejecutarlo.

Relacionado: [[📚 Repositório e Branches (ES)]], [[🏠 Home (ES)]].
