# Conta e-mails NÃO LIDOS no Gmail e mostra o número como badge no submenu 📧 E-mails.
#
# PRÉ-REQUISITO (Gmail bloqueia a senha normal): ative a verificação em 2 etapas e gere
# uma "Senha de app" (App Password) em https://myaccount.google.com/apppasswords — use
# ESSA senha aqui, não a sua senha normal. Confira também se o IMAP está ativado em
# Gmail ▸ Configurações ▸ Encaminhamento e POP/IMAP.
#
# Ao LIGAR esta automação (menu ▸ 📧 E-mails), o Zimmy pede e-mail + App Password. As
# credenciais ficam em user://cred_email_gmail.json (fora do repositório, gitignored) e
# só são salvas/atualizadas após um login válido.
extends RefCounted

const AUTOMATION_NAME := "Gmail"
const MENU_GROUP := "email"      # vai para o submenu dedicado 📧 E-mails
const SCHEDULE := "5m"            # checa a cada 5 minutos
const CRED_KEY := "email_gmail"  # arquivo de credencial: user://cred_email_gmail.json
const BADGE_KEY := "email_gmail" # chave do contador (badge) no menu
const ICON_COLOR := "ea4335"     # vermelho Gmail (ícone à esquerda do item)
const IMAP_HOST := "imap.gmail.com"

func run(zimmy) -> void:
	var title = zimmy.lang_text("Entrar no Gmail (use uma App Password)",
		"Sign in to Gmail (use an App Password)")
	zimmy.with_credentials(CRED_KEY, title, func(creds):
		zimmy.imap_unread(IMAP_HOST, 993, creds["user"], creds["pass"], func(ok, count):
			if ok:
				zimmy.confirm_credentials(CRED_KEY, creds)   # salva se novo/alterado
				zimmy.set_automation_badge(BADGE_KEY, str(count))
				zimmy.notify(zimmy.lang_text("📧 Gmail: %d não lidos", "📧 Gmail: %d unread") % count)
			else:
				zimmy.forget_credentials(CRED_KEY)           # inválida → re-pergunta na próxima
				zimmy.set_automation_badge(BADGE_KEY, "!")
				zimmy.notify(zimmy.lang_text("📧 Gmail: login falhou 🔒 (use uma App Password)",
					"📧 Gmail: login failed 🔒 (use an App Password)"))
		)
	)
