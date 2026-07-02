# Zimmy Pet 🧡

<p align="center">
  <img src="icon.png" alt="Zimmy — o pet Default" width="180">
</p>

<p align="center">
  <a href="https://github.com/sponsors/zimerfeld"><img src="https://img.shields.io/badge/Sponsor-zimerfeld-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white" alt="GitHub Sponsor"></a>
  &nbsp;&nbsp;
  <a href="https://ko-fi.com/C0D621FCGD"><img src="https://img.shields.io/badge/Ko--fi-Buy%20me%20a%20coffee-FF5E2B?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Ko-fi"></a>
</p>

<p align="center">
  <a href="https://github.com/zimerfeld/ZIMMY/stargazers"><img src="https://img.shields.io/github/stars/zimerfeld/ZIMMY?style=for-the-badge&logo=github" alt="GitHub stars"></a>
  &nbsp;
  <a href="https://github.com/zimerfeld/ZIMMY/releases"><img src="https://img.shields.io/github/downloads/zimerfeld/ZIMMY/total?style=for-the-badge&logo=github&label=Downloads" alt="GitHub downloads"></a>
</p>

> O Zimmy é construído e mantido no meu tempo livre. Se este petzinho de desktop te arranca um sorriso, um patrocínio ajuda a mantê-lo atualizado. 💜

> O pet Default (a carinha procedural do `_draw()`, o mesmo desenho usado no ícone).

Desktop pet overlay, feito em Godot 4.6.
Uma janela transparente, sem bordas e sempre no topo que flutua sobre a área de trabalho.
O pet é desenhado num espaço lógico de **200×200** e exibido a **75%** (≈150 px,
`PET_SCALE`). A janela reserva uma faixa transparente acima do pet (`HOP_HEADROOM`) para o
**pulinho** (ao alimentar/fazer carinho/brincar) não ser cortado, e cresce dinamicamente
quando o Zimmy fala. O pet fica **ancorado pelo centro-inferior**: um balão de fala grande
que exceda a janela pode transbordar para a borda da tela, mas **nunca desloca o pet**.

## Como rodar

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe" --path "C:\GODOT\ZIMMY"
```

Ou abra a pasta no Godot e pressione **F5**.

## Ícone

O ícone do Zimmy é gerado proceduralmente (a mesma carinha do `_draw()`) por
`tools/make_icon.py` (precisa de Python + Pillow):

```powershell
py tools/make_icon.py
```

Gera dois arquivos do mesmo desenho, para usos diferentes:

- **`icon.png`** — ícone do **Godot** (editor + janela/taskbar do app). Definido em
  `project.godot` (`config/icon`). O Godot usa PNG, não aceita `.ico` aqui.
- **`zimmy.ico`** — ícone do **executável Windows** (formato `.ico` multi-size 16→256).
  Usado pelo preset de export e embutido no `.exe` via `rcedit`.

## Gerar o .exe (Windows)

Pré-requisitos: **export templates** do Godot 4.6.2 instalados e o preset
`Windows Desktop` (já versionado em `export_presets.cfg`, apontando `zimmy.ico`).

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```

O executável (standalone, com o `.pck` embutido) é gerado em
**`build/ZimmyPet.exe`**.

Para embutir o ícone Zimmy no próprio `.exe` (caso o `rcedit` não esteja
configurado no editor), rode depois:

```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## Controles

| Ação | Resultado |
|------|-----------|
| Arrastar (botão esquerdo) | Move o Zimmy pela tela (a posição é salva) |
| Clique (sem arrastar) | Ele reage com um "oi" |
| Botão direito | Abre o menu de contexto (abaixo), posicionado ao lado do pet sem cobri-lo e sempre dentro da tela |
| Esc | Fecha |

> **Posição na tela:** na primeira execução o Zimmy abre **centralizado**. Depois,
> sempre que você o arrasta a posição é gravada em `user://settings.json` e ele
> reabre no **último lugar** onde ficou. Esse mesmo arquivo também guarda a **última
> escolha de pet e acessório**, restaurada automaticamente ao reabrir.

### Menu de contexto

> Ao clicar com o **botão direito**, o menu aparece **ao lado do pet** (tenta direita →
> esquerda → abaixo → acima), de forma a **não cobrir o pet** e **não ultrapassar as
> bordas da tela**. Se nenhum lado couber, ele é encaixado dentro da área visível.

- **📊 Status** (check) — liga/desliga as **barras de status** abaixo do pet
  (Alimentar/Carinho/Brincar). Vem **desligado** por padrão; a escolha é **persistida** em
  `user://settings.json` (chave `status`).
- **🦴 Alimentar / 🤚 Carinho / 🎾 Brincar** — interações que mudam humor/fome. Cada uma também toca um **som próprio** (uma mordidinha, um ronron, um arpejo alegre) quando o alerta daquela ação está ligado.
- **🔊 Alertas de som ▸** — submenu logo abaixo das ações, com uma **caixa por ação** (🦴 Alimentar / 🤚 Carinho / 🎾 Brincar, todas **ligadas** por padrão, **persistidas** em `user://settings.json`). Cada toggle governa **dois** gatilhos: o som tocado ao fazer a ação **e** um lembrete que toca quando a barra daquela necessidade **cai para 20% (baixa)**. Os sons são sintetizados em código (sem arquivos de áudio), como os alertas de WhatsApp/Gmail.
- **🐶 Gerar pets** (check) — liga/desliga a geração contínua **do pet**: a cada ~10 s o
  Zimmy vira um pet aleatório. Além das cores, varia as **formas** e quais
  **elementos** o compõem (orelhas redondas ou pontudas, antenas, nariz, cílios,
  bochechas e o estilo da boca). Cada novo pet ganha uma **frase de boas-vindas e um
  nome sugestivo** — esse nome já vem **pré-preenchido** (selecionado) na caixa de texto
  ao Salvar ou Renomear. Os nomes são **combinatórios** (substantivo + adjetivo, ~900
  combinações por idioma), então quase nunca repetem.
- **🎲 Gerar acessórios** (check) — independente do anterior: liga/desliga a geração
  contínua **dos acessórios** (a cada ~10 s sorteia chapéu/óculos/laço/cachecol). Ligar
  também liga automaticamente a exibição de acessórios. Cada novo acessório ganha uma
  **frase de parabenização e um nome sugestivo** que pré-preenche a caixa de texto ao
  Salvar ou Renomear (também **combinatório**, ~900 combinações por idioma).
- **👓 Mostrar acessórios** (check) — liga/desliga a exibição da camada de
  acessórios (chapéu, óculos, laço, cachecol), independentemente do pet.
- **💾 Salvar Pet…** — abre um diálogo para nomear e salvar **só o pet** exibido.
  Abrir o diálogo **congela a geração de pets** (desmarca "🐶 Gerar pets") para que se
  salve exatamente o que está na tela; ao **confirmar**, a checkbox "🐶 Gerar pets"
  fica desmarcada. A geração de acessórios não é afetada. **Se o pet exibido já é um
  pet salvo, este item vira
  "💾 Renomear Pet…"** (mesmo ícone): o diálogo abre com o nome atual pré-preenchido e,
  ao confirmar, o pet é **renomeado** — a mudança é gravada no `pets.json` e o dropdown
  "Escolher pet" é atualizado na hora.
- **📂 Escolher pet ▸** — dropdown para trocar o pet exibido. Sempre tem
  `Selecione...` (índice 0, só rótulo) e `Default` (índice 1) no topo, seguidos dos
  pets salvos. A **opção ativa fica realçada** (marcada com ✓) para você ver de
  relance qual pet está em uso; com a geração aleatória ligada, nenhuma fica marcada.
  Escolher um pet específico desliga a geração aleatória.
- **🗑️ Excluir pet ▸** — submenu que lista **só os pets salvos** (o `Default` e o
  `Selecione...` nunca aparecem, são intocáveis). Clicar pede confirmação e então
  **apaga o pet permanentemente** do `pets.json`. Após excluir, o Zimmy **recarrega
  sempre o `Default`**. Sem pets salvos, mostra "(nenhum pet salvo)".
- **🎀 Salvar Acessório…** — abre um diálogo para nomear e salvar **só o acessório**
  atual (independente do pet). Abrir **congela a geração de acessórios** e, ao
  **confirmar**, a checkbox "🎲 Gerar acessórios" fica desmarcada (a geração de pets
  não é afetada). **Se o acessório exibido já está salvo, este item vira
  "🎀 Renomear Acessório…"** (mesmo
  ícone): o diálogo abre com o nome atual e, ao confirmar, o acessório é **renomeado**,
  gravado no `accessories.json` e atualizado no dropdown "Escolher acessório".
- **🧳 Escolher acessório ▸** — dropdown independente para trocar o acessório. Tem
  `Selecione...` (só rótulo) e `Nenhum` (limpa os acessórios) no topo, seguidos dos
  acessórios salvos. A **opção ativa fica realçada** (marcada com ✓); com a geração
  aleatória de acessórios ligada, nenhuma fica marcada. Escolher um acessório liga a
  exibição e desliga o aleatório.
- **🗑️ Excluir acessório ▸** — submenu que lista **só os acessórios salvos** (o
  `Nenhum` e o `Selecione...` nunca aparecem, são intocáveis). Clicar pede confirmação
  e então **apaga o acessório permanentemente** do `accessories.json`. Após excluir, o
  Zimmy **volta sempre a `Nenhum`** (o Default). Sem acessórios salvos, mostra
  "(nenhum acessório salvo)".
- **⚙️ Automações ▸** — submenu com as automações **avulsas** disponíveis (scripts da
  pasta `Automacoes/` que executam uma vez ao clicar), cada uma com um **ícone ▶ play**
  verde à esquerda. Fica **desabilitado** quando não há automações avulsas. As automações
  **agendadas** agora ficam em **⏱️ Temporizadores** (abaixo). Ver **Automações** abaixo.
- **⏱️ Temporizadores ▸** — submenu próprio **logo abaixo de ⚙️ Automações**, contendo as
  automações **agendadas** (as que declaram `const SCHEDULE`/`SCHEDULE_SECONDS`) como
  itens **marcáveis** (✓ = ligada), cada uma com um pequeno **ícone de relógio** à
  esquerda e a **frequência no rótulo** — é o **agendador visual**, persistido em
  `user://schedules.json`. Exemplos: `alarme.gd` (daily@08:00), `auto_alimentar.gd` (20s),
  `comemoracao_hora_cheia.gd` (hourly), `desligar_pc.gd` (daily@23:00),
  `lembrete_pomodoro.gd` (25m). Fica **desabilitado** quando não há automações agendadas.
- **💱 Moedas ▸** — submenu próprio no menu principal, **abaixo de ⚙️ Automações / ⏱️ Temporizadores**,
  agrupando as cotações de moeda (`MENU_GROUP := "moedas"`). Cada item mostra uma **bandeirinha
  (ícone) à esquerda** — uma textura desenhada em pixel (`ICON_FLAG := "us"/"eu"/"gb"/"jp"/"cn"`),
  pois emojis de bandeira não são renderizados no `PopupMenu`. Fica **desabilitado** quando não há cotações.
- **📝 Notas ▸** — um bloquinho de notas de texto. **➕ Nova nota...** abre um campo
  multilinha para digitar; **📋 Colar da área de transferência** transforma o texto
  atual da área de transferência numa nota. As notas salvas aparecem na lista — **clicar
  numa copia o texto de volta para a área de transferência**; **🗑️ Excluir nota ▸**
  remove. No menu cada nota aparece como prévia de uma linha **truncada em 30 caracteres
  com "..."** quando maior. As notas persistem em `user://notes.json`. Ver **Notas** abaixo.
- **📧 E-mails ▸** — submenu dedicado ao provedor de e-mail (Gmail), com o **ícone à
  esquerda** e o **contador de não lidos** no rótulo. No topo, uma caixa **🔊 Alerta de som**
  liga/desliga um som baixo de entrega de correio que toca quando chega um e-mail **novo**.
  Fica **desabilitado** se não houver automações de e-mail. Ver **E-mails** abaixo.
- **💬 WhatsApp ▸** — mostra o número de **conversas não lidas do WhatsApp** como badge.
  No topo, uma caixa **🔊 Alerta de som** liga/desliga um som baixo de telefone tocando
  que toca quando chega uma conversa **nova**.
  **Não** faz login no WhatsApp (não há API; a sessão fica presa ao navegador) — apenas
  **lê o título da janela do WhatsApp Web** que o seu navegador mantém aberto (vira
  "(N) WhatsApp" quando há não lidas). Mantenha o **WhatsApp Web aberto e vinculado**.
  Ver **WhatsApp** abaixo.
- **🌐 Idioma ▸** — escolhe o idioma de **todos os textos do sistema** (menu, diálogos e
  as falas do pet) entre **Português (Brasil)** e **English (US)**. A troca é imediata e
  a opção fica marcada (✓). Ver **Idioma** abaixo.
- **❤️ Doação ▸** — submenu com dois jeitos de apoiar o projeto: **GitHub Sponsors** e
  **Ko-fi**. Cada um abre o link no navegador (`OS.shell_open`).
- **Sair**.

## Necessidades (barras de status)

Três **barrinhas coloridas** abaixo do pet mostram as necessidades de **Alimentar /
Carinho / Brincar** (branco / amarelo / rosa), cada uma com o **ícone do menu à esquerda**
(🦴 / 🤚 / 🎾) e de 0 a 100% — só o preenchimento colorido, sem números. Só aparecem com
**📊 Status** ligado (desligado por padrão, persistido). Os valores começam **cheios
(100%)** a cada abertura e **não** são persistidos.

Cada barra **perde 1 ponto a cada 30 minutos**; fazer a ação correspondente
(Alimentar/Carinho/Brincar) reabastece a barra para 100%. Quando uma barra chega a **0**,
o pet faz uma cara: **Alimentar = fome, boca aberta**; **Carinho = necessitado, chorando**;
**Brincar = chateado, olhos fechados**. Quando **as três** chegam a 0, o Zimmy **fecha a
própria janela e encerra o processo**. Com o **🔊 Alerta de som** daquela ação ligado, um som de lembrete também toca no instante em que a barra **cruza 20%** para baixo (uma vez por cruzamento).

## Idioma

Todos os textos do sistema têm tradução em **Português (Brasil)** e **English (US)**:
os itens do menu de contexto, os diálogos (salvar/renomear/excluir/login) e as **falas
do pet** (saudação, reações de alimentar/carinho/brincar, mau humor, avisos). Escolha o
idioma em **🌐 Idioma ▸**; a interface inteira muda na hora e a escolha é **persistida**
em `user://settings.json` (chave `lang`), voltando no mesmo idioma na próxima abertura.
As automações da pasta `Automacoes/` mantêm os textos definidos por cada script.

## Notas

O submenu **📝 Notas ▸** é um bloquinho de texto para lembretes e trechos rápidos.
Crie uma nota de dois jeitos: **➕ Nova nota...** abre um diálogo multilinha para
digitar, ou **📋 Colar da área de transferência** transforma o que estiver na área de
transferência numa nota. Cada nota salva aparece na lista (prévia reduzida a uma linha);
**clicar numa nota copia o texto completo de volta para a área de transferência**, pronto
para colar em qualquer lugar. Remova notas em **🗑️ Excluir nota ▸**. Tudo é **persistido**
em `user://notes.json` (uma lista simples de strings), então as notas sobrevivem a reinícios.

## Automações

Automações são scripts `.gd` colocados na pasta **`Automacoes/`** (na raiz do
projeto). Aparecem no menu de contexto em **⚙️ Automações** (as **avulsas**, com ícone
▶ play) ou **⏱️ Temporizadores** (as **agendadas**, com ícone de relógio) — os submenus
são **reescaneados toda vez que o menu abre**, então scripts novos aparecem sem reiniciar.
Sem nenhum script válido de um tipo, o item de menu correspondente fica desabilitado.

Cada automação é um GDScript com:

- (opcional) `const AUTOMATION_NAME := "Nome no menu"` — texto exibido no submenu. Sem
  ele, o nome é derivado do arquivo (`minha_automacao.gd` → "Minha Automacao").
- (opcional) `const AUTOMATION_NAME_EN := "Menu name"` — nome em inglês, usado quando o
  idioma do app é English (US); sem ele, cai no `AUTOMATION_NAME`. Para falas bilíngues
  use `zimmy.lang_text(pt, en)` e `zimmy.lang`; para números/datas localizados use
  `zimmy.fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (as automações de
  cotação usam esses helpers, então valores e datas seguem o idioma escolhido).
- (opcional) `const SCHEDULE := "..."` — frequência para o Zimmy rodar a automação
  sozinho (ver **Agendador** abaixo).
- um método `run(zimmy)` — chamado ao escolher o item (ou no disparo agendado). `zimmy`
  é o nó principal, dando acesso a `notify()`, `say()`, `feed()`, `pet()`, `play()`,
  `hop()`, `current`, e ao estado (`hunger`, `happy`), etc. As mensagens de automação/
  e-mail devem usar **`zimmy.notify(texto)`**: entram numa **fila, aparecem uma de cada
  vez e ficam visíveis ~5 s** para não se sobreporem (`say()` mostra na hora e some em
  2,5 s, sem fila).

Scripts que `extends RefCounted` são descartados após o `run()`; os que `extends Node`
são adicionados como filhos do Zimmy e **persistem** (úteis para automações contínuas
via `_process`/timers). Veja `Automacoes/LEIAME.md` e
`Automacoes/exemplo_automacao.gd.example` (renomeie para `.gd` para ativar) para os
modelos.

### Agendador (frequência / recorrência)

Uma automação que declara `const SCHEDULE` roda **sozinha** na frequência indicada,
sem precisar clicar. Ela aparece no submenu **⏱️ Temporizadores** como um item **marcável**
(✓ = ligada) com um ícone de relógio e o intervalo no rótulo — esse é o **agendador visual**. Ligar/desligar
é **persistente**: o que estava ligado volta a rodar ao reabrir o Zimmy (estado em
`user://schedules.json`). Formatos de `SCHEDULE`: `"30s"`/`"5m"`/`"2h"` (a cada N),
`"hourly"` (toda hora cheia, no minuto :00), `"daily@09:00"` (1×/dia no horário); ou
`const SCHEDULE_SECONDS := 300` (segundos). Para agendadas, o agendador cuida da
recorrência — o `run()` faz a ação **uma vez** (use `extends RefCounted`).

### Automações web (`http_get_json`)

Automações podem buscar dados da internet com o utilitário `zimmy.http_get_json(url, cb)`
— ele faz um GET e chama `cb.call(ok, data)` com o JSON decodificado, cuidando do
`HTTPRequest` por baixo. Na *closure* use só `zimmy` e variáveis locais (não `self`),
para funcionar tanto no clique quanto no disparo agendado.

### Exemplos prontos (`Automacoes/`)

| Automação | Arquivo | Tipo |
|---|---|---|
| Auto-alimentar 🦴 | `auto_alimentar.gd` | a cada 20s — alimenta se com fome |
| Lembrete Pomodoro ☕ | `lembrete_pomodoro.gd` | a cada 25min — lembra de pausar |
| Comemorar hora cheia 🎉 | `comemoracao_hora_cheia.gd` | `hourly` — comemora cada virada de hora |
| Cotação USD/EUR/GBP/JPY/CNY 💱 | `cotacao_*.gd` | avulsas — cotação da moeda em BRL ([AwesomeAPI](https://docs.awesomeapi.com.br/), grátis). As 5 moedas de maior influência (cesta SDR) ficam agrupadas no submenu **💱 Moedas** no menu principal (`MENU_GROUP := "moedas"`), cada item com uma **bandeirinha (ícone) à esquerda** (textura de `ICON_FLAG`) |
| Clima 🌤️ | `clima.gd` | avulsa — tempo atual via [Open-Meteo](https://open-meteo.com/) (grátis, sem chave); detecta a localização pelo IP (fallback ipapi.co → ip-api.com) ou defina `LAT`/`LON` para fixar sua cidade |
| Desligar PC 🔌 | `desligar_pc.gd` | `daily@23:00` — desliga o Windows com 60s de aviso |
| Cancelar desligamento ❌ | `cancelar_desligamento.gd` | avulsa — aborta o desligamento (`shutdown /a`) |
| Alarme ⏰ | `alarme.gd` | `daily@08:00` — avisa e dá um bipe |
| Gmail 📧 | `email_gmail.gd` | a cada 5min — conta e-mails não lidos pelo **feed Atom** (`mail/feed/atom`, HTTP Basic + App Password); aparece no submenu **📧 E-mails** |
| WhatsApp 💬 | `whatsapp.gd` | a cada 1min — conta conversas não lidas **lendo o título da janela do WhatsApp Web** (`tasklist`), sem API/login; aparece no submenu **💬 WhatsApp** |

> **Atenção (desligar PC):** `desligar_pc.gd` executa `shutdown` de verdade. Vem
> **desligado** por padrão e dá 60s de aviso; para abortar, rode "Cancelar desligamento".

### E-mails (submenu 📧 E-mails) — contador de não lidos

Automações que declaram `const MENU_GROUP := "email"` aparecem num submenu dedicado
**📧 E-mails**, com o **ícone do provedor à esquerda** (cor de `ICON_COLOR`) e o
**contador de não lidos no rótulo**, atualizado a cada 5 min. O **Gmail**
(`email_gmail.gd`) usa o **feed Atom**, leve — um único GET autenticado em
`mail/feed/atom` (`zimmy.http_get_auth(...)`) que devolve `<fullcount>N</fullcount>`, sem
máquina de estados IMAP, autenticado com uma **App Password** (HTTP Basic). No topo do
submenu, **🔊 Alerta de som** (ligado por padrão, persistido) toca um som baixo de entrega
de correio sempre que o contador de não lidos **aumenta** (chegou e-mail novo).

**Pré-requisito — App Password** (a senha normal **não funciona mais**):

- **Gmail**: ative a verificação em 2 etapas e gere uma *Senha de app* em
  [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords). O **feed
  Atom não exige IMAP ativado** — só a App Password. O Google mostra a senha em 4 grupos de
  4 — pode colar **com ou sem os espaços** (o Zimmy remove). Use a **Senha de app**, não a
  sua senha normal do Google.

**Passo-a-passo de primeira vez**: na primeira vez que você liga o **Gmail** (enquanto
ainda não há credencial salva), o diálogo de login mostra um **passo-a-passo de como gerar
a App Password**, além de um link clicável **"↗ Abrir a página da Senha de app"** que abre a
página do Google no navegador. Qualquer automação pode fornecer a sua própria ajuda pelos
parâmetros opcionais `help_steps`/`help_url` de `zimmy.with_credentials(...)`.

**Credenciais**: ao **ligar** um provedor no menu, o Zimmy pede *e-mail* + *App Password*.
Elas são salvas **por automação** em `user://cred_<chave>.json` (ex.: `cred_email_gmail.json`)
— **fora do repositório** e cobertas pelo `.gitignore` (`cred_*.json`). O arquivo é
**criptografado** (AES, via `FileAccess.open_encrypted_with_pass`) com uma chave derivada
de um salt do app + o ID da máquina (`OS.get_unique_id`), então não fica em texto puro nem
vale em outro computador. Só são gravadas/atualizadas **após um login válido**; se a senha
mudar e o login falhar, o arquivo é descartado e o Zimmy pergunta de novo. Arquivos antigos
em texto puro são migrados (recriptografados) na leitura. Reutilize esse fluxo em qualquer
automação com `zimmy.with_credentials(key, titulo, cb)` + `zimmy.confirm_credentials(key, dados)`.

### WhatsApp (submenu 💬 WhatsApp) — conversas não lidas

A automação `whatsapp.gd` (`MENU_GROUP := "whatsapp"`) mostra o número de **conversas não
lidas do WhatsApp** como badge, a cada minuto. **Importante — ela não se conecta ao
WhatsApp:** não existe API pública e a sessão do WhatsApp Web é presa criptograficamente ao
navegador que leu o QR, então não dá para reusá-la de fora. Automatizar o cliente do
WhatsApp (ex.: com bibliotecas não oficiais) **violaria os Termos do WhatsApp e arriscaria
um banimento**, então o Zimmy **não** faz isso. Em vez disso, faz **observação passiva**: lê
o **título da janela do WhatsApp Web** que o seu próprio navegador mantém aberto, via
`tasklist` — o WhatsApp põe `(N) WhatsApp` no título quando há não lidas, e um pequeno regex
extrai o `N`. Nenhum servidor é acessado, nada é injetado.

**Requisito:** mantenha o **WhatsApp Web aberto e vinculado** a este aparelho — de
preferência como **janela própria** (Chrome ▸ ⋮ ▸ *Transmitir, salvar e compartilhar* ▸
*Criar atalho...* ▸ ✓ *Abrir como janela*), assim a contagem fica no título mesmo quando não
é a aba ativa. Se a janela não for encontrada, o badge mostra `?` e o Zimmy avisa que não
está aberto. No topo do submenu, **🔊 Alerta de som** (ligado por padrão, persistido) toca
um som baixo de telefone tocando sempre que o contador de não lidas **aumenta** (chegou
conversa nova).

## Pets

- O pet procedural original é o **Default** — está sempre disponível e **nunca é
  removido**. É descrito por `_default_cfg()` em `zimmy.gd`.
- Cada pet é um *config* (cores de corpo/barriga/orelha/bochecha/antena/nariz/chifre +
  proporções de orelhas, olhos, corpo e barriga + ~uma dúzia de categorias geométricas
  do "esqueleto": rabo, chifre, topete, formato de olho, pupila, sobrancelha, patas,
  bracinhos, marca na barriga, bigodes, asas, sardas, além da silhueta/orelha/boca). O
  `_draw()` desenha **tudo proceduralmente** a partir desse config (sem sprites), então
  o mesmo código gera o Default, os aleatórios e os salvos.
- **Geração aleatória**: `_random_cfg()` busca **estética equilibrada e cores alegres**:
  - **Arquétipos de bichinhos** — cerca de **55%** dos pets aleatórios saem como um
    **bichinho reconhecível**: `cat`, `dog`, `bunny`, `bear`, `frog`, `fox`, `mouse` ou
    `pig` (chave `critter`). O bicho é definido pela **forma**
    (orelhas/boca/bigodes/cauda/proporções) — a **cor segue aleatória** (um gato roxo é
    válido e fofo). Os outros ~45% continuam criaturas abstratas livres.
  - **Geometria** — sorteia a **silhueta do corpo** (`body_shape`: `round`/`tall`/
    `wide`/`pear`/`chubby`/`slim`), a **forma de orelha** (redonda/pontuda/caída), o
    **estilo de boca** (`smile`/`cat`/`open`/`line`/`tongue`/`fang`), as **proporções** e
    a **presença de elementos** (antenas, nariz, cílios, bochechas).
  - **Categorias extras do "esqueleto"** (cada uma sorteada de forma **independente**):
    **rabo** (`curl`/`puff`/`stub`), **chifre** (`unicorn`/`devil`/`antlers`), **topete**
    (`tuft`/`cowlick`/`mohawk`), **formato do olho** (`oval`/`tall`/`sleepy`), **pupila**
    (`big`/`cat`/`sparkle`/`heart`), **sobrancelha** (`flat`/`raised`/`serious`),
    **patas**, **bracinhos**, **marca na barriga** (`spot`/`heart`), **bigodes**
    (`short`/`long`), **asas**, **sardas**, **padrão no corpo** (`spots`/`stripes`) e
    **focinho**. A maioria tem `none` com peso maior, então os pets variam bastante sem
    ficarem sobrecarregados.
  - **Cor** — parte de um matiz base e deriva as cores de destaque por um **esquema de
    harmonia** (análogo / complementar / triádico / mono), com saturação e brilho em
    faixas **vibrantes-porém-suaves** (tema alegre, evitando tons sujos/escuros) e
    garantindo contraste entre corpo e barriga.
- **Persistência**: pets salvos ficam em `user://pets.json` e voltam a aparecer no
  dropdown na próxima execução. (No Windows, `user://` fica em
  `%APPDATA%\Godot\app_userdata\Zimmy Pet\`.)
- **A escolha ativa é lembrada**: o pet selecionado é gravado em `user://settings.json`
  e, ao reabrir o Zimmy, ele volta carregado e **pré-selecionado** (✓) no dropdown
  "Escolher pet".
- **Exclusão permanente**: "🗑️ Excluir pet ▸" remove o pet salvo do `pets.json` (com
  confirmação). O `Default` é intocável e nunca pode ser excluído.

## Acessórios

- Os acessórios são uma **camada independente do pet**, desenhados por cima por
  `_draw_accessories()` e descritos por `_default_acc()`/`_random_acc()`. Cada categoria
  é **sorteada de forma independente** (cada uma com sua cor própria):
  - **Originais**: chapéu (`beanie`/`tophat`/`crown`/`cap`/`wizard`), óculos
    (`round`/`square`/`star`/`heart`/`sunglasses`), laço (cabeça/pescoço) e cachecol.
  - **Categorias extras**: colar (`pearls`/`pendant`), brincos (`studs`/`hoops`),
    coleira (`plain`/`bell`), fones de ouvido, monóculo, bigode (`curly`/`thin`),
    florzinha, broche (`star`/`heart`), gravata (`necktie`/`bowtie`), faixa diagonal,
    máscara (`medical`/`ninja`), adesivo de bochecha (`star`/`heart`), cinto
    (`plain`/`buckle`) e mochila. A maioria tem `none` com peso maior, para variar sem
    exagerar.
- A **geração aleatória** dos acessórios tem checkbox próprio (**🎲 Gerar acessórios
  aleatórios**), separado da geração de pets. A **exibição** é controlada por
  **👓 Mostrar acessórios** (ligada por padrão). Como o Default não veste nada, a
  exibição não muda nada até existir um acessório.
- **Salvar/carregar são independentes do pet**: um pet salvo não leva acessório
  junto e vice-versa. Assim dá para combinar qualquer pet com qualquer acessório
  salvo.
- **Persistência**: acessórios salvos ficam em `user://accessories.json` (separado de
  `pets.json`). A **escolha ativa** de acessório (e o estado de **👓 Mostrar
  acessórios**) também é gravada em `user://settings.json` e restaurada na próxima
  abertura, voltando **pré-selecionada** (✓) no dropdown "Escolher acessório".
- **Exclusão permanente**: "🗑️ Excluir acessório ▸" remove o acessório salvo do
  `accessories.json` (com confirmação). O `Nenhum` é intocável e nunca pode ser excluído.

## Como o overlay funciona

A "mágica" do overlay está em `project.godot`:

- `display/window/per_pixel_transparency/allowed=true` — habilita transparência por pixel
- `display/window/size/transparent=true` — fundo da janela transparente (FLAG_TRANSPARENT)
- `display/window/size/borderless=true` — sem barra de título / bordas
- `display/window/size/always_on_top=true` — sempre por cima das outras janelas
- `application/boot_splash/show_image=false` — **esconde o logo do Godot** na abertura
- `application/boot_splash/bg_color=Color(0, 0, 0, 0)` — fundo do splash transparente
  (sem o quadrado/tela de abertura visível ao iniciar)

E em `zimmy.gd`, `_ready()` reforça a transparência: `get_tree().root.transparent_bg = true`,
`get_window().set_flag(Window.FLAG_TRANSPARENT, true)` e
`RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))`. Também desativa o
*embed* de subjanelas (`gui_embed_subwindows = false`) para o menu e o diálogo
aparecerem como janelas nativas, fora da janelinha do pet.

> **Importante (build exportado):** a transparência por pixel só funciona com o
> renderer **Compatibility (OpenGL)** — no Forward+ (Vulkan) a janela exportada
> fica com um quadrado preto. Além disso, o **MSAA 2D** precisa ficar desligado
> (ele também pinta o fundo de preto). Ambos já estão configurados em `project.godot`.

O Zimmy é desenhado proceduralmente em `_draw()` (elipses + curva da boca), com
respiração, piscadas, olhos que seguem o cursor global do mouse e **animações de reação
variadas**: cada ação do menu dispara um movimento **escolhido aleatoriamente** de um
conjunto combinado à energia daquela ação — `hop`, `double_hop`, `triple_hop`, `spin`,
`spin_jump`, `backflip`, `wiggle`, `nod`, `squish`, `tilt`, `dance` (pulinhos físicos
combinados com rotação, squash-stretch e balanço em torno de um pivô). A sombra fica fixa
no chão e as barras de status não são afetadas.

### Balão de fala dinâmico

Quando o Zimmy fala, a **janela cresce e encolhe dinamicamente** para comportar a
frase (e emojis) — ver `_relayout()` em `zimmy.gd`. A largura mede o texto com a fonte
real e cresce só o necessário; frases mais largas que `MAX_W = 300 px` **quebram em
várias linhas** (por palavras). O Zimmy fica **ancorado pelo seu centro-inferior**,
então não se desloca quando o balão aparece ou some; a posição da janela vem só dessa
âncora (sem reclamp pela borda da tela), então um balão grande pode transbordar para a
borda em vez de deslocar o pet. Por isso o `stretch/mode` fica em `disabled` (1 unidade
= 1 pixel), senão o canvas esticaria ao redimensionar.

> **Nota (fonte/emojis):** use a **fonte padrão** do Godot no balão — ela renderiza
> acentos e emojis coloridos no renderer Compatibility. Um `SystemFont` (Segoe UI)
> faz o texto sumir nesse renderer.

### Expressões faciais (espelham o emoji)

Enquanto o Zimmy fala, **o rosto reflete a emoção do emoji** da frase. `say()` deduz a
expressão via `_expression_from_text()` e o `_draw()` desenha olhos e boca
correspondentes em `_draw_expression()`:

| Expressão | Emojis (gatilho) | Rosto |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | olhos fechados felizes (∩), blush, sorrisão |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | olhos arregalados com brilho, boca aberta |
| `angry` | 😠 😤 😡 💢 | sobrancelhas franzidas, olhos estreitos, boca emburrada |
| `sad` | 😢 😞 😭 🥺 | sobrancelhas caídas, olhar p/ baixo, lágrima |
| `disgust` | 🤢 🤮 😖 | olho torto, boca ondulada, línguinha |
| `indifferent` | 😑 🙄 😒 🫤 | olhos entediados (traços), boca reta |
| `sleepy` | 😴 💤 🥱 | olhos fechados (∪), boquinha |

Sem emoji emotivo (ou sem fala), volta ao rosto padrão (olhos seguindo o cursor +
boca do config). Como as falas de mau humor usam esses emojis, **insistir numa ação**
faz o Zimmy mostrar raiva/nojo/tristeza/indiferença no rosto, não só no texto.

## Ideias de evolução

- **Click-through**: `get_window().mouse_passthrough_polygon` com o contorno do corpo,
  para clicar na área de trabalho atrás das partes transparentes.
- **Caminhar sozinho**: animar `get_window().position` para ele passear pela borda da tela.
- **AnimatedSprite2D**: trocar o `_draw()` por sprites/spritesheets se quiser arte mais rica.
- **Renomear/remover pets salvos**: hoje o dropdown só adiciona; o Default é fixo.
- **Lançar pelo jogo**: `OS.create_process()` a partir de outro app para abrir o pet junto.
