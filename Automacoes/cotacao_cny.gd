# Cotação do Yuan Chinês (CNY) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação CNY 🇨🇳"

func run(zimmy) -> void:
	zimmy.say("buscando CNY... 🌐")
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/CNY-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("CNYBRL"):
			var d = data["CNYBRL"]
			zimmy.say("🇨🇳 CNY/BRL: R$ %.4f  (%+.2f%%)" % [float(d["bid"]), float(d["pctChange"])])
		else:
			zimmy.say("falha na cotação CNY 🌐")
	)
