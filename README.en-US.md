# Zimmy Pet 🧡

<p align="center">
  <img src="icon.png" alt="Zimmy — the default pet" width="180">
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

> Zimmy is built and maintained in my free time. If this little desktop pet makes you smile, a sponsorship helps keep it updated. 💜

> The default pet (the procedural face from `_draw()`, the same drawing used for the icon).

Desktop pet overlay, made in Godot 4.6.
A transparent, borderless, always-on-top window that floats over the desktop.
The pet is drawn in a logical space of **200×200** and displayed at **75%** (≈150 px,
`PET_SCALE`). The window reserves a transparent strip above the pet (`HOP_HEADROOM`) so the
**little hop** (on feed/pet/play) is not cut off, and it grows dynamically when Zimmy speaks.
The pet stays **anchored by its bottom-center**: an oversized speech bubble that exceeds the
window may overflow toward the screen edge, but it **never displaces the pet**.

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

- **📊 Status** (check) — toggles the **status bars** below the pet (Feed/Pet/Play). It is
  **off by default**; the choice is **persisted** in `user://settings.json` (`status` key).
- **🦴 Feed / 🤚 Pet / 🎾 Play** — interactions that change mood/hunger.
- **🐶 Random pets** (check) — toggles continuous generation **of the pet**: every ~10 s
  Zimmy turns into a random pet. Besides colors, it varies the **shapes** and which
  **elements** make him up (round or pointy ears, antennas, nose, eyelashes, cheeks,
  and the mouth style). Each new pet gets a **welcome phrase and a suggested name** —
  that name pre-fills the text box (selected) when you Save or Rename it. Names are
  **combinatorial** (noun + adjective, ~900 combos per language), so they rarely repeat.
- **🎲 Random accessories** (check) — independent from the previous one: toggles
  continuous generation **of the accessories** (every ~10 s it draws a
  hat/glasses/bow/scarf). Turning it on also automatically turns on the accessory
  display. Each new accessory gets a **congratulations phrase and a suggested name**
  that pre-fills the text box when you Save or Rename it (also **combinatorial**, ~900
  combos per language).
- **👓 Show accessories** (check) — toggles the display of the accessory layer (hat,
  glasses, bow, scarf), independently of the pet.
- **💾 Save Pet...** — opens a dialog to name and save **only the pet** shown. Opening
  the dialog **freezes pet generation** (unchecks "🐶 Random pets") so that exactly
  what is on screen is saved; on **confirm**, the "🐶 Random pets" checkbox stays
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
- **⚙️ Automations ▸** — submenu with the available **one-off** automations (scripts from
  the `Automacoes/` folder that run once when clicked), each with a green **▶ play icon**
  on the left. It is **disabled** when there are no one-off automations. **Scheduled**
  automations now live in **⏱️ Timers** (below). See **Automations** below.
- **⏱️ Timers ▸** — its own submenu **right below ⚙️ Automations**, holding the
  **scheduled** automations (those that declare `const SCHEDULE`/`SCHEDULE_SECONDS`) as
  **checkable** items (✓ = on), each with a small **clock icon** on the left and the
  **frequency in the label** — this is the **visual scheduler**, persisted in
  `user://schedules.json`. Examples: `alarme.gd` (daily@08:00), `auto_alimentar.gd` (20s),
  `comemoracao_hora_cheia.gd` (hourly), `desligar_pc.gd` (daily@23:00),
  `lembrete_pomodoro.gd` (25m). It is **disabled** when there are no scheduled automations.
- **💱 Currencies ▸** — its own submenu in the main menu, **below ⚙️ Automations / ⏱️ Timers**,
  grouping the currency quotes (`MENU_GROUP := "moedas"`). Each item shows a small **flag icon on
  the left** — a pixel-drawn texture (`ICON_FLAG := "us"/"eu"/"gb"/"jp"/"cn"`), because flag emoji
  don't render in `PopupMenu`. It is **disabled** when there are no currency automations.
- **📝 Notes ▸** — a small text scratchpad. **➕ New note...** opens a multiline field to
  type a note; **📋 Paste from clipboard** turns the current clipboard text into a note.
  Saved notes are listed below — **clicking one copies it back to the clipboard**;
  **🗑️ Delete note ▸** removes them. In the menu each note is shown as a single-line preview
  **truncated to 30 characters with "..."** when longer. Notes persist in `user://notes.json`.
  See **Notes** below.
- **📧 E-mails ▸** — submenu dedicated to the e-mail provider (Gmail), with the **icon on
  the left** and the **unread counter** in the label. At the top, a **🔊 Sound alert**
  checkbox toggles a soft mailbox-delivery chime that plays when a **new** e-mail arrives.
  It is **disabled** if there are no e-mail automations. See **E-mails** below.
- **💬 WhatsApp ▸** — shows the number of **unread WhatsApp chats** as a badge. At the top,
  a **🔊 Sound alert** checkbox toggles a soft phone-ringing sound that plays when a **new**
  chat arrives. It does
  **not** log into WhatsApp (there's no API; the session is tied to your browser) — it
  simply **reads the title of the WhatsApp Web window** your browser keeps open (the title
  becomes "(N) WhatsApp" when there are unread chats). Keep **WhatsApp Web open and
  linked**. See **WhatsApp** below.
- **🌐 Language ▸** — chooses the language of **all system texts** (menu, dialogs and
  the pet's speech) between **Português (Brasil)** and **English (US)**. The switch is
  immediate and the option stays marked (✓). See **Language** below.
- **❤️ Donate ▸** — submenu with two ways to support the project: **GitHub Sponsors** and
  **Ko-fi**. Each opens the link in your browser (`OS.shell_open`).
- **Quit**.

## Needs (status bars)

Three **colored bars** below the pet show the **Feed / Pet / Play** needs (white / yellow
/ pink), each with its **menu icon on the left** (🦴 / 🤚 / 🎾) and from 0 to 100% — just
the colored fill, no numbers. They are shown only when **📊 Status** is on (off by
default, persisted). The values start **full (100%)** on every launch and are **not**
persisted.

Each bar **drops 1 point every 30 minutes**; doing the matching action (Feed/Pet/Play)
refills its bar to 100%. When a bar hits **0**, the pet shows a face: **Feed = hungry,
mouth open**; **Pet = needy, crying**; **Play = bored, eyes closed**. When **all three**
reach 0, Zimmy **closes its own window and ends the process**.

## Language

All system texts have a translation in **Português (Brasil)** and **English (US)**:
the context menu items, the dialogs (save/rename/delete/login) and the **pet's speech**
(greeting, feed/pet/play reactions, bad mood, warnings). Choose the language in
**🌐 Language ▸**; the whole interface changes instantly and the choice is **persisted**
in `user://settings.json` (`lang` key), coming back in the same language on the next
launch. The automations in the `Automacoes/` folder keep the texts defined by each
script.

## Notes

The **📝 Notes ▸** submenu is a small text scratchpad for quick reminders and snippets.
Create a note in two ways: **➕ New note...** opens a multiline dialog to type one, or
**📋 Paste from clipboard** turns whatever is currently on the clipboard into a note. Each
saved note is listed (preview trimmed to one line); **clicking a note copies its full text
back to the clipboard**, ready to paste anywhere. Remove notes via **🗑️ Delete note ▸**.
Everything is **persisted** in `user://notes.json` (a plain list of strings), so notes
survive restarts.

## Automations

Automations are `.gd` scripts placed in the **`Automacoes/`** folder (at the project
root). They appear in the context menu under **⚙️ Automations** (the **one-off** ones,
with a ▶ play icon) or **⏱️ Timers** (the **scheduled** ones, with a clock icon) — the
submenus are **rescanned every time the menu opens**, so new scripts appear without
restarting. With no valid script of a kind, the corresponding menu item is disabled.

Each automation is a GDScript with:

- (optional) `const AUTOMATION_NAME := "Name in the menu"` — text shown in the submenu.
  Without it, the name is derived from the file (`minha_automacao.gd` → "Minha
  Automacao").
- (optional) `const AUTOMATION_NAME_EN := "Menu name"` — English name, used when the app
  language is English (US); falls back to `AUTOMATION_NAME` otherwise. For bilingual pet
  speech use `zimmy.lang_text(pt, en)` and `zimmy.lang`; for localized numbers/dates use
  `zimmy.fmt_num` / `fmt_pct` / `fmt_money_brl` / `fmt_quote_date` (the currency
  automations use these, so values and dates follow the chosen language).
- (optional) `const SCHEDULE := "..."` — frequency for Zimmy to run the automation on
  its own (see **Scheduler** below).
- a `run(zimmy)` method — called when choosing the item (or on the scheduled trigger).
  `zimmy` is the main node, giving access to `notify()`, `say()`, `feed()`, `pet()`,
  `play()`, `hop()`, `current`, and to the state (`hunger`, `happy`), etc. Automation/
  e-mail messages should use **`zimmy.notify(text)`**: they are **queued, shown one at a
  time and stay visible ~5 s** so they don't overwrite each other (`say()` shows
  immediately and clears in 2.5 s, no queue).

Scripts that `extends RefCounted` are discarded after `run()`; those that `extends Node`
are added as children of Zimmy and **persist** (useful for continuous automations via
`_process`/timers). See `Automacoes/LEIAME.md` and
`Automacoes/exemplo_automacao.gd.example` (rename to `.gd` to enable) for the templates.

### Scheduler (frequency / recurrence)

An automation that declares `const SCHEDULE` runs **on its own** at the indicated
frequency, without needing to click. It appears in the **⏱️ Timers** submenu as a
**checkable** item (✓ = on) with a clock icon and the interval in the label — this is the
**visual scheduler**. Turning it on/off is **persistent**: whatever was on runs again when
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
| USD/EUR/GBP/JPY/CNY quote 💱 | `cotacao_*.gd` | one-off — currency quote in BRL ([AwesomeAPI](https://docs.awesomeapi.com.br/), free). The 5 most influential currencies (SDR basket) are grouped into the **💱 Currencies** submenu in the main menu (`MENU_GROUP := "moedas"`), each item with a small **flag icon on the left** (texture from `ICON_FLAG`) |
| Shut down PC 🔌 | `desligar_pc.gd` | `daily@23:00` — shuts down Windows with a 60s warning |
| Cancel shutdown ❌ | `cancelar_desligamento.gd` | one-off — aborts the shutdown (`shutdown /a`) |
| Alarm ⏰ | `alarme.gd` | `daily@08:00` — warns and gives a beep |
| Gmail 📧 | `email_gmail.gd` | every 5min — count unread e-mails via the **Atom feed** (`mail/feed/atom`, HTTP Basic + App Password); appears in the **📧 E-mails** submenu |
| WhatsApp 💬 | `whatsapp.gd` | every 1min — counts unread WhatsApp chats by **reading the WhatsApp Web window title** (`tasklist`), no API/login; appears in the **💬 WhatsApp** submenu |

> **Caution (shut down PC):** `desligar_pc.gd` runs a real `shutdown`. It comes **off**
> by default and gives a 60s warning; to abort, run "Cancel shutdown".

### E-mails (📧 E-mails submenu) — unread counter

Automations that declare `const MENU_GROUP := "email"` appear in a dedicated **📧
E-mails** submenu, with the **provider icon on the left** (color from `ICON_COLOR`) and
the **unread counter in the label**, refreshed every 5 min. **Gmail** (`email_gmail.gd`)
uses the lightweight **Atom feed** — a single authenticated GET to `mail/feed/atom`
(`zimmy.http_get_auth(...)`) returning `<fullcount>N</fullcount>`, no IMAP state machine,
authenticated with an **App Password** (HTTP Basic). At the top of the submenu, **🔔 Sound
alert** (default **on**, persisted) plays a soft mailbox-delivery chime whenever the unread
count **goes up** (a new e-mail arrived).

**Prerequisite — App Password** (the normal password **no longer works**):

- **Gmail**: enable 2-step verification and generate an *App Password* at
  [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords). The
  **Atom feed doesn't need IMAP enabled** — just the App Password. Google shows it in 4
  groups of 4 — you can paste it **with or without the spaces** (Zimmy strips them). Use
  the **App Password**, not your normal Google password.

**First-time step-by-step**: the very first time you turn on **Gmail** (while no credential
is saved yet), the login dialog shows a short **step-by-step on how to generate the App
Password**, plus a clickable **"↗ Open the App Password page"** link that opens Google's page
in your browser. Any automation can supply its own help via the optional `help_steps`/`help_url`
args of `zimmy.with_credentials(...)`.

**Credentials**: when you **turn on** a provider in the menu, Zimmy asks for *e-mail* +
*App Password*. They are saved **per automation** in `user://cred_<key>.json` (e.g.
`cred_email_gmail.json`) — **outside the repository** and covered by `.gitignore`
(`cred_*.json`). The file is **encrypted** (AES, via `FileAccess.open_encrypted_with_pass`)
with a key derived from an app salt + the machine ID (`OS.get_unique_id`), so it is not
plain text and does not work on another computer. They are only written/updated **after a
valid login**; if the password changes and the login fails, the file is discarded and Zimmy
asks again. Old plain-text credential files are migrated (re-encrypted) on read. Reuse this
flow in any automation with `zimmy.with_credentials(key, title, cb)` +
`zimmy.confirm_credentials(key, data)`.

### WhatsApp (💬 WhatsApp submenu) — unread chats

The `whatsapp.gd` automation (`MENU_GROUP := "whatsapp"`) shows the number of **unread
WhatsApp chats** as a badge, every minute. **Important — it does not connect to WhatsApp:**
there is no public API and a WhatsApp Web session is cryptographically bound to the browser
that scanned the QR, so it can't be reused from outside. Automating the WhatsApp client
(e.g. with unofficial libraries) would **violate WhatsApp's Terms and risk a ban**, so Zimmy
does **not** do that. Instead it does pure **passive observation**: it reads the **title of
the WhatsApp Web window** your own browser keeps open via `tasklist` — WhatsApp sets the
title to `(N) WhatsApp` when there are unread chats, and a small regex extracts `N`. No
servers are contacted, nothing is injected.

**Requirement:** keep **WhatsApp Web open and linked** to this device — ideally as its
**own window** (Chrome ▸ ⋮ ▸ *Cast, save, and share* ▸ *Create shortcut...* ▸ ✓ *Open as
window*) so the count stays in the title even when it isn't the active tab. If the window
isn't found, the badge shows `?` and Zimmy says it isn't open. At the top of the submenu,
**🔊 Sound alert** (default **on**, persisted) plays a soft phone-ringing sound whenever
the unread count **goes up** (a new chat arrived).

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
  - **Critter archetypes** — about **55%** of random pets come out as a recognizable
    **little animal**: `cat`, `dog`, `bunny`, `bear`, `frog`, `fox`, `mouse` or `pig`
    (`critter` key). The animal is set by **shape** (ears/mouth/whiskers/tail/proportions)
    — the **color stays random** (a purple cat is valid and cute). The other ~45% remain
    free-form abstract creatures.
  - **Geometry** — it draws the **body silhouette** (`body_shape`: `round`/`tall`/
    `wide`/`pear`/`chubby`/`slim`), the **ear shape** (round/pointy/floppy), the
    **mouth style** (`smile`/`cat`/`open`/`line`/`tongue`/`fang`), the **proportions**
    and the **presence of elements** (antennas, nose, eyelashes, cheeks).
  - **Extra "skeleton" categories** (each drawn **independently**): **tail**
    (`curl`/`puff`/`stub`), **horn** (`unicorn`/`devil`/`antlers`), **tuft**
    (`tuft`/`cowlick`/`mohawk`), **eye shape** (`oval`/`tall`/`sleepy`), **pupil**
    (`big`/`cat`/`sparkle`/`heart`), **eyebrow** (`flat`/`raised`/`serious`), **paws**,
    **little arms**, **belly mark** (`spot`/`heart`), **whiskers** (`short`/`long`),
    **wings**, **freckles**, **body pattern** (`spots`/`stripes`) and **muzzle**. Most
    have `none` with a higher weight, so the pets vary a lot without getting overloaded.
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
  - **Originals**: hat (`beanie`/`tophat`/`crown`/`cap`/`wizard`), glasses
    (`round`/`square`/`star`/`heart`/`sunglasses`), bow (head/neck) and scarf.
  - **Extra categories**: necklace (`pearls`/`pendant`), earrings (`studs`/`hoops`),
    collar (`plain`/`bell`), headphones, monocle, mustache (`curly`/`thin`), little
    flower, brooch (`star`/`heart`), tie (`necktie`/`bowtie`), diagonal sash, mask
    (`medical`/`ninja`), cheek sticker (`star`/`heart`), belt (`plain`/`buckle`) and
    backpack. Most have `none` with a higher weight, to vary without overdoing it.
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
blinking, eyes that follow the global mouse cursor and **varied reaction animations**:
each menu action triggers a **randomly chosen** move from a pool matched to that action's
energy — `hop`, `double_hop`, `triple_hop`, `spin`, `spin_jump`, `backflip`, `wiggle`,
`nod`, `squish`, `tilt`, `dance` (physics hops combined with rotation, squash-stretch and
sway about a pivot). The shadow stays grounded and the status bars are unaffected.

### Dynamic speech bubble

When Zimmy speaks, the **window grows and shrinks dynamically** to fit the phrase (and
emojis) — see `_relayout()` in `zimmy.gd`. The width measures the text with the real font
and grows only as needed; phrases wider than `MAX_W = 300 px` **wrap into multiple lines**
(by words). Zimmy stays **anchored by his bottom-center**, so he does not shift when the
bubble appears or disappears; the window position comes only from that anchor (no
screen-edge reclamp), so an oversized bubble may overflow toward the screen edge rather
than displacing the pet. That is why `stretch/mode` stays `disabled` (1 unit = 1 pixel),
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
