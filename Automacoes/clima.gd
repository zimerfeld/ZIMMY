# Clima / tempo atual, via Open-Meteo (grátis, sem chave) + ipapi.co (geolocalização por IP).
# Clique para ver na hora; ou agende adicionando, p.ex., const SCHEDULE := "daily@07:00".
# Para fixar sua cidade (sem depender do IP), preencha LAT/LON abaixo (e CITY, opcional).
extends RefCounted

const AUTOMATION_NAME := "Clima 🌤️"
const AUTOMATION_NAME_EN := "Weather 🌤️"
const AUTOMATION_NAME_ES := "Clima 🌤️"

# Deixe vazio para autodetectar pela sua conexão (IP). Ex. fixo: LAT := "-23.55", LON := "-46.63".
const LAT := ""
const LON := ""
const CITY := ""   # rótulo opcional quando LAT/LON são fixos

# Códigos WMO do Open-Meteo -> [emoji, texto pt, texto en, texto es]. Ver open-meteo.com/en/docs
const WMO := {
	0:  ["☀️", "céu limpo", "clear sky", "cielo despejado"],
	1:  ["🌤️", "predomínio de sol", "mainly clear", "mayormente despejado"],
	2:  ["⛅", "parcialmente nublado", "partly cloudy", "parcialmente nublado"],
	3:  ["☁️", "nublado", "overcast", "nublado"],
	45: ["🌫️", "névoa", "fog", "niebla"],
	48: ["🌫️", "névoa gelada", "freezing fog", "niebla helada"],
	51: ["🌦️", "garoa fraca", "light drizzle", "llovizna ligera"],
	53: ["🌦️", "garoa", "drizzle", "llovizna"],
	55: ["🌦️", "garoa forte", "dense drizzle", "llovizna intensa"],
	56: ["🌧️", "garoa gelada", "freezing drizzle", "llovizna helada"],
	57: ["🌧️", "garoa gelada forte", "dense freezing drizzle", "llovizna helada intensa"],
	61: ["🌧️", "chuva fraca", "light rain", "lluvia ligera"],
	63: ["🌧️", "chuva", "rain", "lluvia"],
	65: ["🌧️", "chuva forte", "heavy rain", "lluvia fuerte"],
	66: ["🌧️", "chuva gelada", "freezing rain", "lluvia helada"],
	67: ["🌧️", "chuva gelada forte", "heavy freezing rain", "lluvia helada fuerte"],
	71: ["❄️", "neve fraca", "light snow", "nieve ligera"],
	73: ["❄️", "neve", "snow", "nieve"],
	75: ["❄️", "neve forte", "heavy snow", "nieve fuerte"],
	77: ["❄️", "grãos de neve", "snow grains", "granos de nieve"],
	80: ["🌦️", "pancadas fracas", "light showers", "chubascos ligeros"],
	81: ["🌦️", "pancadas de chuva", "rain showers", "chubascos"],
	82: ["⛈️", "pancadas fortes", "violent showers", "chubascos violentos"],
	85: ["🌨️", "pancadas de neve", "snow showers", "chubascos de nieve"],
	86: ["🌨️", "pancadas de neve fortes", "heavy snow showers", "chubascos de nieve fuertes"],
	95: ["⛈️", "trovoada", "thunderstorm", "tormenta"],
	96: ["⛈️", "trovoada com granizo", "thunderstorm w/ hail", "tormenta con granizo"],
	99: ["⛈️", "trovoada com granizo forte", "thunderstorm w/ heavy hail", "tormenta con granizo fuerte"],
}

func run(zimmy) -> void:
	zimmy.notify(zimmy.lang_text("vendo o tempo... 🌡️", "checking weather... 🌡️", "consultando el clima... 🌡️"))
	# Lambda local (não referencia self) para funcionar no clique e no disparo agendado.
	var show_weather := func(lat: String, lon: String, city: String):
		var url := "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,weather_code&timezone=auto" % [lat, lon]
		zimmy.http_get_json(url, func(ok, data):
			if not (ok and data is Dictionary and data.has("current")):
				zimmy.notify(zimmy.lang_text("falha ao buscar o clima 🌐", "weather fetch failed 🌐", "fallo al consultar el clima 🌐"))
				return
			var cur = data["current"]
			var code := int(cur.get("weather_code", -1))
			var info = WMO.get(code, ["🌡️", "tempo instável", "unsettled", "tiempo inestable"])
			var desc = zimmy.lang_text(info[1], info[2], info[3])
			var temp = zimmy.fmt_num(float(cur.get("temperature_2m", 0.0)), 1)
			var unit := str(data.get("current_units", {}).get("temperature_2m", "°C"))
			var where := ""
			if city != "":
				where = zimmy.lang_text(" em %s" % city, " in %s" % city, " en %s" % city)
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
				zimmy.notify(zimmy.lang_text("não achei sua localização 🌍", "couldn't find your location 🌍", "no encontré tu ubicación 🌍"))
		)
	)
