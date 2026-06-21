# Conta e-mails NÃO LIDOS no Outlook/Hotmail e mostra o número como badge no submenu
# 📧 E-mails.
#
# PRÉ-REQUISITO: a conta precisa ter IMAP habilitado e, com 2FA ativo, uma "Senha de
# aplicativo" (App Password) gerada em https://account.microsoft.com/security — use ESSA
# senha aqui. Observação: muitas contas corporativas (Microsoft 365) têm o IMAP/básico
# DESATIVADO pelo administrador; nesse caso este método não funciona.
#
# Credenciais em user://cred_email_outlook.json (fora do repositório, gitignored),
# salvas só após um login válido.
extends RefCounted

const AUTOMATION_NAME := "Outlook"
const MENU_GROUP := "email"
const SCHEDULE := "5m"
const CRED_KEY := "email_outlook"
const BADGE_KEY := "email_outlook"
const ICON_COLOR := "0078d4"     # azul Outlook
const IMAP_HOST := "outlook.office365.com"

func run(zimmy) -> void:
	zimmy.with_credentials(CRED_KEY, "Entrar no Outlook (use uma App Password)", func(creds):
		zimmy.imap_unread(IMAP_HOST, 993, creds["user"], creds["pass"], func(ok, count):
			if ok:
				zimmy.confirm_credentials(CRED_KEY, creds)
				zimmy.set_automation_badge(BADGE_KEY, str(count))
				zimmy.say("📧 Outlook: %d não lidos" % count)
			else:
				zimmy.forget_credentials(CRED_KEY)
				zimmy.set_automation_badge(BADGE_KEY, "!")
				zimmy.say("📧 Outlook: login falhou 🔒 (use uma App Password)")
		)
	)
