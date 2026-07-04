---
tags: [sistema, email, gmail, whatsapp, automacoes, zimmy-pet]
atualizado: 2026-07-01
lang: en
---

# 📧 System - E-mails (Gmail)

An automation that checks the **unread e-mail count** on Gmail and shows the counter in the
menu, with a sound alert when new mail arrives. A specialized case of
[[Sistema - Automações e Agendador (EN)]] (`const MENU_GROUP := "email"`), with the sibling
submenu **💬 WhatsApp** (`MENU_GROUP := "whatsapp"`) following the same badge + sound
mechanics.

## 📧 E-mails submenu
`email_gmail.gd` declares `MENU_GROUP = "email"` and is routed to the **📧 E-mails** submenu
(`email_menu`, `MI_EMAIL`, zimmy.gd:854), with the **icon on the left** and the **unread
counter in the label**. At the **top of the submenu** there is a **🔊 Sound alert** item
(checkbox `SND_GMAIL`, state `gmail_sound_on`, zimmy.gd:1041) — when the e-mail badge
**grows**, Zimmy plays a soft mailbox-delivery sound. It is **disabled** if there is no
e-mail automation.

## Unread count — Atom feed + HTTP Basic
`email_gmail.gd` uses `zimmy.http_get_auth(url, user, pass, cb)` (zimmy.gd:1656), a GET
authenticated with **HTTP Basic**, over Gmail's **Atom feed** (`mail/feed/atom`), which
returns `<fullcount>N</fullcount>`. The `cb.call(status, body)` receives the HTTP code
(200 ok, 401 invalid credentials, 0 network failure). `N` is published with
`zimmy.set_automation_badge("email_gmail", N)` (zimmy.gd:1678), which updates the label and
triggers the sound when it grows.

> **App Password required:** the normal Gmail password no longer works — you must generate an
> *App Password* in the Google account.

## Credentials (`CRED_KEY`)
Credentials are requested when the automation is turned on and stored via
`with_credentials(key, title, cb)` (zimmy.gd:1869) → `confirm_credentials` saves only after
validation → `forget_credentials` clears them if login fails. They live in
`user://cred_<key>.json` (**gitignored**), never in the repository.

## 💬 WhatsApp (sibling)
`whatsapp.gd` uses `MENU_GROUP = "whatsapp"` → **💬 WhatsApp** submenu (`whatsapp_menu`,
zimmy.gd:207) with the same pattern: **🔔 Sound alert** at the top (`SND_WHATSAPP`,
`whatsapp_sound_on`, zimmy.gd:1038) and an unread counter via `BADGE_KEY`/badge.

Related: [[Sistema - Menu de Contexto (EN)]], [[Entrada - Itens do Menu (EN)]], [[Home (EN)]].
