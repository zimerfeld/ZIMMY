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
- um método `run(zimmy)` — chamado quando o item é escolhido. `zimmy` é o nó principal
  (`zimmy.gd`), dando acesso a `say()`, `feed()`, `pet()`, `play()`, `hop()`,
  `current`, `current_acc`, etc.

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
