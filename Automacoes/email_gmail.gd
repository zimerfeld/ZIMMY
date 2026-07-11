# Conta e-mails NÃO LIDOS no Gmail via FEED ATOM — mais simples que IMAP: um único GET
# autenticado em https://mail.google.com/mail/feed/atom, que devolve <fullcount>N</fullcount>
# (não lidos da Caixa de entrada). Sem máquina de estados IMAP/TLS — só HTTP Basic + XML.
#
# PRÉ-REQUISITO (Gmail bloqueia a senha normal): ative a verificação em 2 etapas e gere
# uma "Senha de app" (App Password) em https://myaccount.google.com/apppasswords — use
# ESSA senha aqui, não a sua senha normal. O feed Atom autentica via HTTP Basic com a App
# Password. (O Google pode restringir esse feed no futuro; se parar de responder 200,
# volte para a versão IMAP no histórico do git.)
#
# Ao LIGAR esta automação (menu ▸ 📧 E-mails), o Zimmy pede e-mail + App Password. As
# credenciais ficam em user://cred_email_gmail.json (fora do repositório, gitignored) e
# só são salvas/atualizadas após uma resposta 200 (login válido).
extends RefCounted

const AUTOMATION_NAME := "Gmail"
const MENU_GROUP := "email"      # vai para o submenu dedicado 📧 E-mails
const SCHEDULE := "5m"           # checa a cada 5 minutos
const CRED_KEY := "email_gmail"  # arquivo de credencial: user://cred_email_gmail.json
const BADGE_KEY := "email_gmail" # chave do contador (badge) no menu
const ICON_COLOR := "ea4335"     # vermelho Gmail (ícone à esquerda do item)
const FEED_URL := "https://mail.google.com/mail/feed/atom"

const APPPW_URL := "https://myaccount.google.com/apppasswords"

func run(zimmy) -> void:
	var title = zimmy.lang_text("Entrar no Gmail (use uma App Password)",
		"Sign in to Gmail (use an App Password)",
		"Entrar en Gmail (usa una Contraseña de aplicación)")
	# Passo-a-passo mostrado na 1ª vez (enquanto não há credencial salva).
	var help = zimmy.lang_text(
		"Como obter a Senha de app do Gmail (NÃO é a sua senha normal!):\n1. Ative a verificação em 2 etapas na sua Conta Google.\n2. Abra a página abaixo e crie uma senha (dê o nome \"Zimmy\").\n3. Copie as 16 letras e cole no campo abaixo, junto com o seu e-mail.",
		"How to get your Gmail App Password (it is NOT your normal password!):\n1. Turn on 2-Step Verification in your Google Account.\n2. Open the page below and create one (name it \"Zimmy\").\n3. Copy the 16 letters and paste them below, with your e-mail.",
		"Cómo obtener la Contraseña de aplicación de Gmail (¡NO es tu contraseña normal!):\n1. Activa la verificación en 2 pasos en tu Cuenta de Google.\n2. Abre la página de abajo y crea una (ponle el nombre \"Zimmy\").\n3. Copia las 16 letras y pégalas abajo, junto con tu correo.")
	var on_creds := func(creds):
		zimmy.http_get_auth(FEED_URL, creds["user"], creds["pass"], func(status, body):
			if status == 200:
				var n := _fullcount(body)
				if n >= 0:
					zimmy.confirm_credentials(CRED_KEY, creds)   # salva se novo/alterado
					zimmy.set_automation_badge(BADGE_KEY, str(n))
					zimmy.notify(zimmy.lang_text("📧 Gmail: %d não lidos", "📧 Gmail: %d unread", "📧 Gmail: %d sin leer") % n)
				else:
					zimmy.set_automation_badge(BADGE_KEY, "!")
					zimmy.notify(zimmy.lang_text("📧 Gmail: resposta inesperada 🤔",
						"📧 Gmail: unexpected response 🤔",
						"📧 Gmail: respuesta inesperada 🤔"))
			elif status == 401:
				zimmy.forget_credentials(CRED_KEY)           # inválida → re-pergunta na próxima
				zimmy.set_automation_badge(BADGE_KEY, "!")
				zimmy.notify(zimmy.lang_text("📧 Gmail: login falhou 🔒 (use uma App Password)",
					"📧 Gmail: login failed 🔒 (use an App Password)",
					"📧 Gmail: fallo al iniciar sesión 🔒 (usa una Contraseña de aplicación)"))
			else:
				zimmy.set_automation_badge(BADGE_KEY, "?")   # falha de rede: mantém a credencial
				zimmy.notify(zimmy.lang_text("📧 Gmail: falha de conexão 🌐",
					"📧 Gmail: connection failed 🌐",
					"📧 Gmail: fallo de conexión 🌐"))
		)
	zimmy.with_credentials(CRED_KEY, title, on_creds, help, APPPW_URL)

## Extrai N de <fullcount>N</fullcount> do feed Atom (ou -1 se não encontrar — provável
## erro de autenticação devolvendo HTML em vez do feed).
func _fullcount(xml: String) -> int:
	var re := RegEx.new()
	re.compile("<fullcount>(\\d+)</fullcount>")
	var m := re.search(xml)
	return (int(m.get_string(1)) if m != null else -1)
