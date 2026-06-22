# Cotação da Libra Esterlina (GBP) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação GBP 💷"
const AUTOMATION_NAME_EN := "GBP rate 💷"

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("buscando GBP... 🌐", "fetching GBP... 🌐"))
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/GBP-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("GBPBRL"):
			var d = data["GBPBRL"]
			var val = zimmy.fmt_money_brl(float(d["bid"]), 4)
			var pct = zimmy.fmt_pct(float(d["pctChange"]))
			var dt = zimmy.fmt_quote_date(str(d.get("create_date", "")))
			zimmy.notify("💷 GBP/BRL: %s (%s) — %s" % [val, pct, dt])
		else:
			zimmy.notify(zimmy.lang_text("falha na cotação GBP 🌐", "GBP quote failed 🌐"))
	)
