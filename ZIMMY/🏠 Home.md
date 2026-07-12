---
tipo: moc
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-06
tags: [moc, home, zimmy-pet]
---

# 🏠 ZIMMY — Cofre de Neurônios

> 🇺🇸 Read this page in English → [[🏠 Home (EN)]]
> 🇪🇸 Lee esta página en español → [[🏠 Home (ES)]]

> [!abstract] 🧠 O que é este cofre
> Memória persistente do Claude para o projeto **ZIMMY (Zimmy Pet)**. Um *desktop pet*
> procedural em Godot 4 que também virou um assistente leve. Este cofre é mantido pelo
> Claude e **espelha o README** (fonte da verdade); ao mudar comportamento, atualiza-se a
> nota afetada e o README juntos.
> Fica em `C:\GODOT\ZIMMY\ZIMMY` — a pasta do cofre foi renomeada de `OBSIDIAN/` para o
> nome do projeto (`ZIMMY/`). Ver [[🧭 Como usar este cofre]].

## ⚡ Resumo executivo
- **O que é:** bichinho de desktop gratuito e **open source** para Windows — janela overlay
  transparente, sem bordas, sempre no topo; tudo **desenhado em código** (`_draw()` procedural,
  sem sprites), então cada pet é único.
- **Problema que resolve:** companhia fofa na tela + pequenas utilidades do dia a dia sem
  abrir apps pesados.
- **Diferenciais:** assistente leve embutido — agendador visual, cotações, clima, Gmail,
  alarme/lembretes; **extensível** (jogue um `.gd` em `Automacoes/`); **bilíngue** (PT/EN).
- **Stack:** Godot **4.6.2** stable, GDScript; app inteiro em [[📄 zimmy.gd]] anexado a
  [[📄 main.tscn]]. Sem dependências externas além da API do Godot.
- **Estado atual:** branch `develop`; último lote entregue — **reações ao mouse** (hover →
  expressão; clique no olho → fecha até sair; sacudir o mouse → tontura/enjoo/susto),
  **sons por grupo** (variações aleatórias em Alimentar/Carinho/Brincar), **fogos de
  artifício** na comemoração de hora cheia, e a **fila de fala** unificada (reações
  imediatas + notificações 10 s com furo de fila por ação do usuário e descarte após 60 s).
  Removida a automação auto-alimentar (20 s). Release `.exe` (~100 MB) exportável
  ([[🚀 Export e Publicação (Prod)]]).
- **Público:** entusiastas de pet virtual + quem quer "produtividade fofa" no desktop.
- **Ângulo de negócio:** grátis/OSS → retorno indireto (portfólio + topo de funil +
  doações/patrocínio). Ver [[💜 Financiamento e Patrocínio]] e [[🚀 Distribuição e Crescimento]].

## 🧭 Navegação por prioridade

### 1️⃣ 🔑 Impacto — Arquivos-Chave
> Arquivos que, se manipulados, têm grande impacto no sistema.
- [[📄 zimmy.gd]] — o app inteiro (~908 linhas úteis, `_draw()` procedural); mexer aqui muda tudo.
- [[📄 project.godot]] — config do overlay (transparência, borderless, always-on-top, renderer OpenGL).
- [[📄 main.tscn]] — cena raiz que instancia o `zimmy.gd`.
- [[📄 export_presets.cfg]] — preset do `.exe` (Windows Desktop, `embed_pck`, ícone, exclui `tools/*`).
- [[📄 tools - make_icon.py]] — gera `icon.png` + `zimmy.ico`.
- [[📄 Arquivo - README]] — documentação e **fonte da verdade** dos fatos do projeto.

### 2️⃣ 🧩 Reutilização — Sistemas
> Subsistemas reutilizados por várias partes do projeto.
- [[🪟 Sistema - Janela Overlay]] — a janela transparente/sem bordas/always-on-top e o `_relayout`.
- [[🎨 Sistema - Render (_draw)]] — desenho procedural do pet (sem sprites).
- [[✨ Sistema - Animação]] — respiração, piscar, pulo, seguir cursor.
- [[🐾 Sistema - Pets]] — config padrão/aleatória de cada pet.
- [[🎀 Sistema - Acessórios]] — acessórios sobre o pet.
- [[😶‍🌫️ Sistema - Expressões Faciais]] — rostos/expressões.
- [[😤 Sistema - Interação e Mau Humor]] — reação ao cutucar, humor.
- [[📊 Sistema - Necessidades]] — fome/humor ao longo do tempo.
- [[💬 Sistema - Balão de Fala]] — balão dinâmico de fala.
- [[🧭 Sistema - Menu de Contexto]] — o menu de clique-direito e seus submenus.
- [[⚙️ Sistema - Automações e Agendador]] — `Automacoes/`, ⚙️ Automações + ⏱️ Temporizadores.
- [[⏰ Sistema - Lembretes]] — submenu ⏰ Lembretes recorrentes do usuário.
- [[💱 Sistema - Moedas]] — cotações USD/EUR/GBP/JPY/CNY.
- [[📧 Sistema - E-mails]] — Gmail (contador de não lidos + som).
- [[💾 Sistema - Persistência]] — gravação/leitura de estado em `user://`.

### 3️⃣ 🔀 Uso — Fluxos
> Fluxos de uso passo a passo.
- [[🟢 Fluxo - Inicialização]] — `_ready`, reforço das flags do overlay.
- [[🔁 Fluxo - Loop (_process)]] — o loop por frame.
- [[🖱️ Fluxo - Arrastar e Posição]] — arrastar o pet e calcular posição.
- [[😼 Fluxo - Interação e Limites]] — cutucar e limites de tela.
- [[💾 Fluxo - Salvar e Carregar]] — persistir e restaurar.
- [[🎲 Fluxo - Geração Aleatória]] — pet/config aleatórios.

## 🚀 Operação
- [[💻 Rodar no Editor (Dev)]] — abrir/rodar no editor Godot (F5) durante o desenvolvimento.
- [[🚀 Export e Publicação (Prod)]] — export headless do `build/ZimmyPet.exe` + publicar.

## 🚪 Pontos de Entrada
> Como este é um overlay de desktop (não um servidor web), a superfície de interação são
> os eventos de input, os itens de menu e as funções de ação.
- [[🚪 Entrada - Eventos de Input]] — mouse/teclado.
- [[🚪 Entrada - Itens do Menu]] — as entradas do menu de contexto.
- [[🚪 Entrada - Funções de Ação]] — funções públicas acionadas pelo menu.

## 📚 Conhecimento
- [[📚 Repositório e Branches]] — repo, branches e fluxo GitFlow.
- [[🗂️ Glossário de Configs]] — glossário das chaves de configuração.

## 💼 Negócio
- [[🚀 Distribuição e Crescimento]] — canais e ideias de produto (viés de investidor).
- [[💜 Financiamento e Patrocínio]] — GitHub Sponsors `zimerfeld` + Ko-fi `C0D621FCGD` + badges.
- [[📈 Adoção e Métricas]] — contagem de clones/downloads.
- [[🎮 itch.io — Página]] — página pronta para colar (metadados + descrição bilíngue).
- [[📣 Divulgação — Posts]] — copy bilíngue pronta para publicar.

## 🧭 Meta
- [[🧭 Como usar este cofre]] — convenções, estrutura e manutenção do cofre.

## 📌 Retomada
- [[📌 Backlog]] — **comece por aqui** ao retomar o projeto em outra sessão.

## ⚖️ Licença
- **CC BY-NC-ND 4.0** (Creative Commons Atribuição-NãoComercial-SemDerivações 4.0 Internacional) · © 2026 Renato Zimerfeld — compartilhamento não comercial com atribuição; **sem uso comercial** e **sem derivações**. Fonte da verdade: `LICENSE.md` na raiz; nomeada nos READMEs (`README.md`, `README.en-US.md`, `README.pt-BR.md`). Nota histórica: o commit `1013cf8` removeu o LICENSE, que foi **readicionado** — o estado atual é CC BY-NC-ND 4.0.
