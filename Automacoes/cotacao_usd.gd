# Cotação do Dólar (USD) em Real, via AwesomeAPI (grátis, sem chave).
# Clique para ver na hora; ou agende adicionando, p.ex., const SCHEDULE := "daily@09:00".
extends RefCounted

const AUTOMATION_NAME := "Cotação USD 💵"

func run(zimmy) -> void:
	zimmy.say("buscando USD... 🌐")
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/USD-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("USDBRL"):
			var d = data["USDBRL"]
			zimmy.say("💵 USD/BRL: R$ %.4f  (%+.2f%%)" % [float(d["bid"]), float(d["pctChange"])])
		else:
			zimmy.say("falha na cotação USD 🌐")
	)
