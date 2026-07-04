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
- [x] **P1-2 · Atualizar contagem de clones/downloads** — feito em 2026-07-01. `gh` já estava instalado **e autenticado** (não estava mais bloqueado). Snapshot (clones 14d): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293 (downloads de release = 0 nos 4). Registrado em `contagem de downloads.txt` e em [[Adoção e Métricas]] (PT/EN). **Nota:** clones é janela móvel de 14 dias (não acumulado); o total histórico/NuGet é responsabilidade do projeto zimerfeld.com.
- [x] **P1-3 · Exportar release `.exe`** — feito em 2026-07-01: `build/ZimmyPet.exe` (~100 MB) exportado via CLI headless do Godot 4.6.2 (preset `Windows Desktop`), **exit 0, sem erros/warnings**. Nenhuma instância estava aberta. `build/` é gitignored (o `.exe` não é versionado). Ver [[Build e Export]].

## ✅ Feito recente
- [x] **Feature Lembretes recorrentes do usuário** — 2026-07-02: submenu **⏰ Lembretes** nativo (sem editar `.gd`) — diálogo com mensagem + dropdown de frequência (15/30 min, 1 h, hourly, `daily@HH:MM`) + campo de hora; itens marcáveis (liga/desliga), excluir; persistido em `user://reminders.json`; disparo pelo mesmo relógio do agendador (parser `_parse_schedule_str` extraído e compartilhado). Compilado (`--check-only`), **testado em runtime** (18/18 asserts, incl. firing) e smoke test do app OK. Documentado em README (raiz+PT+EN) e [[Sistema - Lembretes]] (PT/EN). Era a ideia #2 de [[Distribuição e Crescimento]].
- [x] **Feature Clima** — 2026-07-01: `Automacoes/clima.gd` (Open-Meteo grátis/sem chave, geolocalização por IP com fallback, bilíngue). Sintaxe validada (`--check-only`) e **testada em runtime** (harness headless → "☀️ céu limpo — 21,2°C em Rio de Janeiro"). Documentado em README (raiz+PT+EN), LEIAME e [[Sistema - Automações e Agendador]]. Foi a ideia #1 de [[Distribuição e Crescimento]].

## 🟡 P2 — crescimento / quando sobrar
- [x] **P2-1 · Divulgação bilíngue** — feito em 2026-07-01: copy PT+EN (anúncio curto, post longo e micro-posts por feature) em [[Divulgação — Posts]]. Falta só **publicar** nos canais.
- [~] **P2-2 · Avaliar canais de distribuição** — análise feita em [[Distribuição e Crescimento]] (itch.io = maior ROI → depois Reddit/vídeo → Store/Product Hunt). Descrição da página **pronta para colar** em [[itch.io — Página]] (metadados + EN/PT + checklist de mídia). **Pendente a execução (depende do usuário):** criar a conta/página no itch.io, subir o `.exe` e os GIFs.
- [x] **P2-3 · Ideias de produto** — priorizadas por atratividade × esforço em [[Distribuição e Crescimento]] (topo: clima 🔥 e lembretes recorrentes do usuário 🔥). Validar antes de codar.

## 🔗 Ver também
[[Home]] · [[_Memória do Claude]] · [[Repositório e Branches]] · [[Build e Export]] · [[zimmy.gd]]
