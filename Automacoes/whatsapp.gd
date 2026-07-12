# Conta CONVERSAS NÃO LIDAS no WhatsApp Web e mostra o número como badge no
# submenu 💬 WhatsApp.
#
# COMO FUNCIONA (e o que NÃO faz): o Zimmy NÃO entra no WhatsApp nem acessa os
# servidores do WhatsApp — não há API pública e a sessão fica presa ao navegador que
# você vinculou via QR. Em vez disso, esta automação apenas LÊ o título da janela do
# WhatsApp Web que o seu próprio navegador mantém aberto: quando há não lidas, o título
# vira "(N) WhatsApp". É observação passiva (via `tasklist`), então não viola os termos
# do WhatsApp nem arrisca o número.
#
# PRÉ-REQUISITO: mantenha o WhatsApp Web ABERTO e vinculado a este aparelho. Para
# funcionar mesmo quando você troca de aba, abra-o como JANELA PRÓPRIA:
#   Chrome ▸ ⋮ ▸ Transmitir, salvar e compartilhar ▸ Criar atalho... ▸ ✓ Abrir como janela.
# Sem o WhatsApp Web aberto (ou se ele não for a aba ativa), a contagem fica indisponível.
#
# Ligue no menu ▸ 💬 WhatsApp; checa a cada 1 minuto (mude em SCHEDULE).
extends RefCounted

const AUTOMATION_NAME := "WhatsApp"
const AUTOMATION_NAME_EN := "WhatsApp"
const MENU_GROUP := "whatsapp"   # vai para o submenu dedicado 💬 WhatsApp
const SCHEDULE := "1m"           # relê a cada 1 minuto
const BADGE_KEY := "whatsapp"    # chave do contador (badge) no menu
const ICON_COLOR := "25d366"     # verde WhatsApp (ícone à esquerda do item)

func run(zimmy) -> void:
	# tasklist /v traz a coluna "Título da janela" de cada processo; procuramos a janela
	# do WhatsApp Web e extraímos o "(N)" do título. Roda escondido e sem bloquear nada
	# além do próprio comando (rápido).
	var out: Array = []
	OS.execute("tasklist", ["/v", "/fo", "csv", "/nh"], out, false, false)
	var blob := ""
	for chunk in out:
		blob += str(chunk)
	# Casa qualquer caixa: "WhatsApp - Google Chrome", "web.whatsapp.com" (carregando),
	# a janela do app PWA, etc. — daí a comparação em minúsculas / regex (?i).
	if not blob.to_lower().contains("whatsapp"):
		zimmy.set_automation_badge(BADGE_KEY, "?")
		zimmy.notify(zimmy.lang_text(
			"💬 WhatsApp Web não está aberto 🔗 (abra e deixe como janela/aba ativa)",
			"💬 WhatsApp Web isn't open 🔗 (open it and keep it as the active window/tab)",
			"💬 WhatsApp Web no está abierto 🔗 (ábrelo y déjalo como ventana/pestaña activa)"))
		return
	# "(3) WhatsApp - Google Chrome" → 3 ; "WhatsApp - ..." sem parênteses → 0 (tudo lido)
	var re := RegEx.new()
	re.compile("(?i)\\((\\d+)\\)\\s*whatsapp")
	var m := re.search(blob)
	var n := (int(m.get_string(1)) if m != null else 0)
	zimmy.set_automation_badge(BADGE_KEY, str(n))
	if n > 0:
		zimmy.notify(zimmy.lang_text("💬 WhatsApp: %d conversa(s) não lida(s)",
			"💬 WhatsApp: %d unread chat(s)",
			"💬 WhatsApp: %d chat(s) sin leer") % n)
	else:
		zimmy.notify(zimmy.lang_text("💬 WhatsApp: tudo lido ✅", "💬 WhatsApp: all read ✅", "💬 WhatsApp: todo leído ✅"))
