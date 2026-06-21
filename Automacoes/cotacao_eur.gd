# Cotação do Euro (EUR) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação EUR 💶"

func run(zimmy) -> void:
	zimmy.say("buscando EUR... 🌐")
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/EUR-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("EURBRL"):
			var d = data["EURBRL"]
			zimmy.say("💶 EUR/BRL: R$ %.4f  (%+.2f%%)" % [float(d["bid"]), float(d["pctChange"])])
		else:
			zimmy.say("falha na cotação EUR 🌐")
	)
