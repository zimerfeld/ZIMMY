# Cotação do Iene Japonês (JPY) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação JPY 💴"

func run(zimmy) -> void:
	zimmy.say("buscando JPY... 🌐")
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/JPY-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("JPYBRL"):
			var d = data["JPYBRL"]
			zimmy.say("💴 JPY/BRL: R$ %.4f  (%+.2f%%)" % [float(d["bid"]), float(d["pctChange"])])
		else:
			zimmy.say("falha na cotação JPY 🌐")
	)
