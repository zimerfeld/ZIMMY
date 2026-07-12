---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, email, gmail, whatsapp, automacoes, zimmy-pet]
---

# 📧 Sistema - Correos (Gmail)

> 🇧🇷 Lee esta página en portugués → [[📧 Sistema - E-mails]]
> 🇺🇸 Read this page in English → [[📧 Sistema - E-mails (EN)]]

Automatización que consulta el **número de correos no leídos** de Gmail y muestra el contador en
el menú, con alerta sonora cuando llega correo nuevo. Es un caso especializado de
[[⚙️ Sistema - Automações e Agendador (ES)]] (`const MENU_GROUP := "email"`), con el submenú hermano
**💬 WhatsApp** (`MENU_GROUP := "whatsapp"`) siguiendo la misma mecánica de badge + sonido.

## 📧 Submenú 📧 Correos
`email_gmail.gd` declara `MENU_GROUP = "email"` y se enruta al submenú **📧 Correos**
(`email_menu`, `MI_EMAIL`, zimmy.gd:854), con el **icono a la izquierda** y el **contador de no
leídos en la etiqueta**. En la **parte superior del submenú** hay un ítem **🔊 Alerta de sonido** (checkbox
`SND_GMAIL`, estado `gmail_sound_on`, zimmy.gd:1041) — cuando el badge del correo **aumenta**,
Zimmy reproduce un sonido bajo de entrega de correo. Queda **deshabilitado** si no hay
automatización de correo.

## 🔢 Contador de no leídos — feed Atom + HTTP Basic
El `email_gmail.gd` usa `zimmy.http_get_auth(url, user, pass, cb)` (zimmy.gd:1656), un GET
autenticado por **HTTP Basic**, sobre el **feed Atom** de Gmail (`mail/feed/atom`), que
devuelve `<fullcount>N</fullcount>`. El `cb.call(status, body)` recibe el código HTTP
(200 ok, 401 credencial inválida, 0 fallo de red). El valor de `N` se publica con
`zimmy.set_automation_badge("email_gmail", N)` (zimmy.gd:1678), lo que actualiza la etiqueta y
dispara el sonido cuando crece.

> **App Password obligatoria:** la contraseña normal de Gmail ya no funciona — hay que generar
> una *App Password* en la cuenta de Google.

## 🔑 Credenciales (`CRED_KEY`)
Las credenciales se piden al activar la automatización y se guardan vía `with_credentials(key,
título, cb)` (zimmy.gd:1869) → `confirm_credentials` graba solo tras validar →
`forget_credentials` borra si el login falla. Quedan en `user://cred_<key>.json`
(**gitignored**), nunca en el repositorio.

## 💬 WhatsApp (hermano)
`whatsapp.gd` usa `MENU_GROUP = "whatsapp"` → submenú **💬 WhatsApp** (`whatsapp_menu`,
zimmy.gd:207) con el mismo patrón: **🔔 Alerta de sonido** en la parte superior (`SND_WHATSAPP`,
`whatsapp_sound_on`, zimmy.gd:1038) y contador de no leídas vía `BADGE_KEY`/badge.

Relacionado: [[🧭 Sistema - Menu de Contexto (ES)]], [[🚪 Entrada - Itens do Menu (ES)]], [[🏠 Home (ES)]].
