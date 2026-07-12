---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, email, gmail, whatsapp, automacoes, zimmy-pet]
---

# 📧 Sistema - E-mails (Gmail)

> 🇪🇸 Lee esta página en español → [[📧 Sistema - E-mails (ES)]]

Automação que consulta o **número de e-mails não lidos** do Gmail e mostra o contador no
menu, com alerta sonoro quando chega correio novo. É um caso especializado de
[[⚙️ Sistema - Automações e Agendador]] (`const MENU_GROUP := "email"`), com o submenu irmão
**💬 WhatsApp** (`MENU_GROUP := "whatsapp"`) seguindo a mesma mecânica de badge + som.

## 📧 Submenu 📧 E-mails
`email_gmail.gd` declara `MENU_GROUP = "email"` e é roteado para o submenu **📧 E-mails**
(`email_menu`, `MI_EMAIL`, zimmy.gd:854), com o **ícone à esquerda** e o **contador de não
lidos no rótulo**. No **topo do submenu** há um item **🔊 Alerta de som** (checkbox
`SND_GMAIL`, estado `gmail_sound_on`, zimmy.gd:1041) — quando o badge do e-mail **aumenta**,
o Zimmy toca um som baixo de entrega de correio. Fica **desabilitado** se não houver
automação de e-mail.

## 🔢 Contador não lido — feed Atom + HTTP Basic
O `email_gmail.gd` usa `zimmy.http_get_auth(url, user, pass, cb)` (zimmy.gd:1656), um GET
autenticado por **HTTP Basic**, sobre o **feed Atom** do Gmail (`mail/feed/atom`), que
devolve `<fullcount>N</fullcount>`. O `cb.call(status, body)` recebe o código HTTP
(200 ok, 401 credencial inválida, 0 falha de rede). O valor de `N` é publicado com
`zimmy.set_automation_badge("email_gmail", N)` (zimmy.gd:1678), o que atualiza o rótulo e
dispara o som quando cresce.

> **App Password obrigatória:** a senha normal do Gmail não funciona mais — é preciso gerar
> uma *App Password* na conta Google.

## 🔑 Credenciais (`CRED_KEY`)
As credenciais são pedidas ao ligar a automação e guardadas via `with_credentials(key,
título, cb)` (zimmy.gd:1869) → `confirm_credentials` grava só após validar →
`forget_credentials` apaga se o login falhar. Ficam em `user://cred_<key>.json`
(**gitignored**), nunca no repositório.

## 💬 WhatsApp (irmão)
`whatsapp.gd` usa `MENU_GROUP = "whatsapp"` → submenu **💬 WhatsApp** (`whatsapp_menu`,
zimmy.gd:207) com o mesmo padrão: **🔔 Alerta de som** no topo (`SND_WHATSAPP`,
`whatsapp_sound_on`, zimmy.gd:1038) e contador de não lidas via `BADGE_KEY`/badge.

Relacionado: [[🧭 Sistema - Menu de Contexto]], [[🚪 Entrada - Itens do Menu]], [[🏠 Home]].
