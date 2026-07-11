# Cotação do Iene Japonês (JPY) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação JPY"
const AUTOMATION_NAME_EN := "JPY rate"
const AUTOMATION_NAME_ES := "Cotización JPY"
const MENU_GROUP := "moedas"      # vai para o submenu 💱 Moedas (dentro de Automações)
const ICON_FLAG := "jp"           # bandeira (textura) à esquerda do item — ver _flag_icon()

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("buscando JPY... 🌐", "fetching JPY... 🌐", "buscando JPY... 🌐"))
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/JPY-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("JPYBRL"):
			var d = data["JPYBRL"]
			var val = zimmy.fmt_money_brl(float(d["bid"]), 4)
			var pct = zimmy.fmt_pct(float(d["pctChange"]))
			var dt = zimmy.fmt_quote_date(str(d.get("create_date", "")))
			zimmy.notify("💴 JPY/BRL: %s (%s) — %s" % [val, pct, dt])
		else:
			zimmy.notify(zimmy.lang_text("falha na cotação JPY 🌐", "JPY quote failed 🌐", "fallo en la cotización JPY 🌐"))
	)
