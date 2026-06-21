# Zimmy Pet 🧡

Desktop pet overlay, made in Godot 4.6.
A transparent, borderless, always-on-top window that floats over the desktop.
The pet is drawn in a logical space of **200×200** and displayed at **75%** (≈150 px,
`PET_SCALE`). The window also reserves a transparent strip above the pet
(`HOP_HEADROOM`) so the **little hop** is not cut off, and it grows dynamically when
Zimmy speaks.

## How to run

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe" --path "C:\GODOT\ZIMMY"
```

Or open the folder in Godot and press **F5**.

## Icon

Zimmy's icon is generated procedurally (the same little face from `_draw()`) by
`tools/make_icon.py` (needs Python + Pillow):

```powershell
py tools/make_icon.py
```

It generates two files from the same drawing, for different uses:

- **`icon.png`** — the **Godot** icon (editor + the app's window/taskbar). Defined in
  `project.godot` (`config/icon`). Godot uses PNG and does not accept `.ico` here.
- **`zimmy.ico`** — the **Windows executable** icon (multi-size `.ico` format, 16→256).
  Used by the export preset and embedded in the `.exe` via `rcedit`.

## Building the .exe (Windows)

Prerequisites: Godot 4.6.2 **export templates** installed and the `Windows Desktop`
preset (already versioned in `export_presets.cfg`, pointing to `zimmy.ico`).

```powershell
& "C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" `
  --headless --path "C:\GODOT\ZIMMY" `
  --export-release "Windows Desktop" "C:\GODOT\ZIMMY\build\ZimmyPet.exe"
```

The executable (standalone, with the `.pck` embedded) is generated at
**`build/ZimmyPet.exe`**.

To embed the Zimmy icon into the `.exe` itself (in case `rcedit` is not configured in
the editor), run afterward:

```powershell
C:\GODOT\rcedit-x64.exe "C:\GODOT\ZIMMY\build\ZimmyPet.exe" --set-icon "C:\GODOT\ZIMMY\zimmy.ico"
```

## Controls

| Action | Result |
|------|-----------|
| Drag (left button) | Moves Zimmy around the screen (the position is saved) |
| Click (without dragging) | He reacts with a "hi" |
| Right button | Opens the context menu (below), positioned beside the pet without covering it and always within the screen |
| Esc | Closes |

> **Position on screen:** on the first run Zimmy opens **centered**. After that,
> every time you drag him the position is written to `user://settings.json` and he
> reopens in the **last place** where he was. That same file also stores the **last
> pet and accessory choice**, restored automatically when reopening.

### Context menu

> When you click the **right button**, the menu appears **beside the pet** (it tries
> right → left → below → above), so as to **not cover the pet** and **not go past the
> screen edges**. If no side fits, it is fitted within the visible area.

- **🦴 Feed / 🤚 Pet / 🎾 Play** — interactions that change mood/hunger.
- **🎲 Random pets** (check) — toggles continuous generation **of the pet**: every ~9 s
  Zimmy turns into a random pet. Besides colors, it varies the **shapes** and which
  **elements** make him up (round or pointy ears, antennas, nose, eyelashes, cheeks,
  and the mouth style).
- **🎲 Random accessories** (check) — independent from the previous one: toggles
  continuous generation **of the accessories** (every ~9 s it draws a
  hat/glasses/bow/scarf). Turning it on also automatically turns on the accessory
  display.
- **👓 Show accessories** (check) — toggles the display of the accessory layer (hat,
  glasses, bow, scarf), independently of the pet.
- **💾 Save Pet...** — opens a dialog to name and save **only the pet** shown. Opening
  the dialog **freezes pet generation** (unchecks "🎲 Random pets") so that exactly
  what is on screen is saved; on **confirm**, the "🎲 Random pets" checkbox stays
  unchecked. Accessory generation is not affected. **If the displayed pet is already a
  saved pet, this item becomes
  "💾 Rename Pet..."** (same icon): the dialog opens with the current name pre-filled
  and, on confirm, the pet is **renamed** — the change is written to `pets.json` and the
  "Choose pet" dropdown is updated right away.
- **📂 Choose pet ▸** — dropdown to switch the displayed pet. It always has
  `Select...` (index 0, label only) and `Default` (index 1) at the top, followed by the
  saved pets. The **active option is highlighted** (marked with ✓) so you can see at a
  glance which pet is in use; with random generation on, none is marked. Choosing a
  specific pet turns off random generation.
- **🗑️ Delete pet ▸** — submenu that lists **only the saved pets** (`Default` and
  `Select...` never appear, they are untouchable). Clicking asks for confirmation and
  then **permanently deletes the pet** from `pets.json`. After deleting, Zimmy **always
  reloads `Default`**. With no saved pets, it shows "(no saved pets)".
- **🎀 Save Accessory...** — opens a dialog to name and save **only the current
  accessory** (independently of the pet). Opening it **freezes accessory generation**
  and, on **confirm**, the "🎲 Random accessories" checkbox stays unchecked (pet
  generation is not affected). **If the displayed accessory is already saved, this item
  becomes "🎀 Rename Accessory..."** (same
  icon): the dialog opens with the current name and, on confirm, the accessory is
  **renamed**, written to `accessories.json` and updated in the "Choose accessory"
  dropdown.
- **🧳 Choose accessory ▸** — independent dropdown to switch the accessory. It has
  `Select...` (label only) and `None` (clears the accessories) at the top, followed by
  the saved accessories. The **active option is highlighted** (marked with ✓); with
  random accessory generation on, none is marked. Choosing an accessory turns on the
  display and turns off random.
- **🗑️ Delete accessory ▸** — submenu that lists **only the saved accessories** (`None`
  and `Select...` never appear, they are untouchable). Clicking asks for confirmation
  and then **permanently deletes the accessory** from `accessories.json`. After
  deleting, Zimmy **always returns to `None`** (the Default). With no saved accessories,
  it shows "(no saved accessories)".
- **⚙️ Automations ▸** — submenu with the available automations (scripts from the
  `Automacoes/` folder). It is **disabled** when there are no automations. **One-off**
  automations appear as buttons (run once when clicked); **scheduled** automations
  appear as **checkable** items (✓ = on) with the frequency in the label — this is the
  **visual scheduler**. See **Automations** below.
- **📧 E-mails ▸** — submenu dedicated to the e-mail providers (Gmail, Outlook), each
  with the **icon on the left** and the **unread counter** in the label. It is
  **disabled** if there are no e-mail automations. See **E-mails** below.
- **🌐 Language ▸** — chooses the language of **all system texts** (menu, dialogs and
  the pet's speech) between **Português (Brasil)** and **English (US)**. The switch is
  immediate and the option stays marked (✓). See **Language** below.
- **Quit**.

## Language

All system texts have a translation in **Português (Brasil)** and **English (US)**:
the context menu items, the dialogs (save/rename/delete/login) and the **pet's speech**
(greeting, feed/pet/play reactions, bad mood, warnings). Choose the language in
**🌐 Language ▸**; the whole interface changes instantly and the choice is **persisted**
in `user://settings.json` (`lang` key), coming back in the same language on the next
launch. The automations in the `Automacoes/` folder keep the texts defined by each
script.

## Automations

Automations are `.gd` scripts placed in the **`Automacoes/`** folder (at the project
root). They appear in the context menu under **⚙️ Automations** — the submenu is
**rescanned every time the menu opens**, so new scripts appear without restarting. With
no valid script, the menu item is disabled.

Each automation is a GDScript with:

- (optional) `const AUTOMATION_NAME := "Name in the menu"` — text shown in the submenu.
  Without it, the name is derived from the file (`minha_automacao.gd` → "Minha
  Automacao").
- (optional) `const SCHEDULE := "..."` — frequency for Zimmy to run the automation on
  its own (see **Scheduler** below).
- a `run(zimmy)` method — called when choosing the item (or on the scheduled trigger).
  `zimmy` is the main node, giving access to `say()`, `feed()`, `pet()`, `play()`,
  `hop()`, `current`, and to the state (`hunger`, `happy`), etc.

Scripts that `extends RefCounted` are discarded after `run()`; those that `extends Node`
are added as children of Zimmy and **persist** (useful for continuous automations via
`_process`/timers). See `Automacoes/LEIAME.md` and
`Automacoes/exemplo_automacao.gd.example` (rename to `.gd` to enable) for the templates.

### Scheduler (frequency / recurrence)

An automation that declares `const SCHEDULE` runs **on its own** at the indicated
frequency, without needing to click. It appears in the **⚙️ Automations** submenu as a
**checkable** item (✓ = on) with the interval in the label — this is the **visual
scheduler**. Turning it on/off is **persistent**: whatever was on runs again when
reopening Zimmy (state in `user://schedules.json`). `SCHEDULE` formats:
`"30s"`/`"5m"`/`"2h"` (every N), `"hourly"` (every full hour, at minute :00),
`"daily@09:00"` (1×/day at the time); or `const SCHEDULE_SECONDS := 300` (seconds). For
scheduled ones, the scheduler handles recurrence — `run()` does the action **once** (use
`extends RefCounted`).

### Web automations (`http_get_json`)

Automations can fetch data from the internet with the `zimmy.http_get_json(url, cb)`
utility — it does a GET and calls `cb.call(ok, data)` with the decoded JSON, handling
the `HTTPRequest` under the hood. In the *closure* use only `zimmy` and local variables
(not `self`), so it works both on click and on the scheduled trigger.

### Ready-made examples (`Automacoes/`)

| Automation | File | Type |
|---|---|---|
| Auto-feed 🦴 | `auto_alimentar.gd` | every 20s — feeds if hungry |
| Pomodoro reminder ☕ | `lembrete_pomodoro.gd` | every 25min — reminds you to take a break |
| Celebrate full hour 🎉 | `comemoracao_hora_cheia.gd` | `hourly` — celebrates each turn of the hour |
| USD/EUR/GBP/JPY/CNY quote 💱 | `cotacao_*.gd` | one-off — currency quote in BRL ([AwesomeAPI](https://docs.awesomeapi.com.br/), free). The 5 most influential currencies (SDR basket) form the "currencies submenu" under ⚙️ Automations |
| Shut down PC 🔌 | `desligar_pc.gd` | `daily@23:00` — shuts down Windows with a 60s warning |
| Cancel shutdown ❌ | `cancelar_desligamento.gd` | one-off — aborts the shutdown (`shutdown /a`) |
| Alarm ⏰ | `alarme.gd` | `daily@08:00` — hops, warns and gives a beep |
| Gmail / Outlook 📧 | `email_gmail.gd`, `email_outlook.gd` | every 5min — count unread e-mails via IMAP; appear in the **📧 E-mails** submenu |

> **Caution (shut down PC):** `desligar_pc.gd` runs a real `shutdown`. It comes **off**
> by default and gives a 60s warning; to abort, run "Cancel shutdown".

### E-mails (📧 E-mails submenu) — unread counter

Automations that declare `const MENU_GROUP := "email"` appear in a dedicated **📧
E-mails** submenu, with the **provider icon on the left** (color from `ICON_COLOR`) and
the **unread counter in the label**. Each provider (`email_gmail.gd`,
`email_outlook.gd`) fetches the count via **IMAP over TLS** (`zimmy.imap_unread(...)`)
every 5 min.

**Prerequisite — App Password** (the normal password **no longer works**):

- **Gmail**: enable 2-step verification and generate an *App Password* at
  [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords); check
  that **IMAP is enabled** (Gmail ▸ Settings ▸ Forwarding and POP/IMAP).
- **Outlook/Hotmail**: generate an *App password* at
  [account.microsoft.com/security](https://account.microsoft.com/security). **Corporate
  Microsoft 365** accounts usually have IMAP/basic **disabled** by the admin — then it
  does not work.

**Credentials**: when you **turn on** a provider in the menu, Zimmy asks for *e-mail* +
*App Password*. They are saved **per automation** in `user://cred_<key>.json` (e.g.
`cred_email_gmail.json`) — **outside the repository** and covered by `.gitignore`
(`cred_*.json`). They are only written/updated **after a valid login**; if the password
changes and the login fails, the file is discarded and Zimmy asks again. Reuse this flow
in any automation with `zimmy.with_credentials(key, title, cb)` +
`zimmy.confirm_credentials(key, data)`.

## Pets

- The original procedural pet is the **Default** — it is always available and **never
  removed**. It is described by `_default_cfg()` in `zimmy.gd`.
- Each pet is a *config* (body/belly/ear/cheek/antenna/nose/horn colors + ear, eye, body
  and belly proportions + ~a dozen geometric categories of the "skeleton": tail, horn,
  tuft, eye shape, pupil, eyebrow, paws, little arms, belly mark, whiskers, wings,
  freckles, plus the silhouette/ear/mouth). `_draw()` draws **everything procedurally**
  from that config (no sprites), so the same code generates the Default, the random ones
  and the saved ones.
- **Random generation**: `_random_cfg()` aims for a **balanced aesthetic and cheerful
  colors**:
  - **Geometry** — it draws the **body silhouette** (`body_shape`: `round`/`tall`/
    `wide`/`pear` — standing egg, cute shorty or teardrop body), the **ear shape**
    (round/pointy), the **mouth style** (`smile`/`cat`/`open`/`line`), the
    **proportions** and the **presence of elements** (antennas, nose, eyelashes,
    cheeks).
  - **Extra "skeleton" categories** (each one drawn **independently**, to break away
    from the Default): **tail** (`curl`/`puff`/`stub`), **horn**
    (`unicorn`/`devil`/`antlers`, with its own color), **tuft** (`tuft`/`cowlick`/
    `mohawk`), **eye shape** (`oval`/`tall`/`sleepy`), **pupil** (`big`/`cat`/`sparkle`),
    **eyebrow** (`flat`/`raised`/`serious`), **paws**, **little arms**, **belly mark**
    (`spot`/`heart`), **whiskers** (`short`/`long`), **wings** and **freckles**. Most
    have `none` with a higher weight, so the pets vary a lot without getting
    overloaded.
  - **Color** — it starts from a base hue and derives the highlight colors via a
    **harmony scheme** (analogous / complementary / triadic / mono), with saturation and
    brightness in **vibrant-yet-soft** ranges (cheerful theme, avoiding dirty/dark tones)
    and ensuring contrast between body and belly.
- **Persistence**: saved pets stay in `user://pets.json` and reappear in the dropdown on
  the next run. (On Windows, `user://` is at
  `%APPDATA%\Godot\app_userdata\Zimmy Pet\`.)
- **The active choice is remembered**: the selected pet is written to
  `user://settings.json` and, on reopening Zimmy, it comes back loaded and
  **pre-selected** (✓) in the "Choose pet" dropdown.
- **Permanent deletion**: "🗑️ Delete pet ▸" removes the saved pet from `pets.json` (with
  confirmation). The `Default` is untouchable and can never be deleted.

## Accessories

- The accessories are a **layer independent of the pet**, drawn on top by
  `_draw_accessories()` and described by `_default_acc()`/`_random_acc()`. Each category
  is **drawn independently** (each with its own color):
  - **Originals**: hat (`beanie`/`tophat`/`crown`/`cap`), glasses
    (`round`/`square`/`star`), bow (head/neck) and scarf.
  - **Extra categories** (~a dozen): necklace (`pearls`/`pendant`), earrings
    (`studs`/`hoops`), collar (`plain`/`bell`), headphones, monocle, mustache
    (`curly`/`thin`), little flower, brooch (`star`/`heart`), tie (`necktie`/`bowtie`),
    diagonal sash (`sash`), mask (`medical`/`ninja`) and cheek sticker
    (`star`/`heart`). Most have `none` with a higher weight, to vary without
    overdoing it.
- The **random generation** of accessories has its own checkbox (**🎲 Random
  accessories**), separate from pet generation. The **display** is controlled by
  **👓 Show accessories** (on by default). Since the Default wears nothing, the display
  changes nothing until an accessory exists.
- **Save/load are independent of the pet**: a saved pet does not carry an accessory along
  and vice versa. This lets you combine any pet with any saved accessory.
- **Persistence**: saved accessories stay in `user://accessories.json` (separate from
  `pets.json`). The **active choice** of accessory (and the state of **👓 Show
  accessories**) is also written to `user://settings.json` and restored on the next
  launch, coming back **pre-selected** (✓) in the "Choose accessory" dropdown.
- **Permanent deletion**: "🗑️ Delete accessory ▸" removes the saved accessory from
  `accessories.json` (with confirmation). The `None` is untouchable and can never be
  deleted.

## How the overlay works

The overlay's "magic" is in `project.godot`:

- `display/window/per_pixel_transparency/allowed=true` — enables per-pixel transparency
- `display/window/size/transparent=true` — transparent window background (FLAG_TRANSPARENT)
- `display/window/size/borderless=true` — no title bar / borders
- `display/window/size/always_on_top=true` — always above the other windows
- `application/boot_splash/show_image=false` — **hides the Godot logo** on startup
- `application/boot_splash/bg_color=Color(0, 0, 0, 0)` — transparent splash background
  (no square/splash screen visible on launch)

And in `zimmy.gd`, `_ready()` reinforces the transparency: `get_tree().root.transparent_bg = true`,
`get_window().set_flag(Window.FLAG_TRANSPARENT, true)` and
`RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))`. It also disables the
*embed* of subwindows (`gui_embed_subwindows = false`) so the menu and the dialog appear
as native windows, outside the pet's little window.

> **Important (exported build):** per-pixel transparency only works with the
> **Compatibility (OpenGL)** renderer — on Forward+ (Vulkan) the exported window gets a
> black square. Besides that, **MSAA 2D** must be off (it also paints the background
> black). Both are already configured in `project.godot`.

Zimmy is drawn procedurally in `_draw()` (ellipses + the mouth curve), with breathing,
blinking, little hops and eyes that follow the global mouse cursor.

### Dynamic speech bubble

When Zimmy speaks, the **window grows and shrinks dynamically** to fit the phrase (and
emojis) without cuts or unnecessary line breaks — see `_relayout()` in `zimmy.gd`. The
width measures the text with the real font and grows only as needed; very long phrases
(above `MAX_W = 640 px`) wrap by words. Zimmy stays **anchored by his bottom-center**, so
he does not shift when the bubble appears or disappears, and the window is kept within
the screen (clamp). That is why `stretch/mode` stays `disabled` (1 unit = 1 pixel),
otherwise the canvas would stretch when resizing.

> **Note (font/emojis):** use Godot's **default font** in the bubble — it renders accents
> and colored emojis on the Compatibility renderer. A `SystemFont` (Segoe UI) makes the
> text disappear on this renderer.

### Facial expressions (mirror the emoji)

While Zimmy speaks, **the face reflects the emotion of the emoji** in the phrase. `say()`
deduces the expression via `_expression_from_text()` and `_draw()` draws the
corresponding eyes and mouth in `_draw_expression()`:

| Expression | Emojis (trigger) | Face |
|---|---|---|
| `happy` | 🥰 😋 😍 🤩 🧡 ✨ | happy closed eyes (∩), blush, big smile |
| `excited` | 🚀 🎾 🎉 🎲 ⭐ | wide eyes with a sparkle, open mouth |
| `angry` | 😠 😤 😡 💢 | furrowed eyebrows, narrow eyes, pouting mouth |
| `sad` | 😢 😞 😭 🥺 | drooping eyebrows, downward gaze, tear |
| `disgust` | 🤢 🤮 😖 | crooked eye, wavy mouth, little tongue |
| `indifferent` | 😑 🙄 😒 🫤 | bored eyes (dashes), straight mouth |
| `sleepy` | 😴 💤 🥱 | closed eyes (∪), little mouth |

With no emotive emoji (or no speech), it returns to the default face (eyes following the
cursor + the config's mouth). Since the bad-mood phrases use these emojis, **insisting on
an action** makes Zimmy show anger/disgust/sadness/indifference on his face, not just in
the text.

## Evolution ideas

- **Click-through**: `get_window().mouse_passthrough_polygon` with the body's outline, to
  click the desktop behind the transparent parts.
- **Walk on its own**: animate `get_window().position` so he strolls along the screen
  edge.
- **AnimatedSprite2D**: swap `_draw()` for sprites/spritesheets if you want richer art.
- **Rename/remove saved pets**: today the dropdown only adds; the Default is fixed.
- **Launch from a game**: `OS.create_process()` from another app to open the pet
  alongside.
