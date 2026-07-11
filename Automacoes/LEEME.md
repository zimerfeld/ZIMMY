# Automatizaciones de Zimmy

Coloca aquí scripts `.gd` para que aparezcan en el menú contextual (botón derecho) en
**⚙️ Automatizaciones**. Mientras no haya ningún script `.gd` válido en esta carpeta, el elemento
**⚙️ Automatizaciones** queda **deshabilitado**.

El menú se reescanea cada vez que abres el menú contextual, así que los scripts nuevos
aparecen sin necesidad de reiniciar Zimmy.

## Contrato de una automatización

Cada automatización es un script GDScript con:

- (opcional) `const AUTOMATION_NAME := "Nombre en el menú"` — el texto mostrado en el submenú.
  Si se omite, el nombre se deriva del archivo (`minha_automacao.gd` → "Minha Automacao").
- (opcional) `const AUTOMATION_NAME_EN := "Menu name"` — nombre **en inglés**, usado cuando
  el idioma de la app es English (US). Sin él, cae en `AUTOMATION_NAME` (pt).
- (opcional) `const AUTOMATION_NAME_ES := "Nombre en el menú"` — nombre **en español**, usado cuando
  el idioma de la app es Español (España). Sin él, cae en `AUTOMATION_NAME` (pt).
- (opcional) `const SCHEDULE := "..."` — frecuencia para que Zimmy ejecute la automatización
  **por su cuenta**, sin que tengas que hacer clic (ver **Programación** abajo).
- un método `run(zimmy)` — llamado cuando se elige el elemento (o en el disparo programado).
  `zimmy` es el nodo principal (`zimmy.gd`), que da acceso a `notify()`, `say()`, `feed()`,
  `pet()`, `play()`, `hop()`, `current`, `current_acc`, y al estado (`hunger`, `happy`), etc.

### Mensajes: usa `notify()` (cola de 10s)

Para hablar desde una automatización/correo, usa **`zimmy.notify(texto)`**: los mensajes
entran en una **cola** y cada uno permanece **visible 10 segundos** por turno, sin solaparse
cuando varios disparan a la vez (p. ej.: varias cotizaciones). Detalles útiles:
- Un mensaje que espera **más de 60s** en la cola se **descarta** (ya no es relevante).
- Si la automatización fue **disparada por el usuario** (hiciste clic en ella en el menú), la respuesta
  **se salta la cola** y aparece al instante — incluso las web asíncronas (el resultado del callback
  entra en la ventana de urgencia).
- Mientras una **reacción** (say) está en pantalla, la notificación **se pausa** y se reanuda después.

(`zimmy.say(texto)` es la **reacción inmediata**: se muestra **al momento** durante ~2,5s, con prioridad
sobre la cola — úsala para feedback directo, no para avisos de fondo.)

### Textos multilingües (i18n)

La app tiene idioma **pt-BR / en-US / es-ES** (menú ▸ 🌐 Idioma). Para el habla multilingüe, usa los
helpers de `zimmy` (sin necesidad de una tabla propia):

- `zimmy.lang_text(pt, en, es)` — devuelve uno de los textos según el idioma actual. El tercer
  argumento `es` (español) es **opcional** y, si se omite, cae en el texto en portugués.
- `zimmy.lang` — `"pt"`, `"en"` o `"es"` (p. ej.: para elegir de varias listas de frases).
- `zimmy.fmt_num(v, casas)` / `zimmy.fmt_pct(v)` / `zimmy.fmt_money_brl(v, casas)` —
  número/porcentaje/valor con el **separador decimal** del idioma (coma en pt, punto en en).
- `zimmy.fmt_quote_date("AAAA-MM-DD HH:MM:SS")` — fecha en el formato del idioma
  (`DD/MM/AAAA` en pt, `MM/DD/YYYY` en en).

```gdscript
func run(zimmy) -> void:
    zimmy.notify(zimmy.lang_text("olá! 👋", "hi! 👋", "¡hola! 👋"))
    # valores/fechas localizados (ej.: cotizaciones):
    zimmy.notify("USD/BRL: %s — %s" % [zimmy.fmt_money_brl(5.1234, 4), zimmy.fmt_quote_date("2026-06-21 09:30:00")])
```

## Programación (frecuencia / recurrencia)

Declara una frecuencia y la automatización aparece en el submenú **⏱️ Temporizadores** (justo
debajo de **⚙️ Automatizaciones**) como un elemento **marcable** (✓ = activado), con un icono de
reloj, mostrando el intervalo. Activar/desactivar es **persistente** — al reabrir Zimmy, lo
que estaba activado vuelve a ejecutarse (estado en `user://schedules.json`).

```gdscript
extends RefCounted
const AUTOMATION_NAME := "Auto-alimentar 🦴"
const SCHEDULE := "20s"          # cada 20 segundos
func run(zimmy) -> void:
    if zimmy.hunger > 55.0:
        zimmy.hunger = max(zimmy.hunger - 25.0, 0.0)
        zimmy.notify("auto-comida 🦴")
```

Formatos aceptados en `SCHEDULE`:

| Valor | Significado |
|---|---|
| `"30s"`, `"5m"`, `"2h"` | cada N segundos / minutos / horas |
| `"hourly"` | cada **hora en punto** (en el minuto :00, alineado al reloj) |
| `"daily@09:00"` | una vez al día a la hora HH:MM |
| `const SCHEDULE_SECONDS := 300` | alternativa numérica (segundos) |

> Para automatizaciones **programadas**, el **programador se encarga de la recurrencia** — el `run(zimmy)`
> debe hacer la acción **una vez** (usa `extends RefCounted`). Sin `SCHEDULE`, el elemento
> sigue siendo un botón normal que se ejecuta una vez al hacer clic.

## Automatizaciones web y de sistema

- **Web**: usa `zimmy.http_get_json(url, cb)` — hace un GET y llama a `cb.call(ok, data)`
  con el JSON decodificado (o null). En la *closure*, referencia solo `zimmy` y variables
  locales (**no** `self`), para que funcione tanto al hacer clic como en el disparo programado.
  Ver los ejemplos `cotacao_*.gd`.
- **Web autenticado**: `zimmy.http_get_auth(url, user, pass, cb)` — GET con
  `Authorization: Basic`; llama a `cb.call(status, body)` (status = código HTTP: 200 ok,
  401 credencial inválida, 0 = fallo de red). Útil para feeds protegidos. Ver `email_gmail.gd`
  (feed Atom de Gmail → `<fullcount>N</fullcount>`).
- **Sistema**: las automatizaciones son GDScript, así que pueden usar `OS.execute(...)` /
  `OS.create_process(...)` (p. ej.: `shutdown`, pitido) y `Time.get_datetime_dict_from_system()`.
  Ver `desligar_pc.gd` y `alarme.gd`.

## Grupos de menú, badges y credenciales

Constantes opcionales que Zimmy lee del script:

| Const | Efecto |
|---|---|
| `MENU_GROUP := "email"` | pone el elemento en un submenú dedicado **📧 Correos** (en vez de ⚙️ Automatizaciones) |
| `MENU_GROUP := "moedas"` | pone el elemento en el submenú **💱 Monedas**, en el menú principal justo debajo de ⚙️ Automatizaciones (usado por las cotizaciones) |
| `MENU_GROUP := "whatsapp"` | pone el elemento en el submenú dedicado **💬 WhatsApp** (usado por el contador de no leídos) |
| `ICON_COLOR := "ea4335"` | color del **icono a la izquierda** del elemento (hex) |
| `BADGE_KEY := "..."` | clave del **badge**; la etiqueta muestra el valor de `zimmy.set_automation_badge(key, texto)` |
| `CRED_KEY := "..."` | guarda credenciales en `user://cred_<key>.json` (gitignored) |

**Credenciales** (helpers en `zimmy`): `with_credentials(key, titulo, cb)` entrega las
credenciales guardadas a `cb.call({user, pass})` o, si no las hay, abre el diálogo de login;
`confirm_credentials(key, dados)` guarda **solo** si son nuevas/modificadas (llámalo tras validar);
`forget_credentials(key)` las borra (p. ej.: login fallido). Regla: pide al activar la automatización si
no hay credencial guardada; graba solo tras la validación.

**Correo (Gmail)**: `zimmy.http_get_auth(url, user, pass, cb)` hace un GET autenticado
(HTTP Basic) y llama a `cb.call(status, body)`. El `email_gmail.gd` usa el **feed Atom**
(`mail/feed/atom`), que devuelve `<fullcount>N</fullcount>`. Exige **App Password**
(la contraseña normal de Gmail ya no funciona). Ver `email_gmail.gd`.

**Alerta de sonido**: los submenús **📧 Correos** y **💬 WhatsApp** tienen, arriba, un elemento
**🔔 Alerta de sonido** (checkbox). Cuando el badge del `BADGE_KEY` correspondiente (`email_gmail`
o `whatsapp`) **sube**, Zimmy reproduce un sonido suave (correo / teléfono). Todo se maneja
dentro de `zimmy` en `set_automation_badge(...)` — la automatización solo necesita actualizar el badge.

## Ejemplos incluidos

`lembrete_pomodoro`, `comemoracao_hora_cheia` (fuegos vía `zimmy.celebrate()`),
`cotacao_usd/eur/gbp/jpy/cny`, `clima`, `desligar_pc`, `cancelar_desligamento`, `alarme`,
`email_gmail`, `whatsapp`.

### Ejemplo mínimo (`extends RefCounted`)

```gdscript
extends RefCounted

const AUTOMATION_NAME := "Dar oi"

func run(zimmy) -> void:
    zimmy.notify("oi! 👋")
    zimmy.hop()
```

### Automatización continua (`extends Node`)

Si el script hace `extends Node`, se añade como hijo de Zimmy y **persiste** — útil
para automatizaciones que se ejecutan a lo largo del tiempo (usa `_process`, timers, etc.). Los scripts que
hacen `extends RefCounted` se descartan tras `run()`.

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

Consulta `exemplo_automacao.gd.example` para una plantilla lista — basta con renombrarlo a
`.gd` para activarlo.
