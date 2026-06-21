# Comemoração de hora cheia — quando o relógio bate XX:00, o Zimmy comemora a hora
# nova com um pulinho e uma fala. Útil como "marcador" de passagem do tempo.
#
# SCHEDULE := "hourly" dispara alinhado ao relógio (no minuto 0 de cada hora), não a
# cada 60 min a partir de quando você ligou. Ligue/desligue pelo menu ▸ ⚙️ Automações.

extends RefCounted

const AUTOMATION_NAME := "Comemorar hora cheia 🎉"
const SCHEDULE := "hourly"

func run(zimmy) -> void:
	var h: int = Time.get_time_dict_from_system().hour
	zimmy.say("%dh em ponto! 🎉" % h)
	zimmy.hop(440.0)
