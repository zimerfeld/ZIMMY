# Zimmy Pet 🧡

Desktop pet overlay, feito em Godot 4.6.
Uma janela transparente, sem bordas e sempre no topo que flutua sobre a área de trabalho.
O pet é desenhado num espaço lógico de **200×200** e exibido a **75%** (≈150 px,
`PET_SCALE`). A janela reserva ainda uma faixa transparente acima do pet
(`HOP_HEADROOM`) para o **pulinho** não ser cortado, e cresce dinamicamente quando o
Zimmy fala.

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
| Botão direito | Abre o menu de contexto (abaixo) |
| Esc | Fecha |

> **Posição na tela:** na primeira execução o Zimmy abre **centralizado**. Depois,
> sempre que você o arrasta a posição é gravada em `user://settings.json` e ele
> reabre no **último lugar** onde ficou.

### Menu de contexto

- **🦴 Alimentar / 🤚 Carinho / 🎾 Brincar** — interações que mudam humor/fome.
- **🎲 Gerar pets** (check) — liga/desliga a geração contínua **do pet**: a cada ~9 s o
  Zimmy vira um pet aleatório. Além das cores, varia as **formas** e quais
  **elementos** o compõem (orelhas redondas ou pontudas, antenas, nariz, cílios,
  bochechas e o estilo da boca).
- **🎲 Gerar acessórios** (check) — independente do anterior: liga/desliga a geração
  contínua **dos acessórios** (a cada ~9 s sorteia chapéu/óculos/laço/cachecol). Ligar
  também liga automaticamente a exibição de acessórios.
- **👓 Mostrar acessórios** (check) — liga/desliga a exibição da camada de
  acessórios (chapéu, óculos, laço, cachecol), independentemente do pet.
- **💾 Salvar Pet…** — abre um diálogo para nomear e salvar **só o pet** exibido.
  Abrir este diálogo **desliga a geração automática** para que se salve exatamente o
  que está na tela.
- **📂 Escolher pet ▸** — dropdown para trocar o pet exibido. Sempre tem
  `Selecione...` (índice 0, só rótulo) e `Default` (índice 1) no topo, seguidos dos
  pets salvos. A **opção ativa fica realçada** (marcada com ✓) para você ver de
  relance qual pet está em uso; com a geração aleatória ligada, nenhuma fica marcada.
  Escolher um pet específico desliga a geração aleatória.
- **🎀 Salvar Acessório…** — abre um diálogo para nomear e salvar **só o acessório**
  atual (independente do pet). Também desliga a geração automática ao abrir.
- **🧳 Escolher acessório ▸** — dropdown independente para trocar o acessório. Tem
  `Selecione...` (só rótulo) e `Nenhum` (limpa os acessórios) no topo, seguidos dos
  acessórios salvos. A **opção ativa fica realçada** (marcada com ✓); com a geração
  aleatória de acessórios ligada, nenhuma fica marcada. Escolher um acessório liga a
  exibição e desliga o aleatório.
- **⚙️ Automações ▸** — submenu com as automações disponíveis (scripts da pasta
  `Automacoes/`). Fica **desabilitado** quando não há nenhuma automação. Automações
  **avulsas** aparecem como botões (executam uma vez ao clicar); automações
  **agendadas** aparecem como itens **marcáveis** (✓ = ligada) com a frequência no
  rótulo — é o **agendador visual**. Ver **Automações** abaixo.
- **📧 E-mails ▸** — submenu dedicado aos provedores de e-mail (Gmail, Outlook), cada um
  com o **ícone à esquerda** e o **contador de não lidos** no rótulo. Fica **desabilitado**
  se não houver automações de e-mail. Ver **E-mails** abaixo.
- **Sair**.

## Automações

Automações são scripts `.gd` colocados na pasta **`Automacoes/`** (na raiz do
projeto). Aparecem no menu de contexto em **⚙️ Automações** — o submenu é
**reescaneado toda vez que o menu abre**, então scripts novos aparecem sem reiniciar.
Sem nenhum script válido, o item do menu fica desabilitado.

Cada automação é um GDScript com:

- (opcional) `const AUTOMATION_NAME := "Nome no menu"` — texto exibido no submenu. Sem
  ele, o nome é derivado do arquivo (`minha_automacao.gd` → "Minha Automacao").
- (opcional) `const SCHEDULE := "..."` — frequência para o Zimmy rodar a automação
  sozinho (ver **Agendador** abaixo).
- um método `run(zimmy)` — chamado ao escolher o item (ou no disparo agendado). `zimmy`
  é o nó principal, dando acesso a `say()`, `feed()`, `pet()`, `play()`, `hop()`,
  `current`, e ao estado (`hunger`, `happy`), etc.

Scripts que `extends RefCounted` são descartados após o `run()`; os que `extends Node`
são adicionados como filhos do Zimmy e **persistem** (úteis para automações contínuas
via `_process`/timers). Veja `Automacoes/LEIAME.md` e
`Automacoes/exemplo_automacao.gd.example` (renomeie para `.gd` para ativar) para os
modelos.

### Agendador (frequência / recorrência)

Uma automação que declara `const SCHEDULE` roda **sozinha** na frequência indicada,
sem precisar clicar. Ela aparece no submenu **⚙️ Automações** como um item **marcável**
(✓ = ligada) com o intervalo no rótulo — esse é o **agendador visual**. Ligar/desligar
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
| Cotação USD/EUR/GBP/JPY/CNY 💱 | `cotacao_*.gd` | avulsas — cotação da moeda em BRL ([AwesomeAPI](https://docs.awesomeapi.com.br/), grátis). As 5 moedas de maior influência (cesta SDR) formam o "submenu de moedas" em ⚙️ Automações |
| Desligar PC 🔌 | `desligar_pc.gd` | `daily@23:00` — desliga o Windows com 60s de aviso |
| Cancelar desligamento ❌ | `cancelar_desligamento.gd` | avulsa — aborta o desligamento (`shutdown /a`) |
| Alarme ⏰ | `alarme.gd` | `daily@08:00` — pula, avisa e dá um bipe |
| Gmail / Outlook 📧 | `email_gmail.gd`, `email_outlook.gd` | a cada 5min — contam e-mails não lidos via IMAP; aparecem no submenu **📧 E-mails** |

> **Atenção (desligar PC):** `desligar_pc.gd` executa `shutdown` de verdade. Vem
> **desligado** por padrão e dá 60s de aviso; para abortar, rode "Cancelar desligamento".

### E-mails (submenu 📧 E-mails) — contador de não lidos

Automações que declaram `const MENU_GROUP := "email"` aparecem num submenu dedicado
**📧 E-mails**, com o **ícone do provedor à esquerda** (cor de `ICON_COLOR`) e o
**contador de não lidos no rótulo**. Cada provedor (`email_gmail.gd`, `email_outlook.gd`)
busca a contagem por **IMAP sobre TLS** (`zimmy.imap_unread(...)`) a cada 5 min.

**Pré-requisito — App Password** (a senha normal **não funciona mais**):

- **Gmail**: ative a verificação em 2 etapas e gere uma *Senha de app* em
  [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords); confira
  que o **IMAP está ativado** (Gmail ▸ Configurações ▸ Encaminhamento e POP/IMAP).
- **Outlook/Hotmail**: gere uma *Senha de aplicativo* em
  [account.microsoft.com/security](https://account.microsoft.com/security). Contas
  **Microsoft 365 corporativas** costumam ter IMAP/básico **desativado** pelo admin — aí
  não funciona.

**Credenciais**: ao **ligar** um provedor no menu, o Zimmy pede *e-mail* + *App Password*.
Elas são salvas **por automação** em `user://cred_<chave>.json` (ex.: `cred_email_gmail.json`)
— **fora do repositório** e cobertas pelo `.gitignore` (`cred_*.json`). Só são gravadas/
atualizadas **após um login válido**; se a senha mudar e o login falhar, o arquivo é
descartado e o Zimmy pergunta de novo. Reutilize esse fluxo em qualquer automação com
`zimmy.with_credentials(key, titulo, cb)` + `zimmy.confirm_credentials(key, dados)`.

## Pets

- O pet procedural original é o **Default** — está sempre disponível e **nunca é
  removido**. É descrito por `_default_cfg()` em `zimmy.gd`.
- Cada pet é um *config* (cores de corpo/barriga/orelha/bochecha/antena/nariz +
  proporções de orelhas, olhos, corpo e barriga + flags de quais elementos existem e
  o estilo da boca). O `_draw()` desenha a partir desse config, então o mesmo código
  gera o Default, os aleatórios e os salvos.
- **Geração aleatória**: `_random_cfg()` busca **estética equilibrada e cores alegres**:
  - **Geometria** — sorteia a **silhueta do corpo** (`body_shape`: `round`/`tall`/
    `wide`/`pear` — ovinho em pé, baixinho fofo ou corpo em gota), a **forma de
    orelha** (redonda/pontuda), o **estilo de boca** (`smile`/`cat`/`open`/`line`),
    as **proporções** e a **presença de elementos** (antenas, nariz, cílios,
    bochechas).
  - **Cor** — parte de um matiz base e deriva as cores de destaque por um **esquema de
    harmonia** (análogo / complementar / triádico / mono), com saturação e brilho em
    faixas **vibrantes-porém-suaves** (tema alegre, evitando tons sujos/escuros) e
    garantindo contraste entre corpo e barriga.
- **Persistência**: pets salvos ficam em `user://pets.json` e voltam a aparecer no
  dropdown na próxima execução. (No Windows, `user://` fica em
  `%APPDATA%\Godot\app_userdata\Zimmy Pet\`.)

## Acessórios

- Os acessórios são uma **camada independente do pet**: chapéu (`beanie`/`tophat`/
  `crown`/`cap`), óculos (`round`/`square`/`star`), laço (na cabeça ou no pescoço) e
  cachecol. Descritos por `_default_acc()`/`_random_acc()` e desenhados por
  `_draw_accessories()` por cima do pet.
- A **geração aleatória** dos acessórios tem checkbox próprio (**🎲 Gerar acessórios
  aleatórios**), separado da geração de pets. A **exibição** é controlada por
  **👓 Mostrar acessórios** (ligada por padrão). Como o Default não veste nada, a
  exibição não muda nada até existir um acessório.
- **Salvar/carregar são independentes do pet**: um pet salvo não leva acessório
  junto e vice-versa. Assim dá para combinar qualquer pet com qualquer acessório
  salvo.
- **Persistência**: acessórios salvos ficam em `user://accessories.json` (separado de
  `pets.json`).

## Como o overlay funciona

A "mágica" do overlay está em `project.godot`:

- `display/window/per_pixel_transparency/allowed=true` — habilita transparência por pixel
- `display/window/size/transparent=true` — fundo da janela transparente (FLAG_TRANSPARENT)
- `display/window/size/borderless=true` — sem barra de título / bordas
- `display/window/size/always_on_top=true` — sempre por cima das outras janelas

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
respiração, piscadas, pulinhos e olhos que seguem o cursor global do mouse.

### Balão de fala dinâmico

Quando o Zimmy fala, a **janela cresce e encolhe dinamicamente** para comportar a
frase (e emojis) sem cortes nem quebras de linha desnecessárias — ver `_relayout()`
em `zimmy.gd`. A largura mede o texto com a fonte real e cresce só o necessário;
frases muito longas (acima de `MAX_W = 640 px`) quebram em palavras. O Zimmy fica
**ancorado pelo seu centro-inferior**, então não se desloca quando o balão aparece
ou some, e a janela é mantida dentro da tela (clamp). Por isso o `stretch/mode` fica
em `disabled` (1 unidade = 1 pixel), senão o canvas esticaria ao redimensionar.

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
