---
tags: [meta, backlog, zimmy-pet]
atualizado: 2026-07-01
---

# 🗂️ _Backlog priorizado

> Nota **autossuficiente** para retomar o projeto em qualquer chat novo.
> A regra global faz o Claude ler este cofre no início — então **comece por aqui** e
> depois pela [[Home]] e [[_Memória do Claude]].
> Convenção de prioridade: **P0** = fazer já / destrava o resto · **P1** = importante,
> próxima leva · **P2** = quando sobrar tempo / crescimento.

## 📸 Snapshot do estado (2026-07-01)
- **Repo:** https://github.com/zimerfeld/ZIMMY · **branch:** `develop`
- **Último commit:** `1013cf8` (Remoção de LICENSE) — antes: `41a19e1` Alarme (43 arquivos), Temporizadores/Moedas/E-mails.
- **Engine:** Godot 4.6.2, GDScript. Código todo em [[zimmy.gd]] (~3.567 linhas, `_draw()` procedural, sem sprites).
- **Árvore suja (importante):** o cofre foi **movido de `OBSIDIAN/CLAUDE/` → `OBSIDIAN/`** e a mudança **não está commitada** (62 arquivos como `D` + 9 novos `??`). Ver **P0-1**.
- **Regras/memória relevantes:** exportar `.exe` como passo final ([[Build e Export]]); fechar `ZimmyPet.exe` e o editor Godot antes de mexer no código; manter contagem de clones/downloads.

## 🔴 P0 — destravar
- [x] **P0-1 · Commitar a reestruturação do cofre** (`OBSIDIAN/CLAUDE/` → `OBSIDIAN/`) — feito em 2026-07-01, commit `bdf60c6`: 62 renomeações (92–100%, histórico preservado) + `_Backlog.md`; `git status` limpo para `OBSIDIAN/`.
- [x] **P0-2 · Corrigir caminho obsoleto** — feito em 2026-07-01: `...\OBSIDIAN\CLAUDE` → `...\OBSIDIAN` em [[_Memória do Claude]] (PT/EN) e [[Repositório e Branches]] (PT/EN).

## 🟠 P1 — próxima leva
- [x] **P1-1 · Fechar o buraco de documentação do cofre.** Feito em 2026-07-01: criadas [[Sistema - Automações e Agendador]], [[Sistema - Moedas]] e [[Sistema - E-mails]] (par PT + (EN)), com refs `zimmy.gd:linha` verificadas e ligadas na [[Home]] (PT/EN). Detalhes originais abaixo, para referência:
  - `Sistema - Automações e Agendador` — pasta `Automacoes/`, submenu **⚙️ Automações** (avulsas) + **⏱️ Temporizadores** (agendadas, `const SCHEDULE`/`SCHEDULE_SECONDS`, persistidas em `user://schedules.json`). Scripts: `alarme.gd`, `auto_alimentar.gd`, `comemoracao_hora_cheia.gd`, `desligar_pc.gd`, `cancelar_desligamento.gd`, `lembrete_pomodoro.gd`, `whatsapp.gd`, `email_gmail.gd`.
  - `Sistema - Moedas` — submenu **💱 Moedas** (`MENU_GROUP := "moedas"`, ícones de bandeira pixel `ICON_FLAG`), scripts `cotacao_usd/eur/gbp/jpy/cny.gd`.
  - `Sistema - E-mails` — submenu **📧 E-mails** (Gmail, contador de não lidos, alerta sonoro `🔊`).
  - API de automação: `run(zimmy)`, `zimmy.notify()` (fila ~5 s) vs `say()` (2,5 s). Base: `Automacoes/LEIAME.md` e README §Automations.
  - Seguir a convenção do cofre: criar **par PT + (EN)** de cada nota e **linká-las na [[Home]]** (seção 🧩 Sistemas). Verificar linhas de `zimmy.gd` antes de citar `arquivo:linha`.
  - **Feito quando:** todo submenu do README tem nota espelho no cofre e a Home aponta pra elas.
- [ ] **P1-2 · Atualizar contagem de clones/downloads** (regra global de portfólio). Hoje está **bloqueado**: `gh` não instalado (ver `contagem de downloads.txt`).
  - Fazer: `winget install --id GitHub.cli`, reabrir terminal, `gh auth login` (ou `winpty gh auth login` no Git Bash), depois `gh api repos/zimerfeld/ZIMMY/traffic/clones` e somar clones+downloads. Repetir para `GitExtensions.ZimerfeldTree`, `GitExtensions.ZimerfeldCommitMsg`, `ZIMARO`.
  - **Feito quando:** valor mais recente registrado ao lado de cada produto (e refletido onde o portfólio consome).
- [ ] **P1-3 · Exportar release `.exe`** (regra: build ao terminar). Confirmar que `build/` está em sincronia com o `zimmy.gd` atual. **Antes:** fechar `ZimmyPet.exe` e o editor Godot (senão o export trava no lock). Preset `Windows Desktop` já versionado em [[export_presets.cfg]]. Ver [[Build e Export]].

## 🟡 P2 — crescimento / quando sobrar
- [ ] **P2-1 · Divulgação bilíngue** (PT + EN, regra global) das features novas: **Temporizadores/Agendador**, **Moedas**, **E-mails/Gmail**, **Alarme**. Gerar as duas versões do texto.
- [ ] **P2-2 · Avaliar canais de distribuição** (mentalidade de investidor): publicar no **itch.io** e/ou página de release mais rica para ampliar alcance e clones. Avaliar esforço × retorno.
- [ ] **P2-3 · Ideias de produto** (validar antes): mais automações úteis (clima, agenda/calendário, lembretes recorrentes), sons opcionais, temas de pet sazonais. Anotar aqui as que valerem a pena antes de codar.

## 🔗 Ver também
[[Home]] · [[_Memória do Claude]] · [[Repositório e Branches]] · [[Build e Export]] · [[zimmy.gd]]
