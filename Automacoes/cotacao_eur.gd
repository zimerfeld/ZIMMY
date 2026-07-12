# Cotação do Euro (EUR) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação EUR"
const AUTOMATION_NAME_EN := "EUR rate"
const AUTOMATION_NAME_ES := "Cotización EUR"
const MENU_GROUP := "moedas"      # vai para o submenu 💱 Moedas (dentro de Automações)
const ICON_FLAG := "eu"           # bandeira (textura) à esquerda do item — ver _flag_icon()

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("buscando EUR... 🌐", "fetching EUR... 🌐", "buscando EUR... 🌐"))
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/EUR-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("EURBRL"):
			var d = data["EURBRL"]
			var val = zimmy.fmt_money_brl(float(d["bid"]), 4)
			var pct = zimmy.fmt_pct(float(d["pctChange"]))
			var dt = zimmy.fmt_quote_date(str(d.get("create_date", "")))
			zimmy.notify("💶 EUR/BRL: %s (%s) — %s" % [val, pct, dt])
		else:
			zimmy.notify(zimmy.lang_text("falha na cotação EUR 🌐", "EUR quote failed 🌐", "fallo en la cotización EUR 🌐"))
	)
