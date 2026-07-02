# Clima / tempo atual, via Open-Meteo (grátis, sem chave) + ipapi.co (geolocalização por IP).
# Clique para ver na hora; ou agende adicionando, p.ex., const SCHEDULE := "daily@07:00".
# Para fixar sua cidade (sem depender do IP), preencha LAT/LON abaixo (e CITY, opcional).
extends RefCounted

const AUTOMATION_NAME := "Clima 🌤️"
const AUTOMATION_NAME_EN := "Weather 🌤️"

# Deixe vazio para autodetectar pela sua conexão (IP). Ex. fixo: LAT := "-23.55", LON := "-46.63".
const LAT := ""
const LON := ""
const CITY := ""   # rótulo opcional quando LAT/LON são fixos

# Códigos WMO do Open-Meteo -> [emoji, texto pt, texto en]. Ver open-meteo.com/en/docs
const WMO := {
	0:  ["☀️", "céu limpo", "clear sky"],
	1:  ["🌤️", "predomínio de sol", "mainly clear"],
	2:  ["⛅", "parcialmente nublado", "partly cloudy"],
	3:  ["☁️", "nublado", "overcast"],
	45: ["🌫️", "névoa", "fog"],
	48: ["🌫️", "névoa gelada", "freezing fog"],
	51: ["🌦️", "garoa fraca", "light drizzle"],
	53: ["🌦️", "garoa", "drizzle"],
	55: ["🌦️", "garoa forte", "dense drizzle"],
	56: ["🌧️", "garoa gelada", "freezing drizzle"],
	57: ["🌧️", "garoa gelada forte", "dense freezing drizzle"],
	61: ["🌧️", "chuva fraca", "light rain"],
	63: ["🌧️", "chuva", "rain"],
	65: ["🌧️", "chuva forte", "heavy rain"],
	66: ["🌧️", "chuva gelada", "freezing rain"],
	67: ["🌧️", "chuva gelada forte", "heavy freezing rain"],
	71: ["❄️", "neve fraca", "light snow"],
	73: ["❄️", "neve", "snow"],
	75: ["❄️", "neve forte", "heavy snow"],
	77: ["❄️", "grãos de neve", "snow grains"],
	80: ["🌦️", "pancadas fracas", "light showers"],
	81: ["🌦️", "pancadas de chuva", "rain showers"],
	82: ["⛈️", "pancadas fortes", "violent showers"],
	85: ["🌨️", "pancadas de neve", "snow showers"],
	86: ["🌨️", "pancadas de neve fortes", "heavy snow showers"],
	95: ["⛈️", "trovoada", "thunderstorm"],
	96: ["⛈️", "trovoada com granizo", "thunderstorm w/ hail"],
	99: ["⛈️", "trovoada com granizo forte", "thunderstorm w/ heavy hail"],
}

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("vendo o tempo... 🌡️", "checking weather... 🌡️"))
	# Lambda local (não referencia self) para funcionar no clique e no disparo agendado.
	var show_weather := func(lat: String, lon: String, city: String):
		var url := "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,weather_code&timezone=auto" % [lat, lon]
		zimmy.http_get_json(url, func(ok, data):
			if not (ok and data is Dictionary and data.has("current")):
				zimmy.notify(zimmy.lang_text("falha ao buscar o clima 🌐", "weather fetch failed 🌐"))
				return
			var cur = data["current"]
			var code := int(cur.get("weather_code", -1))
			var info = WMO.get(code, ["🌡️", "tempo instável", "unsettled"])
			var desc = zimmy.lang_text(info[1], info[2])
			var temp = zimmy.fmt_num(float(cur.get("temperature_2m", 0.0)), 1)
			var unit := str(data.get("current_units", {}).get("temperature_2m", "°C"))
			var where := ""
			if city != "":
				where = zimmy.lang_text(" em %s" % city, " in %s" % city)
			zimmy.notify("%s %s — %s%s%s" % [info[0], desc, temp, unit, where])
		)
	if LAT != "" and LON != "":
		show_weather.call(LAT, LON, CITY)
		return
	# Sem coordenadas fixas: descobre lat/lon pela conexão (grátis, sem chave).
	# Provedor 1: ipapi.co (HTTPS, campos latitude/longitude). Se falhar, cai no provedor 2.
	zimmy.http_get_json("https://ipapi.co/json/", func(ok, geo):
		if ok and geo is Dictionary and geo.has("latitude") and geo.has("longitude"):
			show_weather.call(str(geo["latitude"]), str(geo["longitude"]), str(geo.get("city", "")))
			return
		# Provedor 2 (fallback): ip-api.com (campos lat/lon).
		zimmy.http_get_json("http://ip-api.com/json/", func(ok2, g2):
			if ok2 and g2 is Dictionary and g2.has("lat") and g2.has("lon"):
				show_weather.call(str(g2["lat"]), str(g2["lon"]), str(g2.get("city", "")))
			else:
				zimmy.notify(zimmy.lang_text("não achei sua localização 🌍", "couldn't find your location 🌍"))
		)
	)
