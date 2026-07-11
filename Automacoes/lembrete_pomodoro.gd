# Lembrete Pomodoro — a cada 25 minutos o Zimmy te lembra de fazer uma pausa
# (técnica Pomodoro: blocos de foco intercalados com descansos curtos).
#
# Troque a frequência mudando SCHEDULE: "25m", "50m", "1h"... Ligue/desligue pelo
# menu ▸ ⚙️ Automações.

extends RefCounted

const AUTOMATION_NAME := "Lembrete Pomodoro ☕"
const AUTOMATION_NAME_EN := "Pomodoro reminder ☕"
const AUTOMATION_NAME_ES := "Recordatorio Pomodoro ☕"
const SCHEDULE := "25m"

func run(zimmy) -> void:
	var pt := ["hora da pausa! ☕", "respira e alonga 🧘", "levanta um pouco! 🚶"]
	var en := ["break time! ☕", "breathe and stretch 🧘", "stand up a bit! 🚶"]
	var es := ["¡hora de la pausa! ☕", "respira y estírate 🧘", "¡levántate un poco! 🚶"]
	var opts := en if zimmy.lang == "en" else (es if zimmy.lang == "es" else pt)
	zimmy.notify(opts.pick_random())
	zimmy.hop(360.0)
