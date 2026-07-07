---
tipo: backlog
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-07
tags: [meta, backlog, zimmy-pet]
---

# 🗂️ _Backlog priorizado

> Nota **autossuficiente** para retomar o projeto em qualquer chat novo.
> A regra global faz o Claude ler este cofre no início — então **comece por aqui** e
> depois pela [[🏠 Home]] e [[🧭 Como usar este cofre]].
> Convenção de prioridade: **P0** = fazer já / destrava o resto · **P1** = importante,
> próxima leva · **P2** = quando sobrar tempo / crescimento.

## 📸 Snapshot do estado (2026-07-07)
- **Repo:** https://github.com/zimerfeld/ZIMMY · **branch:** `develop` (`0ce994e`) · **`main`:** `6b65440` (em sincronia com o origin).
- **Últimas releases:** tags **`202607071044geracao-30s`** (geração 30s) e **`202607071024reacoes-e-fala`** (lote de reações/fala). **GitHub Release** publicada na tag de 30s com o `ZimmyPet.exe` anexado (Latest).
- **Engine:** Godot 4.6.2, GDScript. Código todo em [[📄 zimmy.gd]] (~4.215 linhas, `_draw()` procedural, sem sprites).
- **Árvore limpa** (à parte do churn de estado do Obsidian em `ZIMMY/.obsidian/*`, deixado fora dos commits de propósito).
- **Regras/memória relevantes:** exportar `.exe` como passo final ([[🚀 Export e Publicação (Prod)]]); fechar `ZimmyPet.exe` e o editor Godot antes de mexer no código; manter contagem de clones/downloads; GitFlow (feature → develop → release → main + tag).

## 🔴 P0 — destravar
- [x] **P0-1 · Commitar a reestruturação do cofre** (`OBSIDIAN/CLAUDE/` → `OBSIDIAN/`) — feito em 2026-07-01, commit `bdf60c6`: 62 renomeações (92–100%, histórico preservado) + `_Backlog.md`; `git status` limpo para `OBSIDIAN/`.
- [x] **P0-2 · Corrigir caminho obsoleto** — feito em 2026-07-01: `...\OBSIDIAN\CLAUDE` → `...\OBSIDIAN` em [[🧭 Como usar este cofre]] (PT/EN) e [[📚 Repositório e Branches]] (PT/EN).

## 🟠 P1 — próxima leva
- [x] **P1-1 · Fechar o buraco de documentação do cofre.** Feito em 2026-07-01: criadas [[⚙️ Sistema - Automações e Agendador]], [[💱 Sistema - Moedas]] e [[📧 Sistema - E-mails]] (par PT + (EN)), com refs `zimmy.gd:linha` verificadas e ligadas na [[🏠 Home]] (PT/EN). Detalhes originais abaixo, para referência:
  - `Sistema - Automações e Agendador` — pasta `Automacoes/`, submenu **⚙️ Automações** (avulsas) + **⏱️ Temporizadores** (agendadas, `const SCHEDULE`/`SCHEDULE_SECONDS`, persistidas em `user://schedules.json`). Scripts: `alarme.gd`, `comemoracao_hora_cheia.gd` (fogos via `celebrate()`), `desligar_pc.gd`, `cancelar_desligamento.gd`, `lembrete_pomodoro.gd`, `whatsapp.gd`, `email_gmail.gd`.
  - `Sistema - Moedas` — submenu **💱 Moedas** (`MENU_GROUP := "moedas"`, ícones de bandeira pixel `ICON_FLAG`), scripts `cotacao_usd/eur/gbp/jpy/cny.gd`.
  - `Sistema - E-mails` — submenu **📧 E-mails** (Gmail, contador de não lidos, alerta sonoro `🔊`).
  - API de automação: `run(zimmy)`, `zimmy.notify()` (fila ~5 s) vs `say()` (2,5 s). Base: `Automacoes/LEIAME.md` e README §Automations.
  - Seguir a convenção do cofre: criar **par PT + (EN)** de cada nota e **linká-las na [[🏠 Home]]** (seção 🧩 Sistemas). Verificar linhas de `zimmy.gd` antes de citar `arquivo:linha`.
  - **Feito quando:** todo submenu do README tem nota espelho no cofre e a Home aponta pra elas.
- [x] **P1-2 · Atualizar contagem de clones/downloads** — feito em 2026-07-01. `gh` já estava instalado **e autenticado** (não estava mais bloqueado). Snapshot (clones 14d): ZIMARO 790 · Tree 532 · ZIMMY 318 · CommitMsg 293 (downloads de release = 0 nos 4). Registrado em `contagem de downloads.txt` e em [[📈 Adoção e Métricas]] (PT/EN). **Nota:** clones é janela móvel de 14 dias (não acumulado); o total histórico/NuGet é responsabilidade do projeto zimerfeld.com.
- [x] **P1-3 · Exportar release `.exe`** — feito em 2026-07-01: `build/ZimmyPet.exe` (~100 MB) exportado via CLI headless do Godot 4.6.2 (preset `Windows Desktop`), **exit 0, sem erros/warnings**. Nenhuma instância estava aberta. `build/` é gitignored (o `.exe` não é versionado). Ver [[🚀 Export e Publicação (Prod)]].

## ✅ Feito recente
- [x] **Fix na landing page — quebra de linha de títulos/subtítulos em PT** — 2026-07-07: a landing page (`index.html`, publicada em **zimmy.zimerfeld.com** via GitHub Pages) usava a regra i18n `html[data-lang="pt"] .lang-pt{display:inline}`, que tornava **todo** elemento em português `inline` — incluindo `h2`/`h3` — fazendo título/subtítulo colarem no texto seguinte quando o site abre em PT (em EN funcionava, pois `h2`/`h3` já são `block` por padrão). **Correção de 1 linha de CSS:** `html[data-lang="pt"] h2.lang-pt,html[data-lang="pt"] h3.lang-pt{display:block}` — restaura a quebra apenas nos títulos/subtítulos em PT, sem afetar o EN. Publicado via GitFlow (`feature/pt-heading-break` → `develop` → release → `main`) + tag **`202607071915pt-heading-break`**; `CNAME` preservado; deploy confirmado ao vivo. `.obsidian/*` ficou fora do commit, como de praxe.
- [x] **Lote "Reações & fala" + geração 30s** — 2026-07-07 (2 releases nesta sessão):
  - **Reações ao mouse:** hover → expressão feliz/animada; **clicar num olho** → fecha até o cursor sair; **sacudir o mouse** rápido → animação + expressão aleatória de **tontura/enjoo/susto** (`react_expr`, `_trigger_shake`). Ver [[😶‍🌫️ Sistema - Expressões Faciais]] e [[✨ Sistema - Animação]].
  - **Sons por grupo:** Alimentar/Carinho/Brincar tocam variações aleatórias sorteadas dentro do grupo (`_build_*_sounds` + `_play_group`).
  - **Fogos de artifício** na comemoração de hora cheia (`zimmy.celebrate()` + `_draw_fireworks`); removida a automação `auto_alimentar.gd` (20s).
  - **Fila de fala unificada:** reações imediatas (`say`, ~2,5s) + fila de notificações (`notify`, 10s cada, sem sobrepor); ação do usuário **fura a fila** (`urgent_cd`/`_preempt_with`, cobre web assíncrona); item que espera **>60s é descartado**. Ver [[💬 Sistema - Balão de Fala]].
  - **`RANDOM_PERIOD` 10s → 30s** (geração aleatória de pet/acessório mais espaçada).
  - **Revertido a pedido do usuário:** a reorganização dinâmica de menus por uso (e o `preferences.json` + item "Restaurar padrões") — os menus voltaram a ser **estáticos**.
  - **Close-out:** docs sincronizados (3 READMEs + notas do cofre + `LEIAME.md`); `.exe` reexportado (100 MB, ícone via rcedit, smoke-test OK). GitFlow: 2 releases finalizadas em `main` + tags **`202607071024reacoes-e-fala`** e **`202607071044geracao-30s`** (com backmerge `main → develop`). **GitHub Release** criada na tag de 30s com o `ZimmyPet.exe` anexado (Latest).
  - **Métricas:** snapshot de adoção 2026-07-07 (ZIMARO 706 · Tree 432 · CommitMsg 305 · ZIMMY 257 clones/14d) em `contagem de downloads.txt` e [[📈 Adoção e Métricas]]. O `ZimmyPet.exe` é publicado em GitHub Release **desde 2026-06-25** (release `202606251217`); o *downloads* do ZIMMY = **acumulado all-time** do asset (hoje 0). Esse rastreio foi **automatizado no D1 do GitAdoptionMeter** — novo host `github-release`, ao vivo em `gitadoptionmeter.com/api/adoption` (campo `releaseDownloads`). Detalhes no backlog do projeto GitAdoptionMeter.
- [x] **Renomear o cofre `OBSIDIAN/` → `ZIMMY/`** — 2026-07-05: pasta do cofre renomeada para o nome do projeto. Referências atualizadas em `.claude/build-if-changed.ps1` (exclusão passou de `\OBSIDIAN\` para `\ZIMMY\ZIMMY\`, pois o projeto raiz também é `...\ZIMMY`), em [[🧭 Como usar este cofre]] (PT/EN, caminho `C:\GODOT\ZIMMY\ZIMMY`) e na árvore de [[📚 Repositório e Branches]] (PT/EN). O cofre global do usuário (`C:\Users\Renat\OBSIDIAN`) é outra coisa e não foi tocado.
- [x] **Feature Lembretes recorrentes do usuário** — 2026-07-02: submenu **⏰ Lembretes** nativo (sem editar `.gd`) — diálogo com mensagem + dropdown de frequência (15/30 min, 1 h, hourly, `daily@HH:MM`) + campo de hora; itens marcáveis (liga/desliga), excluir; persistido em `user://reminders.json`; disparo pelo mesmo relógio do agendador (parser `_parse_schedule_str` extraído e compartilhado). Compilado (`--check-only`), **testado em runtime** (18/18 asserts, incl. firing) e smoke test do app OK. Documentado em README (raiz+PT+EN) e [[⏰ Sistema - Lembretes]] (PT/EN). Era a ideia #2 de [[🚀 Distribuição e Crescimento]].
- [x] **Feature Clima** — 2026-07-01: `Automacoes/clima.gd` (Open-Meteo grátis/sem chave, geolocalização por IP com fallback, bilíngue). Sintaxe validada (`--check-only`) e **testada em runtime** (harness headless → "☀️ céu limpo — 21,2°C em Rio de Janeiro"). Documentado em README (raiz+PT+EN), LEIAME e [[⚙️ Sistema - Automações e Agendador]]. Foi a ideia #1 de [[🚀 Distribuição e Crescimento]].

## 🟡 P2 — crescimento / quando sobrar
- [x] **P2-1 · Divulgação bilíngue** — feito em 2026-07-01: copy PT+EN (anúncio curto, post longo e micro-posts por feature) em [[📣 Divulgação — Posts]]. Falta só **publicar** nos canais.
- [~] **P2-2 · Avaliar canais de distribuição** — análise feita em [[🚀 Distribuição e Crescimento]] (itch.io = maior ROI → depois Reddit/vídeo → Store/Product Hunt). Descrição da página **pronta para colar** em [[🎮 itch.io — Página]] (metadados + EN/PT + checklist de mídia). **Pendente a execução (depende do usuário):** criar a conta/página no itch.io, subir o `.exe` e os GIFs.
- [x] **P2-3 · Ideias de produto** — priorizadas por atratividade × esforço em [[🚀 Distribuição e Crescimento]] (topo: clima 🔥 e lembretes recorrentes do usuário 🔥). Validar antes de codar.

## 🔗 Ver também
[[🏠 Home]] · [[🧭 Como usar este cofre]] · [[📚 Repositório e Branches]] · [[🚀 Export e Publicação (Prod)]] · [[📄 zimmy.gd]]
