---
tags: [endpoint, api, zimmy-pet]
atualizado: 2026-06-20
---

# 🚪 Entrada - Funções de Ação

A "API pública" do comportamento do pet. Todas as de interação passam por
`_can_act()` ([[Sistema - Interação e Mau Humor]]).

| Função | Pública? | Limitada? | Resumo |
|---|---|---|---|
| `feed()` | sim | sim | come: −fome, +humor, fala, pula |
| `pet()` | sim | sim | carinho: +humor, pula |
| `play()` | sim | sim | brinca: +humor, +fome, pula alto |
| `_react()` | não | sim | clique simples: +humor leve |
| `_complain()` | não | — | mau humor (insistência), −humor |
| `hop(force=320)` | sim | não | dá impulso de pulo (`vy=-force`) |
| `say(t)` | sim | não | mostra texto e re-layouta |

## Gatilhos
- Menu → [[Entrada - Itens do Menu]] (`feed/pet/play`).
- Clique no pet → `_react` ([[Entrada - Eventos de Input]]).
- `hop`/`say` são reutilizadas por quase tudo (geração, salvar, etc.).

> Ideia de evolução: a ZIMARO poderia lançar o pet via `OS.create_process()` e, no
> futuro, comandar `say()`/ações por algum IPC. Hoje não há tal endpoint externo.

Efeitos numéricos em [[Fluxo - Interação e Limites]].
