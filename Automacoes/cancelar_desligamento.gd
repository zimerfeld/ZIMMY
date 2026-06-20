# Cancela um desligamento do Windows que esteja agendado/em contagem (shutdown /a).
# Automação avulsa: clique no menu ▸ ⚙️ Automações para abortar na hora.
extends RefCounted

const AUTOMATION_NAME := "Cancelar desligamento ❌"

func run(zimmy) -> void:
	OS.execute("shutdown", ["/a"])
	zimmy.say("desligamento cancelado ✋")
