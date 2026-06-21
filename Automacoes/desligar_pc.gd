# Desliga o computador em um horário fixo (Windows).
# Por segurança: avisa antes e usa um atraso de 60s — dá tempo de salvar tudo.
# Para CANCELAR um desligamento agendado em curso, use a automação "Cancelar
# desligamento ❌" (roda `shutdown /a`).
#
# Ajuste o horário mudando SCHEDULE (ex.: "daily@23:30"). Fica DESLIGADA por padrão —
# ligue no menu ▸ ⚙️ Automações só quando quiser.
extends RefCounted

const AUTOMATION_NAME := "Desligar PC às 23:00 🔌"
const SCHEDULE := "daily@23:00"

func run(zimmy) -> void:
	zimmy.say("desligando em 60s! 🔌 salve seu trabalho")
	zimmy.hop()
	# /s = desligar, /t 60 = espera 60s, /c = mensagem mostrada pelo Windows.
	OS.execute("shutdown", ["/s", "/t", "60", "/c", "Zimmy: desligando em 60 segundos. Use 'shutdown /a' para cancelar."])
