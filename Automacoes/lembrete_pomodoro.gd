# Lembrete Pomodoro — a cada 25 minutos o Zimmy te lembra de fazer uma pausa
# (técnica Pomodoro: blocos de foco intercalados com descansos curtos).
#
# Troque a frequência mudando SCHEDULE: "25m", "50m", "1h"... Ligue/desligue pelo
# menu ▸ ⚙️ Automações.

extends RefCounted

const AUTOMATION_NAME := "Lembrete Pomodoro ☕"
const AUTOMATION_NAME_EN := "Pomodoro reminder ☕"
const SCHEDULE := "25m"

func run(zimmy) -> void:
	var pt := ["hora da pausa! ☕", "respira e alonga 🧘", "levanta um pouco! 🚶"]
	var en := ["break time! ☕", "breathe and stretch 🧘", "stand up a bit! 🚶"]
	zimmy.notify((en if zimmy.lang == "en" else pt).pick_random())
	zimmy.hop(360.0)
