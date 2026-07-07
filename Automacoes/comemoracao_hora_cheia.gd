# Comemoração de hora cheia — quando o relógio bate XX:00, o Zimmy comemora a hora
# nova com FOGOS DE ARTIFÍCIO, uma dancinha e uma fala. Útil como "marcador" de
# passagem do tempo.
#
# SCHEDULE := "hourly" dispara alinhado ao relógio (no minuto 0 de cada hora), não a
# cada 60 min a partir de quando você ligou. Ligue/desligue pelo menu ▸ ⚙️ Automações.

extends RefCounted

const AUTOMATION_NAME := "Comemorar hora cheia 🎆"
const AUTOMATION_NAME_EN := "Celebrate the hour 🎆"
const SCHEDULE := "hourly"

func run(zimmy) -> void:
	var h: int = Time.get_time_dict_from_system().hour
	zimmy.notify(zimmy.lang_text("%dh em ponto! 🎆🎉", "%d o'clock sharp! 🎆🎉") % h)
	zimmy.celebrate()   # fogos de artifício + pulo + dancinha
