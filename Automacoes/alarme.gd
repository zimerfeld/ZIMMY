# Alarme em um horário fixo: o Zimmy pula, avisa na tela e dá um bipe.
# Para vários alarmes, copie este arquivo com outro nome e outro horário
# (ex.: alarme_almoco.gd com SCHEDULE := "daily@12:00").
extends RefCounted

const AUTOMATION_NAME := "Alarme 08:00 ⏰"
const SCHEDULE := "daily@08:00"

func run(zimmy) -> void:
	zimmy.say("⏰ ALARME — 08:00! ⏰")
	zimmy.hop(480.0)
	# Bipe do sistema (não bloqueia a janela). Remova esta linha para alarme só visual.
	OS.create_process("powershell", ["-WindowStyle", "Hidden", "-c", "[console]::beep(880,400);[console]::beep(660,400);[console]::beep(988,500)"])
