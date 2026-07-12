---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, necessidades, gameplay, zimmy-pet]
---

# 📊 Sistema - Necessidades (Alimentar/Carinho/Brincar)

> 🇪🇸 Lee esta página en español → [[📊 Sistema - Necessidades (ES)]]

Três necessidades estilo tamagotchi, mostradas como **barras sutis no rodapé** do pet.
Estado em `stat_feed` / `stat_pet` / `stat_play` (0..100, `STAT_MAX=100`). **Não são
persistidas**: começam cheias (100%) a cada abertura.

## 📊 Barras — `_draw_stat_bars()`
Desenhadas num **rodapé reservado abaixo do pet** (`STATUS_FOOTER=58px`, adicionado ao
`win_h` em `_relayout` só quando `show_status`). O `_draw_stat_bars()` reseta o transform
para **identidade** (px reais — não escala com `PET_SCALE` nem com o `y_off` do pulo) e empilha 3
linhas (`row_h=16`, barra `bh=8`): trilho `Color(0,0,0,0.18)` + preenchimento colorido com
largura = `bw * stat/100` (sem números). O conjunto **ícone+barra tem a largura do pet**
(`PET_DRAW`) e fica **centralizado sob ele** (a partir de `pet_x`) — **não estica** com o
balão de fala. Cada barra tem o **ícone do menu à esquerda**
(🦴/🤚/🎾, `icon_fs=17` ≈ 2× o anterior) via `draw_string` com `speech.get_theme_font("font")`:
- Alimentar → `COL_FEED` (branco), Carinho → `COL_PET` (amarelo), Brincar → `COL_PLAY` (rosa avermelhado).
O pet fica **ancorado pelo centro-inferior** (o rodapé cresce para baixo, sem mover o pet).
Só com `show_status` (checkbox **📊 Status**, acima de Alimentar; **OFF por padrão**,
persistido em settings.json `status` via `_set_show_status` → `_relayout`). Ver
[[🎨 Sistema - Render (_draw)]] e [[🧭 Sistema - Menu de Contexto]].

## 📉 Decaimento e fechamento — `_process`
A cada `STAT_DECAY_PERIOD = 1800s` (30 min) cada barra perde **1 ponto**
(`stat_decay_timer`). Fazer a ação correspondente reabastece **só aquela** barra para 100
(`feed()`/`pet()`/`play()` em [[🚪 Entrada - Funções de Ação]]). Quando **as três** zeram,
`get_tree().quit()` **fecha a janela e encerra o processo**.

**Alerta sonoro de necessidade baixa**: ainda no decaimento, quando uma barra **cruza
`STAT_LOW = 20` para baixo** (só na **transição** — guarda o valor anterior e compara, então
toca uma vez por cruzamento, não a cada ciclo abaixo do limite), o Zimmy toca o som daquela
ação (`_feed_player`/`_pet_player`/`_play_player`), desde que o toggle correspondente esteja
ligado (`sound_feed_on`/`sound_pet_on`/`sound_play_on`). É **o mesmo som** tocado ao executar
a ação; o submenu **🔊 Alertas de som** (`MI_SOUNDS`) controla os dois gatilhos. Ver
[[🧭 Sistema - Menu de Contexto]] e [[🚪 Entrada - Funções de Ação]].

## 😖 Rosto de necessidade — `_need_expression()`
Sem fala, se uma barra está em 0 o rosto muda (prioridade fome > carente > entediado),
via `_draw_expression` ([[😶‍🌫️ Sistema - Expressões Faciais]]):
- `stat_feed=0` → **hungry**: cara de fome, **boca bem aberta** + línguinha.
- `stat_pet=0` → **needy**: cara de necessitado, **chorando** (duas lágrimas) + boca triste.
- `stat_play=0` → **bored**: cara de chateado, **olhos fechados** (—) + boca reta.

> A fala (emoji emotivo) ainda tem prioridade sobre o rosto de necessidade.

Relacionado: [[😤 Sistema - Interação e Mau Humor]], [[🔁 Fluxo - Loop (_process)]].
