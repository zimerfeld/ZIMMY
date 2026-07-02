---
tags: [referencia, distribuicao, growth, estrategia, investimento, zimmy-pet]
atualizado: 2026-07-01
---

# 🚀 Distribuição e Crescimento

Análise com **viés de investidor** (potencial × viabilidade × retorno × risco) para ampliar a
adoção do Zimmy Pet. Hoje o único canal é o **GitHub** (repo + release). Métrica atual em
[[Adoção e Métricas]]; copy pronta em [[Divulgação — Posts]].

## 🎯 Tese
O Zimmy tem **baixo custo marginal de distribuição** (binário Windows único, ~100 MB, sem
servidor) e um **gancho viral** (é visualmente fofo e fica na tela o dia todo). O produto já
passou de "brinquedo" para "assistente leve" (agendador, cotações, Gmail, alarme), o que
**amplia o público-alvo** de "quem gosta de pet virtual" para "quem quer produtividade fofa".
O retorno não é receita direta (é grátis/open source) e sim **portfólio + doações + topo de
funil** para os outros produtos Zimerfeld.

## 📦 P2-2 · Canais de distribuição (esforço × retorno)
| Canal | Esforço | Retorno esperado | Risco | Veredito |
|---|---|---|---|---|
| **itch.io** | Baixo (subir o `.exe` + página + 2 GIFs) | **Alto** — SEO próprio, público de indie/desktop toys, comunidade de devlogs | Baixo | ✅ **Fazer primeiro** |
| **Microsoft Store** | Alto (empacotar MSIX, conta de dev paga, revisão) | Médio (alcance Windows nativo) | Médio (burocracia) | ⏳ Depois, se itch.io validar |
| **Reddit** (r/godot, r/DesktopPets, r/windows) | Baixo | Médio-Alto (picos de tráfego) | Baixo (regras de autopromo) | ✅ Junto com o lançamento |
| **Product Hunt** | Médio (dia único, precisa de tração inicial) | Médio | Baixo | ⏳ Guardar p/ um marco (v1.0) |
| **Vídeo curto** (YouTube Shorts/TikTok) | Médio (gravar + editar 20-40 s) | Alto (formato favorece "coisa fofa na tela") | Baixo | ✅ Alto ROI se der p/ produzir |

### Recomendação (ordem)
1. **itch.io** — maior ROI imediato; usar os GIFs das features e a copy de [[Divulgação — Posts]].
2. **Reddit + micro-posts** no mesmo dia (aproveitar o link do itch.io).
3. **Short em vídeo** mostrando o pet falando cotação / tocando alarme.
4. Microsoft Store e Product Hunt só depois de validar tração.

> **Definition of done do P2-2:** página no itch.io publicada com o `.exe` mais recente
> ([[Build e Export]]), 2+ GIFs e a descrição bilíngue; link adicionado ao README.

## 💡 P2-3 · Ideias de produto (validar antes de codar)
Ordenadas por **atratividade × esforço** (bang-for-buck no topo):
1. ✅ **Clima/tempo** — **implementado em 2026-07-01** (`Automacoes/clima.gd`): tempo atual via
   Open-Meteo (grátis/sem chave), geolocalização por IP com fallback (ipapi.co → ip-api.com) ou
   `LAT`/`LON` fixos; fala emoji + descrição bilíngue + temperatura localizada. Ver
   [[Sistema - Automações e Agendador]].
2. **Lembretes recorrentes personalizados** — o usuário cria um lembrete pelo menu (sem editar
   `.gd`). Transforma o agendador em feature de usuário final. *Alto apelo, médio esforço.* 🔥
3. **Sons/humor ambiente** — pequenos sons opcionais e reações por horário. *Médio/baixo.*
4. **Temas sazonais de pet** (Natal, Halloween…) — gancho de recorrência e divulgação. *Baixo.*
5. **Agenda/Calendário** (Google Calendar) — avisa próximo evento. *Alto apelo, alto esforço*
   (OAuth); avaliar depois do Gmail estar consolidado.
6. **Multi-pet na tela** ao mesmo tempo. *Médio; risco de escopo/perf.*

> Antes de implementar qualquer uma: registrar aqui a decisão (por quê / esforço estimado) e,
> se for mudança de comportamento, atualizar README + este cofre.

Relacionado: [[Divulgação — Posts]], [[Adoção e Métricas]], [[Build e Export]], [[Home]].
