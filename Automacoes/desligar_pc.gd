# Desliga o computador em um horário fixo (Windows).
# Por segurança: avisa antes e usa um atraso de 60s — dá tempo de salvar tudo.
# Para CANCELAR um desligamento agendado em curso, use a automação "Cancelar
# desligamento ❌" (roda `shutdown /a`).
#
# Ajuste o horário mudando SCHEDULE (ex.: "daily@23:30"). Fica DESLIGADA por padrão —
# ligue no menu ▸ ⚙️ Automações só quando quiser.
extends RefCounted

const AUTOMATION_NAME := "Desligar PC às 23:00 🔌"
const AUTOMATION_NAME_EN := "Shut down PC at 23:00 🔌"
const AUTOMATION_NAME_ES := "Apagar el PC a las 23:00 🔌"
const SCHEDULE := "daily@23:00"

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("desligando em 60s! 🔌 salve seu trabalho",
		"shutting down in 60s! 🔌 save your work",
		"¡apagando en 60s! 🔌 guarda tu trabajo"))
	zimmy.hop()
	# /s = desligar, /t 60 = espera 60s, /c = mensagem mostrada pelo Windows.
	var msg = zimmy.lang_text(
		"Zimmy: desligando em 60 segundos. Use 'shutdown /a' para cancelar.",
		"Zimmy: shutting down in 60 seconds. Use 'shutdown /a' to cancel.",
		"Zimmy: apagando en 60 segundos. Usa 'shutdown /a' para cancelar.")
	OS.execute("shutdown", ["/s", "/t", "60", "/c", msg])
