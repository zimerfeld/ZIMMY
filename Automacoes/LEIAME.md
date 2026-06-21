# Automações do Zimmy

Coloque aqui scripts `.gd` para que apareçam no menu de contexto (botão direito) em
**⚙️ Automações**. Enquanto não houver nenhum script `.gd` válido nesta pasta, o item
**⚙️ Automações** fica **desabilitado**.

O menu é reescaneado toda vez que você abre o menu de contexto, então scripts novos
aparecem sem precisar reiniciar o Zimmy.

## Contrato de uma automação

Cada automação é um script GDScript com:

- (opcional) `const AUTOMATION_NAME := "Nome no menu"` — o texto exibido no submenu.
  Se omitido, o nome é derivado do arquivo (`minha_automacao.gd` → "Minha Automacao").
- (opcional) `const SCHEDULE := "..."` — frequência para o Zimmy rodar a automação
  **sozinho**, sem você precisar clicar (ver **Agendamento** abaixo).
- um método `run(zimmy)` — chamado quando o item é escolhido (ou no disparo agendado).
  `zimmy` é o nó principal (`zimmy.gd`), dando acesso a `say()`, `feed()`, `pet()`,
  `play()`, `hop()`, `current`, `current_acc`, e ao estado (`hunger`, `happy`), etc.

## Agendamento (frequência / recorrência)

Declare uma frequência e a automação aparece no submenu **⚙️ Automações** como um item
**marcável** (✓ = ligada) mostrando o intervalo. Ligar/desligar é **persistente** —
ao reabrir o Zimmy, o que estava ligado volta a rodar (estado em `user://schedules.json`).

```gdscript
extends RefCounted
const AUTOMATION_NAME := "Auto-alimentar 🦴"
const SCHEDULE := "20s"          # a cada 20 segundos
func run(zimmy) -> void:
    if zimmy.hunger > 55.0:
        zimmy.hunger = max(zimmy.hunger - 25.0, 0.0)
        zimmy.say("auto-refeição 🦴")
```

Formatos aceitos em `SCHEDULE`:

| Valor | Significado |
|---|---|
| `"30s"`, `"5m"`, `"2h"` | a cada N segundos / minutos / horas |
| `"hourly"` | toda **hora cheia** (no minuto :00, alinhado ao relógio) |
| `"daily@09:00"` | uma vez por dia no horário HH:MM |
| `const SCHEDULE_SECONDS := 300` | alternativa numérica (segundos) |

> Para automações **agendadas**, o **agendador cuida da recorrência** — o `run(zimmy)`
> deve fazer a ação **uma vez** (use `extends RefCounted`). Sem `SCHEDULE`, o item
> continua sendo um botão comum que executa uma vez ao ser clicado.

## Automações web e de sistema

- **Web**: use `zimmy.http_get_json(url, cb)` — faz um GET e chama `cb.call(ok, data)`
  com o JSON decodificado (ou null). Na *closure*, referencie só `zimmy` e variáveis
  locais (**não** `self`), para funcionar tanto no clique quanto no disparo agendado.
  Ver os exemplos `cotacao_*.gd`.
- **Sistema**: automações são GDScript, então podem usar `OS.execute(...)` /
  `OS.create_process(...)` (ex.: `shutdown`, bipe) e `Time.get_datetime_dict_from_system()`.
  Ver `desligar_pc.gd` e `alarme.gd`.

## Grupos de menu, badges e credenciais

Constantes opcionais que o Zimmy lê do script:

| Const | Efeito |
|---|---|
| `MENU_GROUP := "email"` | põe o item num submenu dedicado **📧 E-mails** (em vez de ⚙️ Automações) |
| `ICON_COLOR := "ea4335"` | cor do **ícone à esquerda** do item (hex) |
| `BADGE_KEY := "..."` | chave do **badge**; o rótulo mostra o valor de `zimmy.set_automation_badge(key, texto)` |
| `CRED_KEY := "..."` | guarda credenciais em `user://cred_<key>.json` (gitignored) |

**Credenciais** (helpers no `zimmy`): `with_credentials(key, titulo, cb)` entrega as
credenciais salvas a `cb.call({user, pass})` ou, se não houver, abre o diálogo de login;
`confirm_credentials(key, dados)` salva **só** se forem novas/alteradas (chame após validar);
`forget_credentials(key)` apaga (ex.: login falhou). Regra: pede ao ligar a automação se
não houver credencial salva; grava só após validação.

**E-mail (IMAP)**: `zimmy.imap_unread(host, 993, user, pass, cb)` conta não-lidos
(`STATUS INBOX (UNSEEN)`) sobre TLS e chama `cb.call(ok, count)`. Exige **App Password**
(a senha normal do Gmail/Outlook não funciona mais). Ver `email_gmail.gd` / `email_outlook.gd`.

## Exemplos inclusos

`auto_alimentar`, `lembrete_pomodoro`, `comemoracao_hora_cheia`, `cotacao_usd/eur/gbp/jpy/cny`,
`desligar_pc`, `cancelar_desligamento`, `alarme`, `email_gmail`, `email_outlook`.

### Exemplo mínimo (`extends RefCounted`)

```gdscript
extends RefCounted

const AUTOMATION_NAME := "Dar oi"

func run(zimmy) -> void:
    zimmy.say("oi! 👋")
    zimmy.hop()
```

### Automação contínua (`extends Node`)

Se o script `extends Node`, ele é adicionado como filho do Zimmy e **persiste** — útil
para automações que rodam ao longo do tempo (use `_process`, timers, etc.). Scripts que
`extends RefCounted` são descartados após o `run()`.

```gdscript
extends Node

const AUTOMATION_NAME := "Pular a cada 3s"

var _zimmy
var _t := 0.0

func run(zimmy) -> void:
    _zimmy = zimmy
    set_process(true)

func _process(delta: float) -> void:
    _t += delta
    if _t >= 3.0:
        _t = 0.0
        _zimmy.hop()
```

Veja `exemplo_automacao.gd.example` para um modelo pronto — basta renomeá-lo para
`.gd` para ativá-lo.
