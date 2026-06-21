# Cotação da Libra Esterlina (GBP) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação GBP 💷"

func run(zimmy) -> void:
	zimmy.say("buscando GBP... 🌐")
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/GBP-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("GBPBRL"):
			var d = data["GBPBRL"]
			zimmy.say("💷 GBP/BRL: R$ %.4f  (%+.2f%%)" % [float(d["bid"]), float(d["pctChange"])])
		else:
			zimmy.say("falha na cotação GBP 🌐")
	)
