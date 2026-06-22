# Cancela um desligamento do Windows que esteja agendado/em contagem (shutdown /a).
# Automação avulsa: clique no menu ▸ ⚙️ Automações para abortar na hora.
extends RefCounted

const AUTOMATION_NAME := "Cancelar desligamento ❌"
const AUTOMATION_NAME_EN := "Cancel shutdown ❌"

func run(zimmy) -> void:
	OS.execute("shutdown", ["/a"])
	zimmy.notify(zimmy.lang_text("desligamento cancelado ✋", "shutdown canceled ✋"))
