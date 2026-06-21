# Auto-alimentar — verifica a fome do Zimmy de tempos em tempos e o alimenta quando
# necessário, para ele não passar fome enquanto você trabalha.
#
# AGENDAMENTO: a constante SCHEDULE faz o Zimmy rodar isto sozinho na frequência dada
# (aqui, a cada 20s). Ligue/desligue pelo menu ▸ ⚙️ Automações (fica marcado com ✓).
#
# Dica: como o agendador cuida da recorrência, basta um `run(zimmy)` que faz a ação UMA
# vez. `extends RefCounted` é o ideal para automações agendadas (são descartadas após o run).

extends RefCounted

const AUTOMATION_NAME := "Auto-alimentar 🦴"
const SCHEDULE := "20s"          # com que frequência checar a fome

func run(zimmy) -> void:
	# Só alimenta se estiver com fome, para não desperdiçar (e não enjoar o pet).
	if zimmy.hunger > 55.0:
		zimmy.hunger = max(zimmy.hunger - 25.0, 0.0)
		zimmy.happy = min(zimmy.happy + 6.0, 100.0)
		zimmy.say("auto-refeição 🦴😋")
		zimmy.hop()
