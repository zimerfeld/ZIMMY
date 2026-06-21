# Lembrete Pomodoro — a cada 25 minutos o Zimmy te lembra de fazer uma pausa
# (técnica Pomodoro: blocos de foco intercalados com descansos curtos).
#
# Troque a frequência mudando SCHEDULE: "25m", "50m", "1h"... Ligue/desligue pelo
# menu ▸ ⚙️ Automações.

extends RefCounted

const AUTOMATION_NAME := "Lembrete Pomodoro ☕"
const SCHEDULE := "25m"

func run(zimmy) -> void:
	zimmy.say(["hora da pausa! ☕", "respira e alonga 🧘", "levanta um pouco! 🚶"].pick_random())
	zimmy.hop(360.0)
