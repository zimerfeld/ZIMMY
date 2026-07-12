# Zimmy Pet 🧡

<p align="center">
  <img src="icon.png" alt="Zimmy — la mascota Default" width="180">
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

> Zimmy se crea y se mantiene en mi tiempo libre. Si esta pequeña mascota de escritorio te saca una sonrisa, un patrocinio ayuda a mantenerla actualizada. 💜

> La mascota Default (la carita procedural de `_draw()`, el mismo dibujo usado para el icono).

Superposición de mascota de escritorio, hecha en Godot 4.6.
Una ventana transparente, sin bordes y siempre encima que flota sobre el escritorio.
La mascota se dibuja en un espacio lógico de **200×200** y se muestra al **75%** (≈150 px,
`PET_SCALE`). La ventana reserva una franja transparente por encima de la mascota (`HOP_HEADROOM`) para que
el **saltito** (al alimentar/acariciar/jugar) no quede cortado, y crece dinámicamente cuando Zimmy habla.
La mascota permanece **anclada por su centro-inferior**: un bocadillo de diálogo demasiado grande que exceda la
ventana puede desbordarse hacia el borde de la pantalla, pero **nunca desplaza a la mascota**.

## Cómo ejecutar

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe" --path "C:\GODOT\ZIMMY"
```

O abre la carpeta en Godot y pulsa **F5**.

## Icono

El icono de Zimmy se genera proceduralmente (la misma carita de `_draw()`) mediante
`tools/make_icon.py` (necesita Python + Pillow):

```powershell
py tools/make_icon.py
```

Genera dos archivos a partir del mismo dibujo, para usos distintos:

- **`icon.png`** — el icono de **Godot** (editor + la ventana/barra de tareas de la app). Definido en
  `project.godot` (`config/icon`). Godot usa PNG y no acepta `.ico` aquí.
- **`zimmy.ico`** — el icono del **ejecutable de Windows** (formato `.ico` multi-tamaño, 16→256).
  Usado por el preset de exportación e incrustado en el `.exe` mediante `rcedit`.

## Generar el .exe (Windows)

Requisitos previos: **export templates** de Godot 4.6.2 instaladas y el preset
`Windows Desktop` (ya versionado en `export_presets.cfg`, apuntando a `zimmy.ico`).

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```

El ejecutable (autónomo, con el `.pck` incrustado) se genera en
**`build/ZimmyPet.exe`**.

Para incrustar el icono de Zimmy en el propio `.exe` (por si `rcedit` no está configurado en
el editor), ejecuta después:

```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## Controles

| Acción | Resultado |
|------|-----------|
| Arrastrar (botón izquierdo) | Mueve a Zimmy por la pantalla (la posición se guarda) |
| Clic (sin arrastrar) | Reacciona con un "hola" |
| Pasar el ratón sobre la mascota | Reacciona con una expresión feliz/animada |
| Clic en un ojo | Ese ojo **se cierra** y permanece cerrado mientras el cursor está encima (se reabre al salir) |
| Sacudir el ratón rápido sobre ella | Reacción aleatoria: **mareo / náusea / susto** (tambaleo + ojos en espiral, balanceo mareado, o un temblor de susto) |
| Botón derecho | Abre el menú contextual (abajo), colocado al lado de la mascota sin cubrirla y siempre dentro de la pantalla |
| Esc | Cierra |

> **Posición en pantalla:** en la primera ejecución Zimmy se abre **centrado**. Después,
> cada vez que lo arrastras la posición se escribe en `user://settings.json` y se
> reabre en el **último lugar** donde estuvo. Ese mismo archivo también guarda la **última
> elección de mascota y accesorio**, restaurada automáticamente al reabrir.

### Menú contextual

> Al hacer clic con el **botón derecho**, el menú aparece **al lado de la mascota** (prueba
> derecha → izquierda → abajo → arriba), de forma que **no cubra la mascota** y **no
> sobrepase los bordes de la pantalla**. Si ningún lado encaja, se ajusta dentro del área visible.

- **📊 Estado** (check) — activa/desactiva las **barras de estado** debajo de la mascota (Alimentar/Acariciar/Jugar). Viene
  **desactivado** por defecto; la elección se **persiste** en `user://settings.json` (clave `status`).
- **🦴 Alimentar / 🤚 Acariciar / 🎾 Jugar** — interacciones que cambian el ánimo/hambre. Cada una también reproduce su **propio sonido** (un mordisco, un ronroneo, un arpegio alegre) cuando la alerta de esa acción está activada — con **varias variaciones aleatorias por grupo** (sorteadas dentro del mismo grupo) para que nunca se vuelva repetitivo.
- **🔊 Alertas de sonido ▸** — submenú justo debajo de las acciones con una **casilla por acción** (🦴 Alimentar / 🤚 Acariciar / 🎾 Jugar, todas **activadas** por defecto, **persistidas** en `user://settings.json`). Cada interruptor gobierna **tanto** el sonido reproducido al hacer la acción **como** un recordatorio que suena cuando la barra de esa necesidad **baja al 20% (baja)**. Los sonidos se sintetizan en código (sin archivos de audio), igual que las alertas de WhatsApp/Gmail.
- **🐶 Mascotas aleatorias** (check) — activa/desactiva la generación continua **de la mascota**: cada ~30 s
  Zimmy se convierte en una mascota aleatoria. Además de los colores, varía las **formas** y qué
  **elementos** la componen (orejas redondas o puntiagudas, antenas, nariz, pestañas, mejillas,
  y el estilo de la boca). Cada nueva mascota recibe una **frase de bienvenida y un nombre sugerido** —
  ese nombre rellena previamente la caja de texto (seleccionado) al Guardar o Renombrar. Los nombres son
  **combinatorios** (sustantivo + adjetivo, ~900 combinaciones por idioma), así que rara vez se repiten.
- **🎲 Accesorios aleatorios** (check) — independiente del anterior: activa/desactiva la
  generación continua **de los accesorios** (cada ~30 s sortea un
  sombrero/gafas/lazo/bufanda). Activarlo también enciende automáticamente la visualización
  de accesorios. Cada nuevo accesorio recibe una **frase de felicitación y un nombre sugerido**
  que rellena previamente la caja de texto al Guardar o Renombrar (también **combinatorio**, ~900
  combinaciones por idioma).
- **👓 Mostrar accesorios** (check) — activa/desactiva la visualización de la capa de accesorios (sombrero,
  gafas, lazo, bufanda), independientemente de la mascota.
- **💾 Guardar Mascota...** — abre un diálogo para nombrar y guardar **solo la mascota**
  mostrada. Abrir el diálogo **congela la generación de mascotas** (desmarca "🐶 Mascotas aleatorias")
  para que se guarde exactamente lo que hay en pantalla; al **confirmar**, la casilla "🐶 Mascotas
  aleatorias" queda desmarcada. La generación de accesorios no se ve afectada. **Si la mascota
  mostrada ya es una mascota guardada, este elemento se convierte en
  "💾 Renombrar Mascota..."** (mismo icono): el diálogo se abre con el nombre actual ya rellenado
  y, al confirmar, la mascota se **renombra** — el cambio se escribe en `pets.json` y el
  desplegable "Elegir mascota" se actualiza al instante.
- **📂 Elegir mascota ▸** — desplegable para cambiar la mascota mostrada. Siempre tiene
  `Selecciona...` (índice 0, solo etiqueta) y `Default` (índice 1) arriba, seguidos de las
  mascotas guardadas. La **opción activa se resalta** (marcada con ✓) para que veas de un
  vistazo qué mascota está en uso; con la generación aleatoria activada, no se marca ninguna.
  Elegir una mascota concreta desactiva la generación aleatoria.
- **🗑️ Eliminar mascota ▸** — submenú que lista **solo las mascotas guardadas** (`Default` y
  `Selecciona...` nunca aparecen, son intocables). Al hacer clic pide confirmación y
  luego **elimina la mascota permanentemente** de `pets.json`. Tras eliminar, Zimmy **siempre
  recarga `Default`**. Sin mascotas guardadas, muestra "(no hay mascotas guardadas)".
- **🎀 Guardar Accesorio...** — abre un diálogo para nombrar y guardar **solo el accesorio
  actual** (independientemente de la mascota). Abrirlo **congela la generación de accesorios**
  y, al **confirmar**, la casilla "🎲 Accesorios aleatorios" queda desmarcada (la generación
  de mascotas no se ve afectada). **Si el accesorio mostrado ya está guardado, este elemento
  se convierte en "🎀 Renombrar Accesorio..."** (mismo
  icono): el diálogo se abre con el nombre actual y, al confirmar, el accesorio se
  **renombra**, se escribe en `accessories.json` y se actualiza en el desplegable "Elegir accesorio".
- **🧳 Elegir accesorio ▸** — desplegable independiente para cambiar el accesorio. Tiene
  `Selecciona...` (solo etiqueta) y `Ninguno` (limpia los accesorios) arriba, seguidos de los
  accesorios guardados. La **opción activa se resalta** (marcada con ✓); con la generación
  aleatoria de accesorios activada, no se marca ninguna. Elegir un accesorio enciende la
  visualización y desactiva el aleatorio.
- **🗑️ Eliminar accesorio ▸** — submenú que lista **solo los accesorios guardados** (`Ninguno`
  y `Selecciona...` nunca aparecen, son intocables). Al hacer clic pide confirmación y
  luego **elimina el accesorio permanentemente** de `accessories.json`. Tras eliminar, Zimmy
  **vuelve siempre a `Ninguno`** (el Default). Sin accesorios guardados, muestra
  "(no hay accesorios guardados)".
- **⚙️ Automatizaciones ▸** — submenú con las automatizaciones **puntuales** disponibles (scripts de
  la carpeta `Automacoes/` que se ejecutan una vez al hacer clic), cada una con un **icono ▶ play**
  verde a la izquierda. Está **deshabilitado** cuando no hay automatizaciones puntuales. Las
  automatizaciones **programadas** ahora viven en **⏱️ Temporizadores** (abajo). Ver **Automatizaciones** abajo.
- **⏱️ Temporizadores ▸** — su propio submenú **justo debajo de ⚙️ Automatizaciones**, que contiene las
  automatizaciones **programadas** (las que declaran `const SCHEDULE`/`SCHEDULE_SECONDS`) como
  elementos **marcables** (✓ = activado), cada uno con un pequeño **icono de reloj** a la izquierda y la
  **frecuencia en la etiqueta** — este es el **programador visual**, persistido en
  `user://schedules.json`. Ejemplos: `alarme.gd` (daily@08:00),
  `comemoracao_hora_cheia.gd` (hourly), `desligar_pc.gd` (daily@23:00),
  `lembrete_pomodoro.gd` (25m). Está **deshabilitado** cuando no hay automatizaciones programadas.
- **⏰ Recordatorios ▸** — recordatorios recurrentes **creados por el usuario**, **sin editar `.gd`**.
  **➕ Nuevo recordatorio…** abre un diálogo: un **mensaje** más un **desplegable de frecuencia** (cada
  15/30 min, 1 h, en punto, o **diariamente a las HH:MM** — aparece un campo de hora para la opción
  diaria). Cada recordatorio es un elemento **marcable** (✓ = activado) que **dice su mensaje** a la
  hora programada; **🗑️ Eliminar ▸** lo quita. Persistido en `user://reminders.json` y disparado por
  el mismo reloj que el programador.
- **💱 Monedas ▸** — su propio submenú en el menú principal, **debajo de ⚙️ Automatizaciones / ⏱️ Temporizadores**,
  que agrupa las cotizaciones de moneda (`MENU_GROUP := "moedas"`). Cada elemento muestra un pequeño **icono de bandera a
  la izquierda** — una textura dibujada en píxeles (`ICON_FLAG := "us"/"eu"/"gb"/"jp"/"cn"`), porque los emojis de bandera
  no se renderizan en `PopupMenu`. Está **deshabilitado** cuando no hay automatizaciones de moneda.
- **📝 Notas ▸** — un pequeño bloc de texto. **➕ Nueva nota...** abre un campo multilínea para
  escribir una nota; **📋 Pegar del portapapeles** convierte el texto actual del portapapeles en una nota.
  Las notas guardadas se listan abajo — **al hacer clic en una se copia de vuelta al portapapeles**;
  **🗑️ Eliminar nota ▸** las quita. En el menú cada nota se muestra como una vista previa de una línea
  **truncada a 30 caracteres con "..."** cuando es más larga. Las notas persisten en `user://notes.json`.
  Ver **Notas** abajo.
- **📧 Correos ▸** — submenú dedicado al proveedor de correo (Gmail), con el **icono a la
  izquierda** y el **contador de no leídos** en la etiqueta. Arriba, una casilla **🔊 Alerta de sonido**
  activa/desactiva un suave tintineo de entrega de correo que suena cuando llega un correo **nuevo**.
  Está **deshabilitado** si no hay automatizaciones de correo. Ver **Correos** abajo.
- **💬 WhatsApp ▸** — muestra el número de **chats de WhatsApp no leídos** como badge. Arriba,
  una casilla **🔊 Alerta de sonido** activa/desactiva un suave sonido de teléfono sonando que suena
  cuando llega un chat **nuevo**. **No** inicia sesión
  en WhatsApp (no hay API; la sesión está ligada a tu navegador) — simplemente
  **lee el título de la ventana de WhatsApp Web** que tu navegador mantiene abierta (el título
  se convierte en "(N) WhatsApp" cuando hay chats no leídos). Mantén **WhatsApp Web abierto y
  vinculado**. Ver **WhatsApp** abajo.
- **🌐 Idioma ▸** — elige el idioma de **todos los textos del sistema** (menú, diálogos y
  las frases de la mascota) entre **Português (Brasil)**, **English (US)** y **Español (España)**. El cambio es
  inmediato y la opción queda marcada (✓). Ver **Idioma** abajo.
- **❤️ Donar ▸** — submenú con dos formas de apoyar el proyecto: **GitHub Sponsors** y
  **Ko-fi**. Cada uno abre el enlace en tu navegador (`OS.shell_open`).
- **Salir**.

## Necesidades (barras de estado)

Tres **barras de colores** debajo de la mascota muestran las necesidades de **Alimentar / Acariciar
/ Jugar** (blanco / amarillo / rosa), cada una con su **icono del menú a la izquierda** (🦴 / 🤚 / 🎾)
y de 0 a 100% — solo el relleno de color, sin números. Solo se muestran cuando **📊 Estado** está
activado (desactivado por defecto, persistido). Los valores empiezan **llenos (100%)** en cada
arranque y **no** se persisten.

Cada barra **baja 1 punto cada 30 minutos**; hacer la acción correspondiente (Alimentar/Acariciar/Jugar)
rellena su barra al 100%. Cuando una barra llega a **0**, la mascota pone una cara: **Alimentar =
hambrienta, boca abierta**; **Acariciar = necesitada, llorando**; **Jugar = aburrida, ojos cerrados**.
Cuando **las tres** llegan a 0, Zimmy **cierra su propia ventana y termina el proceso**. Con la
**🔊 Alerta de sonido** de una acción activada, también suena un sonido de recordatorio en el momento en que su barra **cruza el 20%** hacia abajo (una vez por cruce).

## Reacciones y habla

Zimmy reacciona a lo que haces con el ratón: **pasar el ratón** sobre él dispara una expresión
feliz/animada; **hacer clic en un ojo** cierra ese ojo (un guiño) y lo mantiene cerrado mientras el
cursor permanece encima, reabriéndose al salir; **sacudir el ratón rápido** sobre él reproduce una
reacción aleatoria de **mareo / náusea / susto** (tambaleo con ojos en espiral, un balanceo mareado
de mejillas verdosas, o un temblor asustado con ojos muy abiertos). Todo es **procedural** —
animación + expresión facial, sin sprites.

**Bocadillo de diálogo** — dos carriles para que nada se pierda ni se vuelva spam. Las **reacciones**
(tus clics, hover, sacudida, saludo) aparecen **de inmediato** con prioridad. Las **notificaciones**
(automatizaciones, correos, cotizaciones de moneda, recordatorios) entran en una **cola** y cada una
se muestra durante **10 s** por turno, sin solaparse; mientras una reacción está en pantalla la
notificación **se pausa** y se reanuda después. Una notificación disparada por una **acción del usuario**
(p. ej. hiciste clic en la automatización) **se salta la cola** y se muestra al instante — incluso las
web asíncronas. Un mensaje que espera más de **60 s** en la cola se descarta.

## Idioma

Todos los textos del sistema tienen traducción en **Português (Brasil)**, **English (US)** y
**Español (España)**: los elementos del menú contextual, los diálogos (guardar/renombrar/eliminar/login) y las **frases de la mascota**
(saludo, reacciones de alimentar/acariciar/jugar, mal humor, avisos). Elige el idioma en
**🌐 Idioma ▸**; toda la interfaz cambia al instante y la elección se **persiste**
en `user://settings.json` (clave `lang`), volviendo en el mismo idioma en el siguiente
arranque. Las automatizaciones de la carpeta `Automacoes/` conservan los textos definidos por cada
script.

## Notas

El submenú **📝 Notas ▸** es un pequeño bloc de texto para recordatorios y fragmentos rápidos.
Crea una nota de dos maneras: **➕ Nueva nota...** abre un diálogo multilínea para escribir una, o
**📋 Pegar del portapapeles** convierte lo que haya actualmente en el portapapeles en una nota. Cada
nota guardada se lista (vista previa recortada a una línea); **al hacer clic en una nota se copia su texto
completo de vuelta al portapapeles**, listo para pegar en cualquier sitio. Elimina notas con **🗑️ Eliminar nota ▸**.
Todo se **persiste** en `user://notes.json` (una lista simple de cadenas), así que las notas
sobreviven a los reinicios.

## Automatizaciones

Las automatizaciones son scripts `.gd` colocados en la carpeta **`Automacoes/`** (en la raíz del
proyecto). Aparecen en el menú contextual bajo **⚙️ Automatizaciones** (las **puntuales**,
con un icono ▶ play) o **⏱️ Temporizadores** (las **programadas**, con un icono de reloj) — los
submenús se **reescanean cada vez que se abre el menú**, así que los scripts nuevos aparecen sin
reiniciar. Sin ningún script válido de un tipo, el elemento de menú correspondiente queda deshabilitado.

Cada automatización es un GDScript con:

- (opcional) `const AUTOMATION_NAME := "Nombre en el menú"` — texto mostrado en el submenú.
  Sin él, el nombre se deriva del archivo (`minha_automacao.gd` → "Minha
  Automacao").
- (opcional) `const AUTOMATION_NAME_EN := "Menu name"` — nombre en inglés, usado cuando el idioma
  de la app es English (US); de lo contrario cae en `AUTOMATION_NAME`.
- (opcional) `const AUTOMATION_NAME_ES := "Nombre en el menú"` — nombre en español, usado cuando
  el idioma de la app es Español (España); de lo contrario cae en `AUTOMATION_NAME`. Para el habla
  bilingüe/trilingüe de la mascota usa `zimmy.lang_text(pt, en, es)` (el tercer argumento `es` es el
  texto en español y es opcional, cayendo en el texto en portugués) y `zimmy.lang`; para números/fechas
  localizados usa `zimmy.fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (las automatizaciones
  de moneda las usan, así que valores y fechas siguen el idioma elegido).
- (opcional) `const SCHEDULE := "..."` — frecuencia para que Zimmy ejecute la automatización
  por su cuenta (ver **Programador** abajo).
- un método `run(zimmy)` — llamado al elegir el elemento (o en el disparo programado).
  `zimmy` es el nodo principal, que da acceso a `notify()`, `say()`, `celebrate()`, `feed()`,
  `pet()`, `play()`, `hop()`, `current`, y al estado (`hunger`, `happy`), etc.
  Los mensajes de automatización/correo deberían usar **`zimmy.notify(texto)`**: entran en una **cola y
  cada uno permanece visible 10 s por turno**, así que nunca se solapan. Un mensaje que espera más de
  **60 s** en la cola se descarta. Una notificación disparada por una **acción del usuario** (p. ej.
  hiciste clic en la automatización) **se salta la cola** y se muestra de inmediato — incluso las web
  asíncronas. `say()` es para **reacciones** inmediatas (se muestra al momento durante ~2,5 s, con prioridad
  sobre la cola).

Los scripts que hacen `extends RefCounted` se descartan tras `run()`; los que hacen `extends Node`
se añaden como hijos de Zimmy y **persisten** (útiles para automatizaciones continuas mediante
`_process`/timers). Ver `Automacoes/LEEME.md` y
`Automacoes/exemplo_automacao.gd.example` (renómbralo a `.gd` para activarlo) para las plantillas.

### Programador (frecuencia / recurrencia)

Una automatización que declara `const SCHEDULE` se ejecuta **por su cuenta** a la frecuencia
indicada, sin necesidad de hacer clic. Aparece en el submenú **⏱️ Temporizadores** como un
elemento **marcable** (✓ = activado) con un icono de reloj y el intervalo en la etiqueta — este es el
**programador visual**. Activarlo/desactivarlo es **persistente**: lo que estaba activado vuelve a ejecutarse al
reabrir Zimmy (estado en `user://schedules.json`). Formatos de `SCHEDULE`:
`"30s"`/`"5m"`/`"2h"` (cada N), `"hourly"` (cada hora en punto, en el minuto :00),
`"daily@09:00"` (1×/día a la hora); o `const SCHEDULE_SECONDS := 300` (segundos). Para
las programadas, el programador se encarga de la recurrencia — `run()` hace la acción **una vez** (usa
`extends RefCounted`).

### Automatizaciones web (`http_get_json`)

Las automatizaciones pueden obtener datos de internet con la utilidad `zimmy.http_get_json(url, cb)`
— hace un GET y llama a `cb.call(ok, data)` con el JSON decodificado, gestionando el
`HTTPRequest` por debajo. En la *closure* usa solo `zimmy` y variables locales
(no `self`), para que funcione tanto al hacer clic como en el disparo programado.

### Ejemplos listos (`Automacoes/`)

| Automatización | Archivo | Tipo |
|---|---|---|
| Recordatorio Pomodoro ☕ | `lembrete_pomodoro.gd` | cada 25min — te recuerda tomar un descanso |
| Celebrar la hora en punto 🎆 | `comemoracao_hora_cheia.gd` | `hourly` — celebra cada cambio de hora con **fuegos artificiales** (`zimmy.celebrate()`) + un pequeño baile |
| Cotización USD/EUR/GBP/JPY/CNY 💱 | `cotacao_*.gd` | puntual — cotización de la moneda en BRL ([AwesomeAPI](https://docs.awesomeapi.com.br/), gratis). Las 5 monedas de mayor influencia (cesta DEG) se agrupan en el submenú **💱 Monedas** del menú principal (`MENU_GROUP := "moedas"`), cada elemento con un pequeño **icono de bandera a la izquierda** (textura de `ICON_FLAG`) |
| Clima 🌤️ | `clima.gd` | puntual — clima actual vía [Open-Meteo](https://open-meteo.com/) (gratis, sin clave); detecta la ubicación por IP (fallback ipapi.co → ip-api.com) o define `LAT`/`LON` para fijar tu ciudad |
| Apagar el PC 🔌 | `desligar_pc.gd` | `daily@23:00` — apaga Windows con un aviso de 60s |
| Cancelar apagado ❌ | `cancelar_desligamento.gd` | puntual — aborta el apagado (`shutdown /a`) |
| Alarma ⏰ | `alarme.gd` | `daily@08:00` — avisa y da un pitido |
| Gmail 📧 | `email_gmail.gd` | cada 5min — cuenta los correos no leídos vía el **feed Atom** (`mail/feed/atom`, HTTP Basic + App Password); aparece en el submenú **📧 Correos** |
| WhatsApp 💬 | `whatsapp.gd` | cada 1min — cuenta los chats de WhatsApp no leídos **leyendo el título de la ventana de WhatsApp Web** (`tasklist`), sin API/login; aparece en el submenú **💬 WhatsApp** |

> **Precaución (apagar el PC):** `desligar_pc.gd` ejecuta un `shutdown` real. Viene **desactivado**
> por defecto y da un aviso de 60s; para abortar, ejecuta "Cancelar apagado".

### Correos (submenú 📧 Correos) — contador de no leídos

Las automatizaciones que declaran `const MENU_GROUP := "email"` aparecen en un submenú dedicado **📧
Correos**, con el **icono del proveedor a la izquierda** (color de `ICON_COLOR`) y el
**contador de no leídos en la etiqueta**, actualizado cada 5 min. **Gmail** (`email_gmail.gd`)
usa el ligero **feed Atom** — un único GET autenticado a `mail/feed/atom`
(`zimmy.http_get_auth(...)`) que devuelve `<fullcount>N</fullcount>`, sin máquina de estados IMAP,
autenticado con una **App Password** (HTTP Basic). Arriba del submenú, **🔔 Alerta de sonido**
(por defecto **activada**, persistida) reproduce un suave tintineo de entrega de correo cada vez que el contador
de no leídos **sube** (llegó un correo nuevo).

**Requisito previo — App Password** (la contraseña normal **ya no funciona**):

- **Gmail**: activa la verificación en 2 pasos y genera una *App Password* en
  [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords). El
  **feed Atom no necesita IMAP activado** — solo la App Password. Google la muestra en 4
  grupos de 4 — puedes pegarla **con o sin los espacios** (Zimmy los quita). Usa
  la **App Password**, no tu contraseña normal de Google.

**Paso a paso la primera vez**: la primerísima vez que activas **Gmail** (mientras aún no hay
credencial guardada), el diálogo de login muestra un breve **paso a paso de cómo generar la App
Password**, más un enlace clicable **"↗ Abrir la página de la App Password"** que abre la página
de Google en tu navegador. Cualquier automatización puede aportar su propia ayuda mediante los parámetros
opcionales `help_steps`/`help_url` de `zimmy.with_credentials(...)`.

**Credenciales**: cuando **activas** un proveedor en el menú, Zimmy pide *correo* +
*App Password*. Se guardan **por automatización** en `user://cred_<key>.json` (p. ej.
`cred_email_gmail.json`) — **fuera del repositorio** y cubiertas por `.gitignore`
(`cred_*.json`). El archivo está **cifrado** (AES, vía `FileAccess.open_encrypted_with_pass`)
con una clave derivada de un salt de la app + el ID de la máquina (`OS.get_unique_id`), así que no está en
texto plano ni funciona en otro ordenador. Solo se escriben/actualizan **tras un
login válido**; si la contraseña cambia y el login falla, el archivo se descarta y Zimmy
vuelve a preguntar. Los archivos de credenciales antiguos en texto plano se migran (se recifran) al leer. Reutiliza este
flujo en cualquier automatización con `zimmy.with_credentials(key, title, cb)` +
`zimmy.confirm_credentials(key, data)`.

### WhatsApp (submenú 💬 WhatsApp) — chats no leídos

La automatización `whatsapp.gd` (`MENU_GROUP := "whatsapp"`) muestra el número de **chats de WhatsApp
no leídos** como badge, cada minuto. **Importante — no se conecta a WhatsApp:**
no hay API pública y una sesión de WhatsApp Web está ligada criptográficamente al navegador
que escaneó el QR, así que no puede reutilizarse desde fuera. Automatizar el cliente de WhatsApp
(p. ej. con bibliotecas no oficiales) **violaría los Términos de WhatsApp y arriesgaría un baneo**, así que Zimmy
**no** lo hace. En su lugar hace pura **observación pasiva**: lee el **título de
la ventana de WhatsApp Web** que tu propio navegador mantiene abierta vía `tasklist` — WhatsApp pone
el título en `(N) WhatsApp` cuando hay chats no leídos, y un pequeño regex extrae `N`. No se
contacta con ningún servidor, no se inyecta nada.

**Requisito:** mantén **WhatsApp Web abierto y vinculado** a este dispositivo — idealmente como su
**propia ventana** (Chrome ▸ ⋮ ▸ *Enviar, guardar y compartir* ▸ *Crear acceso directo...* ▸ ✓ *Abrir como
ventana*) para que el contador se quede en el título incluso cuando no es la pestaña activa. Si la ventana
no se encuentra, el badge muestra `?` y Zimmy dice que no está abierta. Arriba del submenú,
**🔊 Alerta de sonido** (por defecto **activada**, persistida) reproduce un suave sonido de teléfono sonando cada vez
que el contador de no leídos **sube** (llegó un chat nuevo).

## Mascotas

- La mascota procedural original es el **Default** — siempre está disponible y **nunca se
  elimina**. La describe `_default_cfg()` en `zimmy.gd`.
- Cada mascota es una *config* (colores de cuerpo/barriga/oreja/mejilla/antena/nariz/cuerno +
  proporciones de oreja, ojo, cuerpo y barriga + ~una docena de categorías geométricas del "esqueleto":
  cola, cuerno, mechón, forma del ojo, pupila, ceja, patas, bracitos, marca en la barriga, bigotes, alas,
  pecas, más la silueta/oreja/boca). `_draw()` dibuja **todo proceduralmente**
  a partir de esa config (sin sprites), así que el mismo código genera el Default, los aleatorios
  y los guardados.
- **Generación aleatoria**: `_random_cfg()` busca una **estética equilibrada y colores
  alegres**:
  - **Arquetipos de criaturas** — cerca del **55%** de las mascotas aleatorias salen como un
    **animalito reconocible**: `cat`, `dog`, `bunny`, `bear`, `frog`, `fox`, `mouse` o `pig`
    (clave `critter`). El animal se define por la **forma** (orejas/boca/bigotes/cola/proporciones)
    — el **color sigue siendo aleatorio** (un gato morado es válido y adorable). El otro ~45% siguen
    siendo criaturas abstractas libres.
  - **Geometría** — sortea la **silueta del cuerpo** (`body_shape`: `round`/`tall`/
    `wide`/`pear`/`chubby`/`slim`), la **forma de oreja** (redonda/puntiaguda/caída), el
    **estilo de boca** (`smile`/`cat`/`open`/`line`/`tongue`/`fang`), las **proporciones**
    y la **presencia de elementos** (antenas, nariz, pestañas, mejillas).
  - **Categorías extra del "esqueleto"** (cada una sorteada de forma **independiente**): **cola**
    (`curl`/`puff`/`stub`), **cuerno** (`unicorn`/`devil`/`antlers`), **mechón**
    (`tuft`/`cowlick`/`mohawk`), **forma del ojo** (`oval`/`tall`/`sleepy`), **pupila**
    (`big`/`cat`/`sparkle`/`heart`), **ceja** (`flat`/`raised`/`serious`), **patas**,
    **bracitos**, **marca en la barriga** (`spot`/`heart`), **bigotes** (`short`/`long`),
    **alas**, **pecas**, **patrón en el cuerpo** (`spots`/`stripes`) y **hocico**. La mayoría
    tienen `none` con un peso mayor, así que las mascotas varían mucho sin sobrecargarse.
  - **Color** — parte de un matiz base y deriva los colores de realce mediante un
    **esquema de armonía** (análogo / complementario / triádico / mono), con saturación y
    brillo en rangos **vibrantes-pero-suaves** (tema alegre, evitando tonos sucios/oscuros)
    y garantizando contraste entre cuerpo y barriga.
- **Persistencia**: las mascotas guardadas se quedan en `user://pets.json` y reaparecen en el desplegable en
  la siguiente ejecución. (En Windows, `user://` está en
  `%APPDATA%\Godot\app_userdata\Zimmy Pet\`.)
- **La elección activa se recuerda**: la mascota seleccionada se escribe en
  `user://settings.json` y, al reabrir Zimmy, vuelve cargada y
  **preseleccionada** (✓) en el desplegable "Elegir mascota".
- **Eliminación permanente**: "🗑️ Eliminar mascota ▸" quita la mascota guardada de `pets.json` (con
  confirmación). El `Default` es intocable y nunca puede eliminarse.

## Accesorios

- Los accesorios son una **capa independiente de la mascota**, dibujada encima por
  `_draw_accessories()` y descrita por `_default_acc()`/`_random_acc()`. Cada categoría
  se **dibuja de forma independiente** (cada una con su propio color):
  - **Originales**: sombrero (`beanie`/`tophat`/`crown`/`cap`/`wizard`), gafas
    (`round`/`square`/`star`/`heart`/`sunglasses`), lazo (cabeza/cuello) y bufanda.
  - **Categorías extra**: collar (`pearls`/`pendant`), pendientes (`studs`/`hoops`),
    collarín (`plain`/`bell`), auriculares, monóculo, bigote (`curly`/`thin`), florecilla,
    broche (`star`/`heart`), corbata (`necktie`/`bowtie`), banda diagonal, máscara
    (`medical`/`ninja`), pegatina en la mejilla (`star`/`heart`), cinturón (`plain`/`buckle`) y
    mochila. La mayoría tienen `none` con un peso mayor, para variar sin exagerar.
- La **generación aleatoria** de accesorios tiene su propia casilla (**🎲 Accesorios
  aleatorios**), separada de la generación de mascotas. La **visualización** se controla con
  **👓 Mostrar accesorios** (activada por defecto). Como el Default no lleva nada, la visualización
  no cambia nada hasta que exista un accesorio.
- **Guardar/cargar son independientes de la mascota**: una mascota guardada no arrastra un accesorio
  consigo y viceversa. Esto permite combinar cualquier mascota con cualquier accesorio guardado.
- **Persistencia**: los accesorios guardados se quedan en `user://accessories.json` (separado de
  `pets.json`). La **elección activa** de accesorio (y el estado de **👓 Mostrar
  accesorios**) también se escribe en `user://settings.json` y se restaura en el siguiente
  arranque, volviendo **preseleccionada** (✓) en el desplegable "Elegir accesorio".
- **Eliminación permanente**: "🗑️ Eliminar accesorio ▸" quita el accesorio guardado de
  `accessories.json` (con confirmación). El `Ninguno` es intocable y nunca puede eliminarse.

## Cómo funciona la superposición

La "magia" de la superposición está en `project.godot`:

- `display/window/per_pixel_transparency/allowed=true` — habilita la transparencia por píxel
- `display/window/size/transparent=true` — fondo de ventana transparente (FLAG_TRANSPARENT)
- `display/window/size/borderless=true` — sin barra de título / bordes
- `display/window/size/always_on_top=true` — siempre por encima de las demás ventanas
- `application/boot_splash/show_image=false` — **oculta el logo de Godot** al arrancar
- `application/boot_splash/bg_color=Color(0, 0, 0, 0)` — fondo del splash transparente
  (sin cuadrado/pantalla de arranque visible al iniciar)

Y en `zimmy.gd`, `_ready()` refuerza la transparencia: `get_tree().root.transparent_bg = true`,
`get_window().set_flag(Window.FLAG_TRANSPARENT, true)` y
`RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))`. También desactiva el
*embed* de subventanas (`gui_embed_subwindows = false`) para que el menú y el diálogo aparezcan
como ventanas nativas, fuera de la ventanita de la mascota.

> **Importante (build exportado):** la transparencia por píxel solo funciona con el
> renderizador **Compatibility (OpenGL)** — en Forward+ (Vulkan) la ventana exportada obtiene un
> cuadrado negro. Además, **MSAA 2D** debe estar apagado (también pinta el fondo de
> negro). Ambos ya están configurados en `project.godot`.

Zimmy se dibuja proceduralmente en `_draw()` (elipses + la curva de la boca), con respiración,
parpadeo, ojos que siguen el cursor global del ratón y **animaciones de reacción variadas**:
cada acción del menú dispara un movimiento **elegido al azar** de un conjunto adecuado a la
energía de esa acción — `hop`, `double_hop`, `triple_hop`, `spin`, `spin_jump`, `backflip`, `wiggle`,
`nod`, `squish`, `tilt`, `dance` (saltos físicos combinados con rotación, squash-stretch y
balanceo en torno a un pivote). La sombra permanece en el suelo y las barras de estado no se ven afectadas.

### Bocadillo de diálogo dinámico

Cuando Zimmy habla, la **ventana crece y se encoge dinámicamente** para acomodar la frase (y
los emojis) — ver `_relayout()` en `zimmy.gd`. El ancho mide el texto con la fuente real
y crece solo lo necesario; las frases más anchas que `MAX_W = 300 px` **se dividen en varias líneas**
(por palabras). Zimmy permanece **anclado por su centro-inferior**, así que no se desplaza cuando el
bocadillo aparece o desaparece; la posición de la ventana viene solo de ese ancla (sin reclamp por el
borde de la pantalla), así que un bocadillo demasiado grande puede desbordarse hacia el borde de la pantalla en lugar de
desplazar la mascota. Por eso `stretch/mode` se queda en `disabled` (1 unidad = 1 píxel),
de lo contrario el canvas se estiraría al redimensionar.

> **Nota (fuente/emojis):** usa la **fuente por defecto** de Godot en el bocadillo — renderiza acentos
> y emojis en color en el renderizador Compatibility. Una `SystemFont` (Segoe UI) hace que el
> texto desaparezca en este renderizador.

### Expresiones faciales (reflejan el emoji)

Mientras Zimmy habla, **la cara refleja la emoción del emoji** de la frase. `say()`
deduce la expresión vía `_expression_from_text()` y `_draw()` dibuja los
ojos y la boca correspondientes en `_draw_expression()`:

| Expresión | Emojis (disparador) | Cara |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | ojos cerrados felices (∩), rubor, gran sonrisa |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | ojos muy abiertos con un brillo, boca abierta |
| `angry` | 😠 😤 😡 💢 | cejas fruncidas, ojos estrechos, boca haciendo pucheros |
| `sad` | 😢 😞 😭 🥺 | cejas caídas, mirada hacia abajo, lágrima |
| `disgust` | 🤢 🤮 😖 | ojo torcido, boca ondulada, lengüita |
| `indifferent` | 😑 🙄 😒 🫤 | ojos aburridos (guiones), boca recta |
| `sleepy` | 😴 💤 🥱 | ojos cerrados (∪), boquita |

Sin emoji emotivo (o sin habla), vuelve a la cara por defecto (ojos siguiendo el
cursor + la boca de la config). Como las frases de mal humor usan estos emojis, **insistir en
una acción** hace que Zimmy muestre enfado/asco/tristeza/indiferencia en la cara, no solo en
el texto.

## Ideas de evolución

- **Click-through**: `get_window().mouse_passthrough_polygon` con el contorno del cuerpo, para
  hacer clic en el escritorio detrás de las partes transparentes.
- **Caminar por su cuenta**: animar `get_window().position` para que pasee por el borde de la
  pantalla.
- **AnimatedSprite2D**: cambiar `_draw()` por sprites/spritesheets si quieres arte más rico.
- **Renombrar/quitar mascotas guardadas**: hoy el desplegable solo añade; el Default es fijo.
- **Lanzar desde un juego**: `OS.create_process()` desde otra app para abrir la mascota junto a ella.

## Licencia

© 2026 Renato Zimerfeld. Esta obra está licenciada bajo la **Licencia Creative Commons Atribución-NoComercial-SinObraDerivada 4.0 Internacional (CC BY-NC-ND 4.0)** — eres libre de compartirla con fines no comerciales con la atribución adecuada, pero **no** puedes usarla comercialmente ni distribuir versiones modificadas. Consulta [LICENSE.md](LICENSE.md) para los términos completos.
