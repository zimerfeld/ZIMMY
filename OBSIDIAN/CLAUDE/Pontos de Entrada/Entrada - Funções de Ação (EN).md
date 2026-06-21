---
tags: [endpoint, api, zimmy-pet]
atualizado: 2026-06-20
lang: en
---

# 🚪 Entry Point - Action Functions

The pet behavior's "public API". All interaction ones go through
`_can_act()` ([[Sistema - Interação e Mau Humor (EN)]]).

| Function | Public? | Limited? | Summary |
|---|---|---|---|
| `feed()` | yes | yes | eats: −hunger, +mood, speaks, jumps |
| `pet()` | yes | yes | petting: +mood, jumps |
| `play()` | yes | yes | plays: +mood, +hunger, jumps high |
| `_react()` | no | yes | simple click: slight +mood |
| `_complain()` | no | — | bad mood (insistence), −mood |
| `hop(force=320)` | yes | no | gives a jump impulse (`vy=-force`) |
| `say(t)` | yes | no | shows text and re-layouts |

## Triggers
- Menu → [[Entrada - Itens do Menu (EN)]] (`feed/pet/play`).
- Click on the pet → `_react` ([[Entrada - Eventos de Input (EN)]]).
- `hop`/`say` are reused by almost everything (generation, saving, etc.).

> Evolution idea: ZIMARO could launch the pet via `OS.create_process()` and, in the
> future, command `say()`/actions through some IPC. Today there is no such external endpoint.

Numeric effects in [[Fluxo - Interação e Limites (EN)]].
