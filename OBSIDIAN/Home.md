---
tags: [moc, zimmy-pet]
aliases: [Início, MOC, Mapa]
atualizado: 2026-06-21
---

# 🧡 Zimmy Pet — Cofre de Neurônios

> Memória técnica do projeto **Zimmy Pet**, mantida pelo Claude.
> Repositório: https://github.com/zimerfeld/ZIMMY
> Código-fonte principal: [[zimmy.gd]] (Godot 4.6, GDScript).

Desktop pet overlay: uma janela transparente, sem bordas e sempre no topo, com uma
carinha procedural (a "Zimmy") que respira, pisca, pula, segue o cursor e reage a
interações. Tudo é desenhado em código (`_draw()`), sem sprites.

## 💜 Financiamento / Patrocínio
Canais de doação configurados no repositório (badges no topo do README + botão **Sponsor**):
- **GitHub Sponsors:** [zimerfeld](https://github.com/sponsors/zimerfeld) · **Ko-fi:** [C0D621FCGD ☕](https://ko-fi.com/C0D621FCGD)
- **`.github/FUNDING.yml`:** criado com `github: zimerfeld` e `ko_fi: C0D621FCGD`.
- **Prova social no README:** badges de **stars** e **downloads de releases** do GitHub (`shields.io/github/stars` e `/downloads/.../total`) + frase curta de "por que doar" (mantido no tempo livre). Como o projeto não vai pro NuGet, a métrica pública é o GitHub (não há badge de pacote).

## 🧠 Como usar este cofre
Veja [[_Memória do Claude]] para a convenção de notas, links e atualização.

## 🗂️ Retomar o projeto
Comece por [[_Backlog]] — backlog priorizado e autossuficiente (P0/P1/P2) para continuar em qualquer chat novo.

## 🧩 Sistemas
- [[Sistema - Janela Overlay]] — transparência, always-on-top, layout dinâmico
- [[Sistema - Pets]] — config, geração procedural, formas e elementos
- [[Sistema - Acessórios]] — camada independente (chapéu/óculos/laço/cachecol)
- [[Sistema - Render (_draw)]] — pipeline de desenho e primitivas
- [[Sistema - Animação]] — respiração, piscada, pulo, olhos
- [[Sistema - Expressões Faciais]] — rosto espelha o emoji falado
- [[Sistema - Balão de Fala]] — `say()` + `_relayout()`
- [[Sistema - Interação e Mau Humor]] — cooldown, limite de repetição, reclamações
- [[Sistema - Necessidades]] — barras Alimentar/Carinho/Brincar, decaimento, fechamento
- [[Sistema - Persistência]] — `user://` JSON (pets, acessórios, posição)
- [[Sistema - Menu de Contexto]] — PopupMenu, submenus, diálogos
- [[Sistema - Automações e Agendador]] — pasta `Automacoes/`, ⚙️ Automações + ⏱️ Temporizadores
- [[Sistema - Moedas]] — submenu 💱 Moedas, cotações (`cotacao_*.gd`)
- [[Sistema - E-mails]] — submenu 📧 E-mails (Gmail) + 💬 WhatsApp, badge e som

## 🔀 Fluxos
- [[Fluxo - Inicialização]] (`_ready`)
- [[Fluxo - Loop (_process)]]
- [[Fluxo - Arrastar e Posição]]
- [[Fluxo - Geração Aleatória]]
- [[Fluxo - Salvar e Carregar]]
- [[Fluxo - Interação e Limites]]

## 🚪 Pontos de Entrada (endpoints)
- [[Entrada - Eventos de Input]] — mouse/teclado
- [[Entrada - Itens do Menu]] — ids `MI_*`
- [[Entrada - Funções de Ação]] — `feed/pet/play/_react`

## 📄 Arquivos-Chave
- [[zimmy.gd]] · [[project.godot]] · [[main.tscn]] · [[export_presets.cfg]]
- [[tools - make_icon.py]] · [[Arquivo - README]]

## 📚 Referências
- [[Repositório e Branches]] · [[Build e Export]] · [[Glossário de Configs]] · [[Adoção e Métricas]]
- [[Divulgação — Posts]] · [[Distribuição e Crescimento]] — growth (posts bilíngues, canais, ideias)
