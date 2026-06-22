# Cotação do Dólar (USD) em Real, via AwesomeAPI (grátis, sem chave).
# Clique para ver na hora; ou agende adicionando, p.ex., const SCHEDULE := "daily@09:00".
extends RefCounted

const AUTOMATION_NAME := "Cotação USD 💵"
const AUTOMATION_NAME_EN := "USD rate 💵"

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("buscando USD... 🌐", "fetching USD... 🌐"))
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/USD-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("USDBRL"):
			var d = data["USDBRL"]
			var val = zimmy.fmt_money_brl(float(d["bid"]), 4)
			var pct = zimmy.fmt_pct(float(d["pctChange"]))
			var dt = zimmy.fmt_quote_date(str(d.get("create_date", "")))
			zimmy.notify("💵 USD/BRL: %s (%s) — %s" % [val, pct, dt])
		else:
			zimmy.notify(zimmy.lang_text("falha na cotação USD 🌐", "USD quote failed 🌐"))
	)
