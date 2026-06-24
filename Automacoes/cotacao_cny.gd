# Cotação do Yuan Chinês (CNY) em Real, via AwesomeAPI (grátis, sem chave).
extends RefCounted

const AUTOMATION_NAME := "Cotação CNY"
const AUTOMATION_NAME_EN := "CNY rate"
const MENU_GROUP := "moedas"      # vai para o submenu 💱 Moedas (dentro de Automações)
const ICON_FLAG := "cn"           # bandeira (textura) à esquerda do item — ver _flag_icon()

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("buscando CNY... 🌐", "fetching CNY... 🌐"))
	zimmy.http_get_json("https://economia.awesomeapi.com.br/last/CNY-BRL", func(ok, data):
		if ok and data is Dictionary and data.has("CNYBRL"):
			var d = data["CNYBRL"]
			var val = zimmy.fmt_money_brl(float(d["bid"]), 4)
			var pct = zimmy.fmt_pct(float(d["pctChange"]))
			var dt = zimmy.fmt_quote_date(str(d.get("create_date", "")))
			zimmy.notify("🇨🇳 CNY/BRL: %s (%s) — %s" % [val, pct, dt])
		else:
			zimmy.notify(zimmy.lang_text("falha na cotação CNY 🌐", "CNY quote failed 🌐"))
	)
