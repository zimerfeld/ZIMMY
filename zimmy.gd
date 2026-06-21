extends Node2D
## Zimmy — desktop pet overlay.
## Janela transparente/sem borda/always-on-top (ver project.godot).
## Arraste com o botão esquerdo para mover. Clique nele para reagir.
## Botão direito abre o menu. Esc fecha.
##
## Pets:
##  - O pet procedural é o "Default" — está sempre presente e nunca é removido.
##  - Cada pet é descrito por um config (cores + proporções + quais elementos o
##    compõem: orelhas/antenas/nariz/cílios/bochechas + estilo da boca). Ver
##    _default_cfg() e _random_cfg().
##  - "Salvar Pet" salva o pet exibido com um nome; "Escolher pet" o recarrega.
##  - Pets salvos persistem em user://pets.json.
##
## Acessórios (camada independente do pet — chapéu/óculos/laço/cachecol):
##  - Gerados aleatoriamente pela checkbox "Gerar acessórios aleatórios" (separada da
##    geração de pets) e exibidos conforme a checkbox "Mostrar acessórios".
##  - "Salvar Acessório" salva o acessório atual; "Escolher acessório" o recarrega
##    (dropdown com "Selecione..." como padrão). Persistem em user://accessories.json,
##    independentes dos pets.
##
## Ao abrir qualquer diálogo de Salvar a geração automática é desligada, para que se
## salve exatamente o que está na tela.
##
## A janela cresce/encolhe para comportar a fala (e emojis) sem cortes nem quebras
## desnecessárias — ver _relayout(). O Zimmy fica ancorado pelo centro-inferior.

const PET_BOX := 200        # espaço lógico de desenho (o _draw() usa coords 0..200)
const PET_SCALE := 0.75     # pet 25% menor que o espaço lógico
const PET_DRAW := int(PET_BOX * PET_SCALE)   # tamanho real do pet em pixels (150)
const HOP_HEADROOM := 80    # faixa transparente acima do pet p/ o pulo não cortar
const INK := Color(0.227, 0.141, 0.094)   # #3a2418

# --- balão de fala ---
const SPEECH_PAD_X := 18.0  # respiro lateral do texto (inclui o contorno)
const SPEECH_PAD_Y := 7.0   # respiro vertical do texto
const SPEECH_GAP := 4.0     # folga entre o balão e o topo do pet
const MAX_W := 640          # largura máxima antes de permitir quebra de linha

# --- pets / acessórios ---
const PETS_FILE := "user://pets.json"
const ACC_FILE := "user://accessories.json"
const SETTINGS_FILE := "user://settings.json"   # guarda a última posição na tela
const SCHEDULES_FILE := "user://schedules.json" # quais automações agendadas estão ligadas
const AUTOMACOES_DIR := "res://Automacoes/"   # scripts de automação (drop-in) — ver Automacoes/LEIAME.md
const RANDOM_PERIOD := 9.0  # segundos entre pets aleatórios (quando ligado)
const PET_COLOR_KEYS := ["body_color", "belly_color", "ear_color", "cheek_color",
	"antenna_color", "nose_color"]
const ACC_COLOR_KEYS := ["hat_color", "glasses_color", "bow_color", "scarf_color"]

var current: Dictionary = {}        # config do pet exibido agora
var current_acc: Dictionary = {}    # config do acessório exibido agora
var saved_pets: Dictionary = {}     # nome -> config (em memória, com Color)
var saved_accessories: Dictionary = {}  # nome -> config de acessório
var pet_menu_ids: Dictionary = {}   # id do item no dropdown -> nome do pet
var acc_menu_ids: Dictionary = {}   # id do item no dropdown -> nome do acessório
var current_pet_name := "Default"   # nome da opção ativa no submenu de pets ("" se aleatório)
var current_acc_name := "Nenhum"    # nome da opção ativa no submenu de acessórios ("" se aleatório)
var automation_ids: Dictionary = {} # id do item no submenu -> caminho do script de automação
# --- agendador de automações ---
var schedule_defs: Dictionary = {}     # caminho -> {name, kind, every, at_minute, label} das automações com frequência declarada
var automation_enabled: Dictionary = {} # caminho -> bool (quais agendadas estão ligadas; persistido)
var sched_runtime: Dictionary = {}      # caminho -> {accum, last_day, last_hour} (estado de disparo em runtime)
# --- grupos de menu, badges e credenciais de automações ---
var automation_groups: Dictionary = {}  # caminho -> nome do grupo (ex.: "email") via const MENU_GROUP
var automation_badge_keys: Dictionary = {} # caminho -> chave de badge (const BADGE_KEY)
var automation_cred_keys: Dictionary = {}  # caminho -> chave de credencial (const CRED_KEY)
var automation_icon_colors: Dictionary = {} # caminho -> Color do ícone (const ICON_COLOR, hex)
var automation_badges: Dictionary = {}   # chave de badge -> texto exibido (ex.: "3", "!")
var automation_item_menu: Dictionary = {} # id do item -> PopupMenu onde ele está (menu de automações ou de e-mail)
var _icon_cache: Dictionary = {}         # hex -> ImageTexture (ícones de provedor)
# --- credenciais (diálogo + estado) ---
const CRED_PREFIX := "user://cred_"      # arquivo por automação: user://cred_<key>.json (gitignored)
var cred_dialog: ConfirmationDialog
var cred_user_edit: LineEdit
var cred_pass_edit: LineEdit
var cred_pending_key := ""               # chave da credencial sendo solicitada agora
var cred_pending_cb := Callable()        # callback a chamar com {user, pass} ao confirmar
var cred_prompt_suppressed: Dictionary = {} # chaves cujo prompt o usuário cancelou (não insistir)
var random_pet_on := false
var random_acc_on := false
var random_pet_timer := 0.0
var random_acc_timer := 0.0
var show_accessories := true

# --- estado ---
var happy := 70.0
var hunger := 40.0

# --- limite de interação: 1 ação/clique por segundo e a mesma ação no máx. 3x seguidas ---
const ACTION_COOLDOWN := 1.0
const MAX_REPEAT := 3
const COMPLAIN_COOLDOWN := 1.5    # respiro entre reclamações (evita spam de fala)
# Frases de mau humor quando insistem na mesma ação: repulsa / raiva / tristeza /
# indiferença / descaso.
const MOOD_NEG := [
	"eca, de novo não 🤢", "para com isso! 😠", "grrr... 😤",
	"de novo?... 😢", "tô cansado disso 😞",
	"tanto faz 😑", "que seja... 🙄", "...zzz 😴",
]
var action_cd := 0.0
var last_action := ""
var action_repeats := 0
var complain_cd := 0.0

# --- animação ---
var bob := 0.0          # respiração (seno)
var y_off := 0.0        # deslocamento do pulinho
var vy := 0.0           # velocidade vertical do pulo
var blink_t := 0.0      # tempo restante de piscada
var blink_timer := 2.5  # contagem até a próxima piscada
var pupil_off := Vector2.ZERO

# --- arrasto da janela ---
var dragging := false
var moved := false
var drag_offset := Vector2i.ZERO

# --- layout dinâmico da janela ---
var win_w := PET_DRAW
var win_h := PET_DRAW + HOP_HEADROOM
var pet_x := 0.0
var pet_y := 0.0
var anchor := Vector2i.ZERO  # ponto fixo na tela = centro-inferior do pet

# --- fala ---
var speech: Label
var speech_clear := 0.0
var expression := "neutral"   # emoção refletida no rosto (vinda do emoji falado)

# --- UI ---
var menu: PopupMenu
var pets_menu: PopupMenu
var acc_menu: PopupMenu
var automations_menu: PopupMenu
var email_menu: PopupMenu
var save_dialog: ConfirmationDialog
var name_edit: LineEdit
var save_mode := "pet"      # "pet" ou "acc" — o que o diálogo de salvar grava

# --- ids dos itens do menu principal ---
const MI_FEED := 0
const MI_PET := 1
const MI_PLAY := 2
const MI_RANDOM := 3
const MI_SHOW_ACC := 4
const MI_SAVE_PET := 5
const MI_CHOOSE_PET := 6
const MI_SAVE_ACC := 7
const MI_CHOOSE_ACC := 8
const MI_QUIT := 9
const MI_RANDOM_ACC := 10
const MI_AUTOMATIONS := 11
const MI_EMAIL := 12

# ------------------------------------------------------------------ config de pet
## Config do pet padrão (a carinha original do Zimmy). Sempre disponível.
func _default_cfg() -> Dictionary:
	return {
		"body_color": Color("e88a4d"),
		"belly_color": Color("f2c9a8"),
		"ear_color": Color("d8703a"),
		"cheek_color": Color(0.95, 0.63, 0.63, 0.6),
		"ear_dx": 34.0, "ear_y": 74.0, "ear_w": 14.0, "ear_h": 27.0,
		"eye_dx": 18.0, "eye_y": 96.0, "eye_w": 10.0, "eye_h": 12.0,
		"body_w": 58.0, "body_h": 56.0, "belly_w": 40.0, "belly_h": 34.0,
		# elementos opcionais que compõem o pet
		"body_shape": "round",
		"has_ears": true, "ear_shape": "round",
		"has_antennae": false, "antenna_color": Color("d8703a"),
		"has_cheeks": true,
		"has_nose": false, "nose_color": Color("c47a5a"),
		"has_eyelashes": false,
		"mouth_style": "smile",
	}

## Gera um pet aleatório com estética equilibrada e cores alegres.
## - Geometria: sorteia a silhueta do corpo (round/tall/wide/pear) + forma de orelha,
##   além de proporções, mantendo o estilo "Zimmy".
## - Cor: parte de um matiz base e deriva as cores de destaque por um *esquema de
##   harmonia* (análogo/complementar/triádico/mono), com saturação/brilho em faixas
##   vibrantes-porém-suaves (tema alegre), garantindo contraste corpo↔barriga.
func _random_cfg() -> Dictionary:
	var hue := randf()
	# Esquema de harmonia define o matiz de destaque (orelha/antena/nariz).
	var scheme: String = ["analogous", "complementary", "triadic", "monochrome"].pick_random()
	var accent_hue := hue
	match scheme:
		"analogous":    accent_hue = fposmod(hue + (0.08 if randf() < 0.5 else -0.08), 1.0)
		"complementary": accent_hue = fposmod(hue + 0.5, 1.0)
		"triadic":      accent_hue = fposmod(hue + 1.0 / 3.0, 1.0)
		_:              accent_hue = hue
	# Faixas alegres: saturação média-alta + brilho alto (evita tons sujos/escuros).
	var body_s := randf_range(0.42, 0.68)
	var body_v := randf_range(0.86, 0.98)
	var body := Color.from_hsv(hue, body_s, body_v)
	# Barriga: mesmo matiz, bem dessaturada e clara — contraste suave e coeso.
	var belly := Color.from_hsv(hue, body_s * 0.28, minf(body_v + 0.05, 1.0))
	# Orelha/antena: matiz de destaque, um pouco mais saturado e mais escuro p/ profundidade.
	var ear := Color.from_hsv(accent_hue, clampf(body_s + 0.14, 0.0, 0.9), clampf(body_v - 0.14, 0.4, 1.0))
	# Bochecha: rosado quente fixo (carisma), translúcido.
	var cheek := Color.from_hsv(fposmod(hue + 0.95, 1.0), 0.5, 1.0)
	cheek.a = 0.55
	# Nariz: destaque suave, legível sobre a barriga clara.
	var nose := Color.from_hsv(accent_hue, randf_range(0.4, 0.6), randf_range(0.45, 0.65))
	return {
		"body_color": body, "belly_color": belly, "ear_color": ear, "cheek_color": cheek,
		"ear_dx": randf_range(28.0, 40.0), "ear_y": randf_range(68.0, 80.0),
		"ear_w": randf_range(10.0, 18.0), "ear_h": randf_range(20.0, 32.0),
		"eye_dx": randf_range(14.0, 22.0), "eye_y": randf_range(90.0, 100.0),
		"eye_w": randf_range(8.0, 12.0), "eye_h": randf_range(9.0, 14.0),
		"body_w": randf_range(52.0, 62.0), "body_h": randf_range(50.0, 58.0),
		"belly_w": randf_range(34.0, 44.0), "belly_h": randf_range(30.0, 38.0),
		"body_shape": ["round", "round", "tall", "wide", "pear"].pick_random(),
		"has_ears": randf() < 0.85,
		"ear_shape": ["round", "pointy"].pick_random(),
		"has_antennae": randf() < 0.4,
		"antenna_color": ear,
		"has_cheeks": randf() < 0.7,
		"has_nose": randf() < 0.6,
		"nose_color": nose,
		"has_eyelashes": randf() < 0.5,
		"mouth_style": ["smile", "cat", "open", "line"].pick_random(),
	}

# ------------------------------------------------------------------ config de acessório
## Acessório "vazio" (nada vestido) — é o padrão do Default.
func _default_acc() -> Dictionary:
	return {
		"hat": "none", "hat_color": Color("c0392b"),
		"glasses": "none", "glasses_color": Color("2c3e50"),
		"bow": "none", "bow_color": Color("e84393"),
		"scarf": "none", "scarf_color": Color("2980b9"),
	}

## Gera acessórios aleatórios (chapéu/óculos/laço/cachecol e cores).
func _random_acc() -> Dictionary:
	return {
		"hat": ["none", "beanie", "tophat", "crown", "cap"].pick_random(),
		"hat_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.7, 0.95)),
		"glasses": ["none", "round", "square", "star"].pick_random(),
		"glasses_color": Color.from_hsv(randf(), randf_range(0.2, 0.6), randf_range(0.15, 0.45)),
		"bow": ["none", "head", "neck"].pick_random(),
		"bow_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.8, 1.0)),
		"scarf": ["none", "present"].pick_random(),
		"scarf_color": Color.from_hsv(randf(), randf_range(0.4, 0.8), randf_range(0.6, 0.9)),
	}

func _ready() -> void:
	# Popups (menu/diálogo) como janelas nativas, não embutidas na janelinha.
	get_tree().root.gui_embed_subwindows = false
	# Garante o fundo transparente do viewport raiz (além das flags da janela).
	get_tree().root.transparent_bg = true
	# No build exportado (Windows) a janela pode iniciar opaca: reforça a flag
	# de transparência e zera o alfa da cor de limpeza para o fundo sumir.
	get_window().set_flag(Window.FLAG_TRANSPARENT, true)
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))

	current = _default_cfg()
	current_acc = _default_acc()
	_load_pets_from_disk()
	_load_accessories_from_disk()
	_load_selection()   # restaura a última escolha de pet/acessório (após carregar os salvos)

	# Posição: usa a última posição salva; na primeira vez, centraliza o pet na tela.
	get_window().size = Vector2i(win_w, win_h)
	var scr := DisplayServer.screen_get_usable_rect()
	if not _load_window_pos():
		# anchor = centro-inferior do pet; centraliza o corpo do pet no meio da tela.
		anchor = Vector2i(
			scr.position.x + scr.size.x / 2,
			scr.position.y + scr.size.y / 2 + PET_DRAW / 2)
	var start_pos := anchor - Vector2i(win_w / 2, win_h)
	start_pos.x = clampi(start_pos.x, scr.position.x, scr.position.x + scr.size.x - win_w)
	start_pos.y = clampi(start_pos.y, scr.position.y, scr.position.y + scr.size.y - win_h)
	get_window().position = start_pos

	# Balão de fala (Label com contorno). Fonte padrão do Godot (renderiza emojis).
	speech = Label.new()
	speech.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	speech.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	speech.add_theme_color_override("font_color", Color(1, 1, 1))
	speech.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
	speech.add_theme_constant_override("outline_size", 5)
	speech.add_theme_font_size_override("font_size", 14)
	add_child(speech)

	_load_schedules()   # antes de montar o menu, para os checkboxes refletirem o estado
	_build_menu()
	_build_save_dialog()

	say("olá! eu sou o Zimmy 🧡")

# ------------------------------------------------------------------ menu / UI
func _build_menu() -> void:
	pets_menu = PopupMenu.new()
	pets_menu.id_pressed.connect(_on_pick_pet)
	acc_menu = PopupMenu.new()
	acc_menu.id_pressed.connect(_on_pick_acc)
	automations_menu = PopupMenu.new()
	automations_menu.id_pressed.connect(_on_pick_automation)
	email_menu = PopupMenu.new()
	email_menu.id_pressed.connect(_on_pick_automation)

	menu = PopupMenu.new()
	menu.add_item("🦴 Alimentar", MI_FEED)
	menu.add_item("🤚 Carinho", MI_PET)
	menu.add_item("🎾 Brincar", MI_PLAY)
	menu.add_separator()
	menu.add_check_item("🎲 Gerar pets", MI_RANDOM)
	menu.add_check_item("🎲 Gerar acessórios", MI_RANDOM_ACC)
	menu.add_check_item("👓 Mostrar acessórios", MI_SHOW_ACC)
	menu.set_item_checked(menu.get_item_index(MI_SHOW_ACC), show_accessories)
	menu.add_separator()
	menu.add_item("💾 Salvar Pet...", MI_SAVE_PET)
	menu.add_submenu_node_item("📂 Escolher pet", pets_menu, MI_CHOOSE_PET)
	menu.add_item("🎀 Salvar Acessório...", MI_SAVE_ACC)
	menu.add_submenu_node_item("🧳 Escolher acessório", acc_menu, MI_CHOOSE_ACC)
	menu.add_separator()
	menu.add_submenu_node_item("⚙️ Automações", automations_menu, MI_AUTOMATIONS)
	menu.add_submenu_node_item("📧 E-mails", email_menu, MI_EMAIL)
	menu.add_separator()
	menu.add_item("Sair", MI_QUIT)
	menu.id_pressed.connect(_on_menu)
	add_child(menu)
	_build_cred_dialog()
	_rebuild_pets_menu()
	_rebuild_acc_menu()
	_rebuild_automations_menu()

## (Re)constrói o dropdown de pets: "Selecione..." (0) e "Default" (1) no topo.
func _rebuild_pets_menu() -> void:
	pets_menu.clear()
	pet_menu_ids.clear()
	pets_menu.add_item("Selecione...", 0)
	pets_menu.set_item_disabled(0, true)
	pets_menu.add_radio_check_item("Default", 1)
	var next_id := 100
	for nm in saved_pets.keys():
		pets_menu.add_radio_check_item(nm, next_id)
		pet_menu_ids[next_id] = nm
		next_id += 1
	_refresh_pets_menu_checks()

## Marca (✓) a opção ativa no submenu de pets conforme current_pet_name.
func _refresh_pets_menu_checks() -> void:
	pets_menu.set_item_checked(pets_menu.get_item_index(1), current_pet_name == "Default")
	for id in pet_menu_ids.keys():
		var idx := pets_menu.get_item_index(id)
		if idx >= 0:
			pets_menu.set_item_checked(idx, String(pet_menu_ids[id]) == current_pet_name)

## (Re)constrói o dropdown de acessórios: "Selecione..." (0) e "Nenhum" (1) no topo.
func _rebuild_acc_menu() -> void:
	acc_menu.clear()
	acc_menu_ids.clear()
	acc_menu.add_item("Selecione...", 0)
	acc_menu.set_item_disabled(0, true)
	acc_menu.add_radio_check_item("Nenhum", 1)
	var next_id := 100
	for nm in saved_accessories.keys():
		acc_menu.add_radio_check_item(nm, next_id)
		acc_menu_ids[next_id] = nm
		next_id += 1
	_refresh_acc_menu_checks()

## Marca (✓) a opção ativa no submenu de acessórios conforme current_acc_name.
func _refresh_acc_menu_checks() -> void:
	acc_menu.set_item_checked(acc_menu.get_item_index(1), current_acc_name == "Nenhum")
	for id in acc_menu_ids.keys():
		var idx := acc_menu.get_item_index(id)
		if idx >= 0:
			acc_menu.set_item_checked(idx, String(acc_menu_ids[id]) == current_acc_name)

# ------------------------------------------------------------------ automações
## (Re)constrói o submenu de Automações a partir dos scripts em res://Automacoes/.
## Sem nenhuma automação válida, o item "⚙️ Automações" do menu fica desabilitado.
func _rebuild_automations_menu() -> void:
	automations_menu.clear()
	email_menu.clear()
	automation_ids.clear()
	automation_item_menu.clear()
	var list := _scan_automations()
	var n_auto := 0
	var n_email := 0
	var next_id := 100
	for a in list:
		var path: String = a["path"]
		var sched: Dictionary = a["sched"]
		var group: String = automation_groups.get(path, "")
		var target: PopupMenu = email_menu if group == "email" else automations_menu
		# Rótulo: nome + (frequência, se agendada) + (badge, se houver).
		var label: String = a["name"]
		if not sched.is_empty():
			label += " — %s" % sched["label"]
		if automation_badge_keys.has(path):
			var bk: String = automation_badge_keys[path]
			if automation_badges.has(bk):
				label += " — %s não lidos" % automation_badges[bk]
		# E-mail: ícone do provedor à esquerda (cor de ICON_COLOR).
		var icon: Texture2D = null
		if group == "email" and automation_icon_colors.has(path):
			icon = _provider_icon(automation_icon_colors[path])
		# Agendadas viram item marcável (✓ = ligada); avulsas, item comum.
		if not sched.is_empty():
			if icon != null:
				target.add_icon_check_item(icon, label, next_id)
			else:
				target.add_check_item(label, next_id)
			target.set_item_checked(target.get_item_index(next_id), bool(automation_enabled.get(path, false)))
		else:
			if icon != null:
				target.add_icon_item(icon, label, next_id)
			else:
				target.add_item(label, next_id)
		automation_ids[next_id] = path
		automation_item_menu[next_id] = target
		if group == "email":
			n_email += 1
		else:
			n_auto += 1
		next_id += 1
	menu.set_item_disabled(menu.get_item_index(MI_AUTOMATIONS), n_auto == 0)
	menu.set_item_disabled(menu.get_item_index(MI_EMAIL), n_email == 0)

## Ícone simples de provedor: um círculo preenchido na cor dada (cacheado por cor).
func _provider_icon(color: Color) -> Texture2D:
	var hex := color.to_html(false)
	if _icon_cache.has(hex):
		return _icon_cache[hex]
	var sz := 16
	var img := Image.create(sz, sz, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(sz / 2.0, sz / 2.0)
	for y in sz:
		for x in sz:
			if Vector2(x + 0.5, y + 0.5).distance_to(c) <= sz / 2.0 - 1.0:
				img.set_pixel(x, y, color)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[hex] = tex
	return tex

## Lista os scripts .gd de res://Automacoes/ como [{name, path, sched}], ordenados pelo
## nome. Também (re)preenche schedule_defs com as automações que declaram frequência.
func _scan_automations() -> Array:
	var out: Array = []
	schedule_defs.clear()
	automation_groups.clear()
	automation_badge_keys.clear()
	automation_cred_keys.clear()
	automation_icon_colors.clear()
	var dir := DirAccess.open(AUTOMACOES_DIR)
	if dir == null:
		return out                     # pasta ausente => nenhuma automação
	dir.list_dir_begin()
	var fn := dir.get_next()
	while fn != "":
		if not dir.current_is_dir():
			var f := fn
			if f.ends_with(".remap"):   # build exportado renomeia .gd -> .gd.remap
				f = f.trim_suffix(".remap")
			if f.ends_with(".gd"):
				var path := AUTOMACOES_DIR + f
				var gd = load(path)
				var nm := _automation_name_from(gd, f)
				var sched := _parse_schedule(gd)
				if not sched.is_empty():
					sched["name"] = nm
					schedule_defs[path] = sched
				# Consts opcionais para grupo de menu, badge, credencial e cor do ícone.
				var consts: Dictionary = (gd as GDScript).get_script_constant_map() if gd is GDScript else {}
				if consts.has("MENU_GROUP"):
					automation_groups[path] = str(consts["MENU_GROUP"])
				if consts.has("BADGE_KEY"):
					automation_badge_keys[path] = str(consts["BADGE_KEY"])
				if consts.has("CRED_KEY"):
					automation_cred_keys[path] = str(consts["CRED_KEY"])
				if consts.has("ICON_COLOR"):
					automation_icon_colors[path] = Color(str(consts["ICON_COLOR"]))
				out.append({"name": nm, "path": path, "sched": sched})   # sched == {} quando não há agendamento
		fn = dir.get_next()
	dir.list_dir_end()
	out.sort_custom(func(a, b): return String(a["name"]).naturalnocasecmp_to(String(b["name"])) < 0)
	return out

## Nome de exibição da automação: usa a constante AUTOMATION_NAME do script, se houver;
## senão, deriva do nome do arquivo (snake_case -> "Snake Case").
func _automation_name_from(gd, filename: String) -> String:
	if gd is GDScript:
		var consts: Dictionary = (gd as GDScript).get_script_constant_map()
		if consts.has("AUTOMATION_NAME"):
			return str(consts["AUTOMATION_NAME"])
	return filename.trim_suffix(".gd").capitalize()

## Lê a frequência declarada por uma automação (constantes SCHEDULE ou SCHEDULE_SECONDS)
## e devolve {kind, every, at_minute, label} — ou {} se a automação não tem agendamento.
## Formatos de SCHEDULE: "30s" / "5m" / "2h" / "hourly" / "daily@09:00"; SCHEDULE_SECONDS: número.
func _parse_schedule(gd) -> Dictionary:
	if not (gd is GDScript):
		return {}
	var consts: Dictionary = (gd as GDScript).get_script_constant_map()
	var raw := ""
	if consts.has("SCHEDULE"):
		raw = str(consts["SCHEDULE"]).strip_edges().to_lower()
	elif consts.has("SCHEDULE_SECONDS"):
		raw = str(consts["SCHEDULE_SECONDS"])
	if raw == "":
		return {}
	if raw.is_valid_float():                       # número puro => segundos
		return _interval_def(float(raw))
	if raw == "hourly":                            # toda hora cheia (XX:00)
		return {"kind": "hourly", "every": 0.0, "at_minute": -1, "label": "toda hora cheia"}
	if raw.begins_with("daily@"):                  # uma vez por dia em HH:MM
		var hm := raw.substr(6).split(":")
		var h := clampi(int(hm[0]), 0, 23)
		var m := clampi((int(hm[1]) if hm.size() > 1 else 0), 0, 59)
		return {"kind": "daily", "every": 0.0, "at_minute": h * 60 + m, "label": "todo dia %02d:%02d" % [h, m]}
	var unit := raw.substr(raw.length() - 1)        # sufixo de unidade: 30s / 5m / 2h
	var num := raw.substr(0, raw.length() - 1)
	if num.is_valid_float():
		match unit:
			"s": return _interval_def(float(num))
			"m": return _interval_def(float(num) * 60.0)
			"h": return _interval_def(float(num) * 3600.0)
	return {}

func _interval_def(secs: float) -> Dictionary:
	secs = maxf(secs, 1.0)
	return {"kind": "interval", "every": secs, "at_minute": -1, "label": "a cada " + _human_secs(secs)}

## "90" -> "1.5min", "3600" -> "1h", "30" -> "30s" (rótulo humano da frequência).
func _human_secs(s: float) -> String:
	if s >= 3600.0:
		return _trim_num(s / 3600.0) + "h"
	if s >= 60.0:
		return _trim_num(s / 60.0) + "min"
	return _trim_num(s) + "s"

func _trim_num(v: float) -> String:
	if absf(v - round(v)) < 0.01:
		return str(int(round(v)))
	return "%.1f" % v

func _on_pick_automation(id: int) -> void:
	if not automation_ids.has(id):
		return
	var path := String(automation_ids[id])
	if schedule_defs.has(path):
		# Agendada: alterna ligada/desligada (persistente) em vez de rodar na hora.
		var on := not bool(automation_enabled.get(path, false))
		_set_automation_enabled(path, on, true)
		var m: PopupMenu = automation_item_menu.get(id, automations_menu)
		m.set_item_checked(m.get_item_index(id), on)
	else:
		_run_automation(path)          # avulsa: executa uma vez

## Liga/desliga uma automação agendada, persiste o estado e (re)inicia o seu runtime.
func _set_automation_enabled(path: String, on: bool, announce: bool) -> void:
	automation_enabled[path] = on
	if on:
		sched_runtime[path] = {"accum": 0.0, "last_day": -1, "last_hour": -1}
		if announce and schedule_defs.has(path):
			say("⏱️ %s ligada (%s)" % [schedule_defs[path].get("name", "automação"), schedule_defs[path]["label"]])
		# Automações com credencial (e-mail): ao ligar, dispara já (pede login se faltar).
		if automation_cred_keys.has(path):
			cred_prompt_suppressed.erase(automation_cred_keys[path])
			_fire_automation(path)
	else:
		sched_runtime.erase(path)
		if announce and schedule_defs.has(path):
			say("⏸️ %s desligada" % schedule_defs[path].get("name", "automação"))
	_save_schedules()

## Percorre as automações agendadas e dispara as que atingiram a sua frequência.
## Chamado a cada frame por _process.
func _tick_schedules(delta: float) -> void:
	var now := Time.get_datetime_dict_from_system()
	var cur_min: int = int(now.hour) * 60 + int(now.minute)
	for path in schedule_defs:
		if not bool(automation_enabled.get(path, false)):
			continue
		if not sched_runtime.has(path):
			sched_runtime[path] = {"accum": 0.0, "last_day": -1, "last_hour": -1}
		var def: Dictionary = schedule_defs[path]
		var rt: Dictionary = sched_runtime[path]
		match def["kind"]:
			"interval":
				rt["accum"] += delta
				if rt["accum"] >= float(def["every"]):
					rt["accum"] = 0.0
					_fire_automation(path)
			"hourly":
				if int(now.minute) == 0 and rt.get("last_hour", -1) != int(now.hour):
					rt["last_hour"] = int(now.hour)
					_fire_automation(path)
			"daily":
				if cur_min == int(def["at_minute"]) and rt.get("last_day", -1) != int(now.day):
					rt["last_day"] = int(now.day)
					_fire_automation(path)

## Dispara uma automação agendada: instancia e chama run(zimmy) como ação pontual.
## Diferente do menu avulso, NÃO mantém Nodes vivos — a recorrência é do agendador.
func _fire_automation(path: String) -> void:
	var gd = load(path)
	if not (gd is GDScript):
		return
	var inst = (gd as GDScript).new()
	if inst == null:
		return
	if inst.has_method("run"):
		inst.run(self)
	if inst is Node:
		inst.free()

## Carrega quais automações agendadas estavam ligadas (user://schedules.json).
func _load_schedules() -> void:
	var parsed = _read_json(SCHEDULES_FILE)
	if parsed is Dictionary:
		for path in parsed:
			if parsed[path]:
				automation_enabled[path] = true
				sched_runtime[path] = {"accum": 0.0, "last_day": -1, "last_hour": -1}

## Persiste o conjunto de automações agendadas ligadas.
func _save_schedules() -> void:
	var out := {}
	for path in automation_enabled:
		if automation_enabled[path]:
			out[path] = true
	var f := FileAccess.open(SCHEDULES_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(out, "  "))
		f.close()

## Carrega e executa o script de automação: instancia e chama run(zimmy), onde
## zimmy é este próprio nó (dá acesso a say(), feed(), pet(), play(), current, etc.).
func _run_automation(path: String) -> void:
	var gd = load(path)
	if not (gd is GDScript):
		say("automação inválida 🚫")
		return
	var inst = (gd as GDScript).new()
	if inst == null:
		say("automação inválida 🚫")
		return
	if inst is Node:
		add_child(inst)               # Node persiste para automações contínuas
	if inst.has_method("run"):
		inst.run(self)
	else:
		say("automação sem run() 🤔")

## Utilitário para automações web: faz um GET em `url` e chama
## `cb.call(ok: bool, data)` com o JSON decodificado (Dictionary/Array) ou null.
## Cria e descarta o HTTPRequest internamente — a automação não precisa gerenciar nada.
## IMPORTANTE p/ a automação: na closure passada use só `zimmy` e variáveis locais
## (não `self`), assim ela funciona tanto no clique quanto no disparo agendado.
func http_get_json(url: String, cb: Callable) -> void:
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(_result, code, _headers, body):
		var data = null
		if code == 200:
			data = JSON.parse_string(body.get_string_from_utf8())
		if cb.is_valid():
			cb.call(code == 200 and data != null, data)
		http.queue_free()
	)
	if http.request(url) != OK:
		if cb.is_valid():
			cb.call(false, null)
		http.queue_free()

# ------------------------------------------------------------------ badges de automação
## Define o texto do badge (ex.: contador de não-lidos) de uma automação, por chave
## (const BADGE_KEY). Aparece no rótulo do item na próxima vez que o menu é montado.
func set_automation_badge(key: String, text: String) -> void:
	automation_badges[key] = text

# ------------------------------------------------------------------ credenciais
## Caminho do arquivo de credencial de uma automação: user://cred_<key>.json (gitignored).
func _cred_path(key: String) -> String:
	return CRED_PREFIX + key + ".json"

## Lê as credenciais salvas de `key` (ou {} se não houver / inválidas).
func load_credentials(key: String) -> Dictionary:
	var parsed = _read_json(_cred_path(key))
	if parsed is Dictionary and parsed.has("user") and parsed.has("pass"):
		return {"user": str(parsed["user"]), "pass": str(parsed["pass"])}
	return {}

## Grava as credenciais de `key` em disco (arquivo separado por automação).
func save_credentials(key: String, data: Dictionary) -> void:
	var f := FileAccess.open(_cred_path(key), FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"user": data.get("user", ""), "pass": data.get("pass", "")}, "  "))
		f.close()

## Apaga as credenciais salvas (ex.: validação falhou — força novo prompt).
func forget_credentials(key: String) -> void:
	var da := DirAccess.open("user://")
	if da and da.file_exists("cred_%s.json" % key):
		da.remove("cred_%s.json" % key)

## Entrega as credenciais de `key` a `cb.call({user, pass})`. Se não houver salvas,
## abre o diálogo de login (a menos que o usuário já tenha cancelado este `key`).
## NÃO salva sozinho — a automação valida e chama confirm_credentials() se válido.
func with_credentials(key: String, title: String, cb: Callable) -> void:
	var saved := load_credentials(key)
	if not saved.is_empty():
		if cb.is_valid():
			cb.call(saved)
		return
	if cred_prompt_suppressed.has(key) or cred_pending_key != "":
		return                          # já perguntando, ou usuário cancelou antes
	cred_pending_key = key
	cred_pending_cb = cb
	cred_dialog.title = title
	cred_user_edit.text = ""
	cred_pass_edit.text = ""
	var scr := DisplayServer.screen_get_usable_rect()
	cred_dialog.size = Vector2i(360, 170)
	cred_dialog.position = scr.position + (scr.size - cred_dialog.size) / 2
	cred_dialog.popup()
	cred_user_edit.grab_focus()

## Salva as credenciais se forem novas ou se usuário/senha mudaram (chamar após validar).
func confirm_credentials(key: String, data: Dictionary) -> void:
	var saved := load_credentials(key)
	if saved.get("user", "") != data.get("user", "") or saved.get("pass", "") != data.get("pass", ""):
		save_credentials(key, data)

func _build_cred_dialog() -> void:
	cred_dialog = ConfirmationDialog.new()
	cred_dialog.ok_button_text = "Entrar"
	cred_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	var l1 := Label.new(); l1.text = "E-mail:"
	cred_user_edit = LineEdit.new()
	cred_user_edit.custom_minimum_size = Vector2(320, 0)
	cred_user_edit.placeholder_text = "voce@gmail.com"
	var l2 := Label.new(); l2.text = "App Password (senha de app):"
	cred_pass_edit = LineEdit.new()
	cred_pass_edit.secret = true
	cred_pass_edit.placeholder_text = "senha de aplicativo (não a senha normal)"
	box.add_child(l1); box.add_child(cred_user_edit)
	box.add_child(l2); box.add_child(cred_pass_edit)
	cred_dialog.add_child(box)
	cred_dialog.confirmed.connect(_on_cred_confirmed)
	cred_dialog.canceled.connect(_on_cred_canceled)
	add_child(cred_dialog)

func _on_cred_confirmed() -> void:
	var u := cred_user_edit.text.strip_edges()
	var p := cred_pass_edit.text          # senha pode ter espaços; não corta
	var cb := cred_pending_cb
	cred_pending_key = ""
	cred_pending_cb = Callable()
	if u == "" or p == "":
		say("login incompleto 🙈")
		return
	if cb.is_valid():
		cb.call({"user": u, "pass": p})

func _on_cred_canceled() -> void:
	if cred_pending_key != "":
		cred_prompt_suppressed[cred_pending_key] = true   # não insistir até religar/clicar
	cred_pending_key = ""
	cred_pending_cb = Callable()

# ------------------------------------------------------------------ IMAP (e-mail)
## Conta e-mails NÃO LIDOS via IMAP sobre TLS e chama cb.call(ok: bool, count: int).
## Usa LOGIN + STATUS INBOX (UNSEEN). Pensado para App Passwords (Gmail/Outlook).
## É assíncrono (await) — roda sobre este nó, que está na árvore.
func imap_unread(host: String, port: int, user: String, password: String, cb: Callable) -> void:
	var tcp := StreamPeerTCP.new()
	if tcp.connect_to_host(host, port) != OK:
		cb.call(false, 0); return
	while tcp.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		tcp.poll()
		await get_tree().process_frame
	if tcp.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		cb.call(false, 0); return
	var tls := StreamPeerTLS.new()
	if tls.connect_to_stream(tcp, host, TLSOptions.client()) != OK:
		cb.call(false, 0); return
	while tls.get_status() == StreamPeerTLS.STATUS_HANDSHAKING:
		tls.poll()
		await get_tree().process_frame
	if tls.get_status() != StreamPeerTLS.STATUS_CONNECTED:
		cb.call(false, 0); return
	await _imap_read_until(tls, "")                       # saudação "* OK ..."
	_imap_send(tls, 'a1 LOGIN "%s" "%s"' % [_imap_escape(user), _imap_escape(password)])
	var login_resp: String = await _imap_read_until(tls, "a1 ")
	if not login_resp.to_upper().contains("A1 OK"):
		_imap_send(tls, "a3 LOGOUT")
		cb.call(false, 0); return
	_imap_send(tls, "a2 STATUS INBOX (UNSEEN)")
	var status_resp: String = await _imap_read_until(tls, "a2 ")
	_imap_send(tls, "a3 LOGOUT")
	cb.call(true, _imap_parse_unseen(status_resp))

func _imap_send(tls: StreamPeerTLS, line: String) -> void:
	tls.put_data((line + "\r\n").to_utf8_buffer())

## Lê do socket TLS até aparecer uma linha começando com `tag` (ou, se tag=="", até a
## primeira linha completa). Devolve todo o texto acumulado. Tem timeout de segurança.
func _imap_read_until(tls: StreamPeerTLS, tag: String) -> String:
	var acc := ""
	var frames := 0
	while frames < 1800:                                  # ~30s de teto a 60fps
		tls.poll()
		var n := tls.get_available_bytes()
		if n > 0:
			var chunk = tls.get_data(n)
			if chunk[0] == OK:
				acc += (chunk[1] as PackedByteArray).get_string_from_utf8()
		if tag == "":
			if acc.contains("\n"):
				return acc
		else:
			for ln in acc.split("\n"):
				if ln.strip_edges().to_upper().begins_with(tag.strip_edges().to_upper()):
					return acc
		if tls.get_status() != StreamPeerTLS.STATUS_CONNECTED and n == 0:
			return acc
		frames += 1
		await get_tree().process_frame
	return acc

## Extrai o número de "UNSEEN n" da resposta de STATUS (ou 0 se não achar).
func _imap_parse_unseen(resp: String) -> int:
	var up := resp.to_upper()
	var i := up.find("UNSEEN")
	if i < 0:
		return 0
	var rest := resp.substr(i + 6)
	var digits := ""
	for ch in rest:
		if ch >= "0" and ch <= "9":
			digits += ch
		elif digits != "":
			break
	return int(digits) if digits != "" else 0

func _imap_escape(s: String) -> String:
	return s.replace("\\", "\\\\").replace("\"", "\\\"")

func _build_save_dialog() -> void:
	save_dialog = ConfirmationDialog.new()
	save_dialog.ok_button_text = "Salvar"
	save_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	name_edit = LineEdit.new()
	name_edit.custom_minimum_size = Vector2(240, 0)
	save_dialog.add_child(name_edit)
	save_dialog.register_text_enter(name_edit)
	save_dialog.confirmed.connect(_on_save_confirmed)
	add_child(save_dialog)

func _on_menu(id: int) -> void:
	match id:
		MI_FEED: feed()
		MI_PET: pet()
		MI_PLAY: play()
		MI_RANDOM: _set_random_pet(not random_pet_on)
		MI_RANDOM_ACC: _set_random_acc(not random_acc_on)
		MI_SHOW_ACC: _set_show_accessories(not show_accessories)
		MI_SAVE_PET: _open_save_dialog("pet")
		MI_SAVE_ACC: _open_save_dialog("acc")
		MI_QUIT: get_tree().quit()

func _on_pick_pet(id: int) -> void:
	if id == 0:
		return                     # "Selecione..." é apenas um rótulo
	_set_random_pet(false)         # escolher um pet específico desliga o aleatório de pet
	if id == 1:
		current = _default_cfg()
		current_pet_name = "Default"
		say("Default 🐾")
	elif pet_menu_ids.has(id):
		current = (saved_pets[pet_menu_ids[id]] as Dictionary).duplicate(true)
		current_pet_name = String(pet_menu_ids[id])
		say("%s ✨" % pet_menu_ids[id])
	_refresh_pets_menu_checks()
	_save_settings()   # persiste a escolha para a próxima abertura
	queue_redraw()
	_relayout()

func _on_pick_acc(id: int) -> void:
	if id == 0:
		return                     # "Selecione..." é apenas um rótulo
	_set_random_acc(false)         # escolher um acessório desliga o aleatório de acessório
	_set_show_accessories(true)    # mostra o acessório escolhido
	if id == 1:
		current_acc = _default_acc()
		current_acc_name = "Nenhum"
		say("sem acessório 🚫")
	elif acc_menu_ids.has(id):
		current_acc = (saved_accessories[acc_menu_ids[id]] as Dictionary).duplicate(true)
		current_acc_name = String(acc_menu_ids[id])
		say("%s 🎀" % acc_menu_ids[id])
	_refresh_acc_menu_checks()
	_save_settings()   # persiste a escolha para a próxima abertura
	queue_redraw()

func _set_random_pet(on: bool) -> void:
	random_pet_on = on
	menu.set_item_checked(menu.get_item_index(MI_RANDOM), on)
	random_pet_timer = 0.0
	if on:
		current = _random_cfg()
		current_pet_name = ""          # pet aleatório não corresponde a nenhuma opção salva
		_refresh_pets_menu_checks()
		say("novo pet! 🎲")
		queue_redraw()
		_relayout()

func _set_random_acc(on: bool) -> void:
	random_acc_on = on
	menu.set_item_checked(menu.get_item_index(MI_RANDOM_ACC), on)
	random_acc_timer = 0.0
	if on:
		current_acc = _random_acc()
		current_acc_name = ""          # acessório aleatório não corresponde a nenhuma opção salva
		_refresh_acc_menu_checks()
		_set_show_accessories(true)   # gerar acessórios também liga a exibição
		say("novos acessórios! 🎲")
		queue_redraw()

## Desliga as duas gerações automáticas (usado ao abrir um diálogo de Salvar).
func _stop_random_all() -> void:
	_set_random_pet(false)
	_set_random_acc(false)

func _set_show_accessories(on: bool) -> void:
	show_accessories = on
	menu.set_item_checked(menu.get_item_index(MI_SHOW_ACC), on)
	_save_settings()   # persiste o estado de exibição de acessórios
	queue_redraw()

func _open_save_dialog(mode: String) -> void:
	# Requisito: ao abrir o diálogo de salvar, desliga a geração automática para
	# salvar exatamente o que está na tela.
	_stop_random_all()
	save_mode = mode
	if mode == "pet":
		save_dialog.title = "Salvar Pet"
		save_dialog.get_label().text = "Nome do pet:"
		name_edit.placeholder_text = "ex: Fofinho"
	else:
		save_dialog.title = "Salvar Acessório"
		save_dialog.get_label().text = "Nome do acessório:"
		name_edit.placeholder_text = "ex: Chapéu de Festa"
	name_edit.text = ""
	var scr := DisplayServer.screen_get_usable_rect()
	save_dialog.size = Vector2i(320, 150)
	save_dialog.position = scr.position + (scr.size - save_dialog.size) / 2
	save_dialog.popup()
	name_edit.grab_focus()

func _on_save_confirmed() -> void:
	var nm := name_edit.text.strip_edges()
	if nm == "" or nm == "Default" or nm == "Selecione..." or nm == "Nenhum":
		say("nome inválido 🙈")
		return
	if save_mode == "pet":
		saved_pets[nm] = current.duplicate(true)
		_save_pets_to_disk()
		_rebuild_pets_menu()
		say("pet salvo: %s 💾" % nm)
	else:
		saved_accessories[nm] = current_acc.duplicate(true)
		_save_accessories_to_disk()
		_rebuild_acc_menu()
		say("acessório salvo: %s 🎀" % nm)

# ------------------------------------------------------------------ persistência
func _cfg_to_json(cfg: Dictionary) -> Dictionary:
	var d := {}
	for k in cfg:
		var v = cfg[k]
		d[k] = ([v.r, v.g, v.b, v.a] if v is Color else v)
	return d

func _json_to_cfg(d: Dictionary, base: Dictionary, color_keys: Array) -> Dictionary:
	var out := base.duplicate(true)   # garante todas as chaves mesmo se o arquivo for parcial
	for k in d:
		var v = d[k]
		if k in color_keys and v is Array and v.size() == 4:
			out[k] = Color(v[0], v[1], v[2], v[3])
		else:
			out[k] = v
	return out

func _save_dict_to_disk(path: String, store: Dictionary) -> void:
	var out := {}
	for nm in store:
		out[nm] = _cfg_to_json(store[nm])
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(out, "  "))
		f.close()

func _save_pets_to_disk() -> void:
	_save_dict_to_disk(PETS_FILE, saved_pets)

func _save_accessories_to_disk() -> void:
	_save_dict_to_disk(ACC_FILE, saved_accessories)

func _load_pets_from_disk() -> void:
	var parsed = _read_json(PETS_FILE)
	if parsed is Dictionary:
		for nm in parsed:
			if parsed[nm] is Dictionary:
				saved_pets[nm] = _json_to_cfg(parsed[nm], _default_cfg(), PET_COLOR_KEYS)

func _load_accessories_from_disk() -> void:
	var parsed = _read_json(ACC_FILE)
	if parsed is Dictionary:
		for nm in parsed:
			if parsed[nm] is Dictionary:
				saved_accessories[nm] = _json_to_cfg(parsed[nm], _default_acc(), ACC_COLOR_KEYS)

func _read_json(path: String):
	if not FileAccess.file_exists(path):
		return null
	var f := FileAccess.open(path, FileAccess.READ)
	if not f:
		return null
	var txt := f.get_as_text()
	f.close()
	return JSON.parse_string(txt)

## Salva o ponto-âncora (centro-inferior do pet) + a escolha atual de pet e
## acessório, para reabrir o programa no mesmo lugar e com a mesma seleção.
func _save_settings() -> void:
	var f := FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({
			"anchor_x": anchor.x, "anchor_y": anchor.y,
			"pet": current_pet_name, "acc": current_acc_name,
			"show_acc": show_accessories,
		}, "  "))
		f.close()

## Carrega a âncora salva. Retorna true se havia uma posição gravada.
func _load_window_pos() -> bool:
	var parsed = _read_json(SETTINGS_FILE)
	if parsed is Dictionary and parsed.has("anchor_x") and parsed.has("anchor_y"):
		anchor = Vector2i(int(parsed["anchor_x"]), int(parsed["anchor_y"]))
		return true
	return false

## Restaura a última escolha de pet/acessório (e a exibição de acessórios)
## salva em settings.json. Deve rodar após carregar os salvos do disco e antes
## de montar o menu, para os checks (✓) refletirem a opção pré-selecionada.
func _load_selection() -> void:
	var parsed = _read_json(SETTINGS_FILE)
	if not (parsed is Dictionary):
		return
	if parsed.has("show_acc"):
		show_accessories = bool(parsed["show_acc"])
	if parsed.has("pet"):
		var pn := String(parsed["pet"])
		if pn == "Default":
			current = _default_cfg()
			current_pet_name = "Default"
		elif saved_pets.has(pn):
			current = (saved_pets[pn] as Dictionary).duplicate(true)
			current_pet_name = pn
	if parsed.has("acc"):
		var an := String(parsed["acc"])
		if an == "Nenhum":
			current_acc = _default_acc()
			current_acc_name = "Nenhum"
		elif saved_accessories.has(an):
			current_acc = (saved_accessories[an] as Dictionary).duplicate(true)
			current_acc_name = an

# ------------------------------------------------------------------ loop
func _process(delta: float) -> void:
	bob += delta * 2.2

	# Cooldown das interações (máx. uma ação/clique por segundo) e da reclamação.
	if action_cd > 0.0:
		action_cd -= delta
	if complain_cd > 0.0:
		complain_cd -= delta

	# Pulinho com "gravidade".
	y_off += vy * delta
	vy += 900.0 * delta
	if y_off > 0.0:
		y_off = 0.0
		vy = 0.0

	# Piscar.
	blink_timer -= delta
	if blink_timer <= 0.0:
		blink_t = 0.16
		blink_timer = randf_range(2.0, 5.0)
	if blink_t > 0.0:
		blink_t -= delta

	# Olhos seguem o cursor global (centro real do pet dentro da janela).
	var gm := DisplayServer.mouse_get_position()
	var center := get_window().position + Vector2i(
		int(pet_x + PET_DRAW / 2.0), int(pet_y + PET_DRAW / 2.0))
	var d := Vector2(gm - center)
	pupil_off = d.limit_length(120.0) / 120.0 * 3.5

	# Geração aleatória contínua (pet e acessórios são independentes).
	if random_pet_on:
		random_pet_timer += delta
		if random_pet_timer >= RANDOM_PERIOD:
			random_pet_timer = 0.0
			current = _random_cfg()
			say("novo pet! 🎲")
			_relayout()
	if random_acc_on:
		random_acc_timer += delta
		if random_acc_timer >= RANDOM_PERIOD:
			random_acc_timer = 0.0
			current_acc = _random_acc()
			say("novos acessórios! 🎲")
			_relayout()

	# Automações agendadas (auto-alimentar, lembretes, comemorações...).
	if not schedule_defs.is_empty():
		_tick_schedules(delta)

	# Necessidades com o tempo.
	hunger = clampf(hunger + delta * 0.7, 0.0, 100.0)
	if hunger > 70.0:
		happy = clampf(happy - delta * 0.5, 0.0, 100.0)

	# Limpa a fala (e encolhe a janela de volta).
	if speech_clear > 0.0:
		speech_clear -= delta
		if speech_clear <= 0.0:
			speech.text = ""
			expression = "neutral"
			_relayout()

	queue_redraw()

# ----------------------------------------------------- layout dinâmico da janela
## Redimensiona a janela para caber a fala atual e mantém o pet ancorado.
func _relayout() -> void:
	var scr := DisplayServer.screen_get_usable_rect()
	var band := 0.0
	# Espaço acima do pet: pelo menos o headroom do pulo; mais, se a fala precisar.
	var top_space := float(HOP_HEADROOM)

	if speech.text != "":
		var font := speech.get_theme_font("font")
		var fs := speech.get_theme_font_size("font_size")
		var line_h := font.get_height(fs)
		var tw := font.get_string_size(speech.text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, fs).x
		var content_w := tw + 2.0 * SPEECH_PAD_X
		var lines := 1
		if content_w <= float(MAX_W):
			win_w = int(max(float(PET_DRAW), ceil(content_w)))
			speech.autowrap_mode = TextServer.AUTOWRAP_OFF
		else:
			win_w = MAX_W
			speech.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lines = int(ceil(tw / (float(MAX_W) - 2.0 * SPEECH_PAD_X)))
		band = line_h * float(lines) + 2.0 * SPEECH_PAD_Y
		top_space = max(band + SPEECH_GAP, float(HOP_HEADROOM))
		speech.visible = true
	else:
		win_w = PET_DRAW
		speech.visible = false

	win_h = int(top_space + float(PET_DRAW))
	pet_x = (float(win_w) - float(PET_DRAW)) * 0.5
	pet_y = top_space

	# O balão fica logo acima do corpo do pet (e o headroom do pulo sobra por cima).
	speech.position = Vector2(SPEECH_PAD_X, pet_y - SPEECH_GAP - band)
	speech.size = Vector2(float(win_w) - 2.0 * SPEECH_PAD_X, band)

	get_window().size = Vector2i(win_w, win_h)
	var pos := anchor - Vector2i(int(win_w / 2.0), win_h)
	pos.x = clampi(pos.x, scr.position.x, scr.position.x + scr.size.x - win_w)
	pos.y = clampi(pos.y, scr.position.y, scr.position.y + scr.size.y - win_h)
	get_window().position = pos
	queue_redraw()

# ------------------------------------------------------------------ desenho
func _draw() -> void:
	draw_set_transform(Vector2(pet_x, pet_y), 0.0, Vector2(PET_SCALE, PET_SCALE))
	var o := Vector2(0.0, y_off)                 # deslocamento do pulo
	var br := sin(bob) * 0.025                    # respiração
	var c := current

	var body_color: Color = c["body_color"]
	var belly_color: Color = c["belly_color"]
	var ear_color: Color = c["ear_color"]
	var cheek_color: Color = c["cheek_color"]
	var ear_dx: float = c["ear_dx"]
	var ear_y: float = c["ear_y"]
	var ear_w: float = c["ear_w"]
	var ear_h: float = c["ear_h"]
	var eye_dx: float = c["eye_dx"]
	var eye_y: float = c["eye_y"]
	var eye_w: float = c["eye_w"]
	var eye_h: float = c["eye_h"]
	var body_w: float = c["body_w"]
	var body_h: float = c["body_h"]
	var belly_w: float = c["belly_w"]
	var belly_h: float = c["belly_h"]

	# Sombra (fica no chão, encolhe quando ele pula).
	var sh := 1.0 + y_off * 0.0035               # y_off é negativo no ar
	_ellipse(Vector2(100, 178), Vector2(46.0 * sh, 7.0), Color(0, 0, 0, 0.10))

	# Antenas (atrás do corpo).
	if c.get("has_antennae", false):
		var antenna_color: Color = c.get("antenna_color", ear_color)
		_draw_antenna(Vector2(100.0 - 12.0, ear_y - 2.0) + o, Vector2(100.0 - 26.0, ear_y - 30.0) + o, antenna_color)
		_draw_antenna(Vector2(100.0 + 12.0, ear_y - 2.0) + o, Vector2(100.0 + 26.0, ear_y - 30.0) + o, antenna_color)

	# Orelhas (redondas ou pontudas), se houver.
	if c.get("has_ears", true):
		if c.get("ear_shape", "round") == "pointy":
			_triangle(Vector2(100.0 - ear_dx - ear_w, ear_y + ear_h) + o,
				Vector2(100.0 - ear_dx + ear_w, ear_y + ear_h) + o,
				Vector2(100.0 - ear_dx, ear_y - ear_h) + o, ear_color)
			_triangle(Vector2(100.0 + ear_dx - ear_w, ear_y + ear_h) + o,
				Vector2(100.0 + ear_dx + ear_w, ear_y + ear_h) + o,
				Vector2(100.0 + ear_dx, ear_y - ear_h) + o, ear_color)
		else:
			_ellipse(Vector2(100.0 - ear_dx, ear_y) + o, Vector2(ear_w, ear_h), ear_color)
			_ellipse(Vector2(100.0 + ear_dx, ear_y) + o, Vector2(ear_w, ear_h), ear_color)

	# Corpo + barriga (respiram). A silhueta varia conforme body_shape: além de
	# esticar/achatar, "pear" desenha um bojo inferior extra (corpo em gota).
	var bw_mul := 1.0
	var bh_mul := 1.0
	var by := 0.0
	match c.get("body_shape", "round"):
		"tall": bw_mul = 0.9;  bh_mul = 1.2;  by = -3.0   # ovinho em pé
		"wide": bw_mul = 1.16; bh_mul = 0.86; by = 3.0    # baixinho fofo
		"pear": bw_mul = 0.96; bh_mul = 1.02; by = 0.0    # gota (bojo embaixo)
		_:      pass                                       # round (padrão)
	var bw := body_w * bw_mul
	var bh := body_h * bh_mul * (1.0 + br)
	if c.get("body_shape", "round") == "pear":
		_ellipse(Vector2(100, 122 + by) + o, Vector2(bw * 1.18, bh * 0.6), body_color)  # bojo inferior
	_ellipse(Vector2(100, 108 + by) + o, Vector2(bw, bh), body_color)
	_ellipse(Vector2(100, 118 + by * 0.5) + o, Vector2(belly_w * bw_mul, belly_h * bh_mul * (1.0 + br)), belly_color)

	# Bochechas.
	if c.get("has_cheeks", true):
		_ellipse(Vector2(70, 116) + o, Vector2(7, 4), cheek_color)
		_ellipse(Vector2(130, 116) + o, Vector2(7, 4), cheek_color)

	# Nariz (entre/abaixo dos olhos).
	if c.get("has_nose", false):
		var nose_color: Color = c.get("nose_color", INK)
		var ny := eye_y + 9.0
		_triangle(Vector2(100, ny + 3.0) + o, Vector2(96, ny - 2.0) + o, Vector2(104, ny - 2.0) + o, nose_color)

	# Olhos / boca. Se há fala com emoji emotivo, o rosto espelha a emoção;
	# senão, usa o rosto padrão (olhos seguindo o cursor + boca do config).
	var lx := 100.0 - eye_dx
	var rx := 100.0 + eye_dx
	var expr := expression if speech.text != "" else "neutral"
	if expr != "neutral":
		_draw_expression(expr, lx, rx, eye_y, eye_w, eye_h, o)
	else:
		if blink_t > 0.0:
			_ellipse(Vector2(lx, eye_y) + o, Vector2(eye_w, 2), Color.WHITE)
			_ellipse(Vector2(rx, eye_y) + o, Vector2(eye_w, 2), Color.WHITE)
		else:
			_ellipse(Vector2(lx, eye_y) + o, Vector2(eye_w, eye_h), Color.WHITE)
			_ellipse(Vector2(rx, eye_y) + o, Vector2(eye_w, eye_h), Color.WHITE)
			draw_circle(Vector2(lx + 2.0, eye_y + 2.0) + o + pupil_off, 5.5, INK)
			draw_circle(Vector2(rx + 2.0, eye_y + 2.0) + o + pupil_off, 5.5, INK)
			draw_circle(Vector2(lx + 4.0, eye_y - 1.0) + o + pupil_off, 1.8, Color.WHITE)
			draw_circle(Vector2(rx + 4.0, eye_y - 1.0) + o + pupil_off, 1.8, Color.WHITE)

		# Cílios.
		if c.get("has_eyelashes", false):
			_draw_eyelashes(Vector2(lx, eye_y) + o, eye_w, eye_h, -1.0)
			_draw_eyelashes(Vector2(rx, eye_y) + o, eye_w, eye_h, 1.0)

		# Boca (estilo configurável).
		_draw_mouth(c.get("mouth_style", "smile"), o)

	# Acessórios (camada por cima, controlada pela checkbox).
	if show_accessories:
		_draw_accessories(o, eye_dx, eye_y, eye_w)

# --------------------------------------------------- boca / partes do rosto
func _draw_mouth(style: String, o: Vector2) -> void:
	match style:
		"line":
			draw_line(Vector2(92, 116) + o, Vector2(108, 116) + o, INK, 2.5, true)
		"open":
			_ellipse(Vector2(100, 116) + o, Vector2(6, 5), INK)
			_ellipse(Vector2(100, 118) + o, Vector2(3.5, 2.5), Color(0.85, 0.4, 0.45))
		"cat":
			var l := _quad(Vector2(92, 110) + o, Vector2(96, 118) + o, Vector2(100, 113) + o, 8)
			var r := _quad(Vector2(100, 113) + o, Vector2(104, 118) + o, Vector2(108, 110) + o, 8)
			draw_polyline(l, INK, 2.2, true)
			draw_polyline(r, INK, 2.2, true)
		_:  # "smile" — reflete a felicidade
			var ctrl_y := 124.0 if happy > 60.0 else (116.0 if happy > 30.0 else 108.0)
			var mouth := _quad(Vector2(90, 112) + o, Vector2(100, ctrl_y) + o, Vector2(110, 112) + o, 14)
			draw_polyline(mouth, INK, 2.5, true)

## Desenha olhos + boca refletindo a emoção (espelha o emoji da fala).
func _draw_expression(expr: String, lx: float, rx: float, eye_y: float, eye_w: float, eye_h: float, o: Vector2) -> void:
	var lc := Vector2(lx, eye_y) + o
	var rc := Vector2(rx, eye_y) + o
	match expr:
		"happy":   # olhos fechados felizes (∩), blush e sorrisão
			draw_arc(lc, eye_w, PI, TAU, 14, INK, 2.5, true)
			draw_arc(rc, eye_w, PI, TAU, 14, INK, 2.5, true)
			var blush := Color(0.96, 0.5, 0.55, 0.65)
			_ellipse(lc + Vector2(-1.0, eye_h * 0.9), Vector2(6, 3.5), blush)
			_ellipse(rc + Vector2(1.0, eye_h * 0.9), Vector2(6, 3.5), blush)
			var m := _quad(Vector2(88, 112) + o, Vector2(100, 130) + o, Vector2(112, 112) + o, 16)
			draw_polyline(m, INK, 2.8, true)
		"excited":   # olhos arregalados com brilho + boca aberta
			for ec in [lc, rc]:
				_ellipse(ec, Vector2(eye_w + 1.5, eye_h + 2.0), Color.WHITE)
				draw_circle(ec + Vector2(0.0, 1.0) + pupil_off, 5.0, INK)
				draw_circle(ec + Vector2(2.0, -2.0) + pupil_off, 2.0, Color.WHITE)
			_ellipse(Vector2(100, 117) + o, Vector2(7, 6), INK)
			_ellipse(Vector2(100, 119) + o, Vector2(4, 3), Color(0.9, 0.45, 0.5))
		"angry":   # sobrancelhas \  / + olhos estreitos + boca emburrada
			draw_line(lc + Vector2(-eye_w - 1.0, -eye_h - 1.0), lc + Vector2(eye_w, -2.0), INK, 2.4, true)
			draw_line(rc + Vector2(eye_w + 1.0, -eye_h - 1.0), rc + Vector2(-eye_w, -2.0), INK, 2.4, true)
			_ellipse(lc, Vector2(eye_w, eye_h * 0.6), Color.WHITE)
			_ellipse(rc, Vector2(eye_w, eye_h * 0.6), Color.WHITE)
			draw_circle(lc + Vector2(0.0, 1.0), 4.0, INK)
			draw_circle(rc + Vector2(0.0, 1.0), 4.0, INK)
			var fm := _quad(Vector2(90, 116) + o, Vector2(100, 108) + o, Vector2(110, 116) + o, 14)
			draw_polyline(fm, INK, 2.6, true)
		"sad":   # sobrancelhas /  \ + olhos olhando p/ baixo + lágrima + boca triste
			draw_line(lc + Vector2(-eye_w - 1.0, -2.0), lc + Vector2(eye_w, -eye_h - 1.0), INK, 2.2, true)
			draw_line(rc + Vector2(eye_w + 1.0, -2.0), rc + Vector2(-eye_w, -eye_h - 1.0), INK, 2.2, true)
			_ellipse(lc, Vector2(eye_w, eye_h), Color.WHITE)
			_ellipse(rc, Vector2(eye_w, eye_h), Color.WHITE)
			draw_circle(lc + Vector2(0.0, eye_h * 0.4), 4.5, INK)
			draw_circle(rc + Vector2(0.0, eye_h * 0.4), 4.5, INK)
			_ellipse(lc + Vector2(-2.0, eye_h + 5.0), Vector2(2.5, 4.0), Color(0.45, 0.7, 0.98, 0.85))
			var sm := _quad(Vector2(91, 116) + o, Vector2(100, 109) + o, Vector2(109, 116) + o, 14)
			draw_polyline(sm, INK, 2.4, true)
		"disgust":   # um olho torto, boca ondulada e línguinha
			draw_line(lc + Vector2(-eye_w, -eye_h - 1.0), lc + Vector2(eye_w, -eye_h + 1.0), INK, 2.2, true)
			_ellipse(lc, Vector2(eye_w, 2.5), INK)
			_ellipse(rc, Vector2(eye_w, eye_h * 0.8), Color.WHITE)
			draw_circle(rc, 4.0, INK)
			var w := PackedVector2Array()
			for i in 7:
				var x := 90.0 + float(i) * 3.3
				var yy := 115.0 + (2.0 if i % 2 == 0 else -2.0)
				w.append(Vector2(x, yy) + o)
			draw_polyline(w, INK, 2.0, true)
			_ellipse(Vector2(104, 120) + o, Vector2(3, 3), Color(0.85, 0.4, 0.45))
		"indifferent":   # olhos entediados (traços) + boca reta
			_ellipse(lc, Vector2(eye_w, 2.5), INK)
			_ellipse(rc, Vector2(eye_w, 2.5), INK)
			draw_line(Vector2(92, 116) + o, Vector2(108, 116) + o, INK, 2.4, true)
		"sleepy":   # olhos fechados (∪) + boquinha
			draw_arc(lc, eye_w, 0.1, PI - 0.1, 12, INK, 2.2, true)
			draw_arc(rc, eye_w, 0.1, PI - 0.1, 12, INK, 2.2, true)
			draw_line(Vector2(96, 116) + o, Vector2(104, 116) + o, INK, 2.2, true)

func _draw_eyelashes(c: Vector2, ew: float, eh: float, dir: float) -> void:
	# 3 traços curtos no canto externo-superior do olho.
	var base := c + Vector2(dir * ew * 0.6, -eh * 0.6)
	for i in 3:
		var ang := -0.5 + float(i) * 0.45
		var tip := base + Vector2(dir * cos(ang), -sin(ang)) * 6.0
		draw_line(base, tip, INK, 1.4, true)

func _draw_antenna(base: Vector2, tip: Vector2, col: Color) -> void:
	draw_line(base, tip, col, 2.0, true)
	draw_circle(tip, 4.0, col)

# ------------------------------------------------------------------ acessórios
func _draw_accessories(o: Vector2, eye_dx: float, eye_y: float, eye_w: float) -> void:
	var a := current_acc

	# Cachecol (desenhado primeiro, no pescoço, por baixo do resto).
	if a.get("scarf", "none") == "present":
		var sc: Color = a.get("scarf_color", Color("2980b9"))
		_ellipse(Vector2(100, 150) + o, Vector2(36, 9), sc)
		draw_rect(Rect2(Vector2(108, 148) + o, Vector2(11, 24)), sc)
		draw_rect(Rect2(Vector2(110, 168) + o, Vector2(9, 8)), sc.darkened(0.15))

	# Chapéu.
	var hat_col: Color = a.get("hat_color", Color("c0392b"))
	match a.get("hat", "none"):
		"beanie":
			_dome(Vector2(100, 78) + o, Vector2(30, 26), hat_col)
			draw_rect(Rect2(Vector2(70, 74) + o, Vector2(60, 8)), hat_col.darkened(0.2))
			draw_circle(Vector2(100, 50) + o, 6.0, hat_col.lightened(0.3))
		"tophat":
			_ellipse(Vector2(100, 74) + o, Vector2(34, 7), hat_col)
			draw_rect(Rect2(Vector2(82, 40) + o, Vector2(36, 34)), hat_col)
			draw_rect(Rect2(Vector2(82, 60) + o, Vector2(36, 6)), hat_col.lightened(0.35))
		"crown":
			var pts := PackedVector2Array([
				Vector2(74, 76), Vector2(74, 58), Vector2(87, 68), Vector2(100, 52),
				Vector2(113, 68), Vector2(126, 58), Vector2(126, 76)])
			for i in pts.size():
				pts[i] += o
			draw_colored_polygon(pts, hat_col)
			draw_circle(Vector2(100, 52) + o, 2.5, hat_col.lightened(0.5))
		"cap":
			_dome(Vector2(100, 80) + o, Vector2(28, 22), hat_col)
			_ellipse(Vector2(82, 82) + o, Vector2(26, 6), hat_col.darkened(0.1))

	# Óculos (alinhados aos olhos).
	var gl_col: Color = a.get("glasses_color", Color("2c3e50"))
	var lc := Vector2(100.0 - eye_dx, eye_y) + o
	var rc := Vector2(100.0 + eye_dx, eye_y) + o
	var gr := eye_w + 3.0
	match a.get("glasses", "none"):
		"round":
			draw_arc(lc, gr, 0.0, TAU, 24, gl_col, 2.0, true)
			draw_arc(rc, gr, 0.0, TAU, 24, gl_col, 2.0, true)
			draw_line(lc + Vector2(gr, 0), rc - Vector2(gr, 0), gl_col, 2.0, true)
		"square":
			var sz := Vector2(gr * 2.0, gr * 2.0)
			draw_rect(Rect2(lc - Vector2(gr, gr), sz), gl_col, false, 2.0)
			draw_rect(Rect2(rc - Vector2(gr, gr), sz), gl_col, false, 2.0)
			draw_line(lc + Vector2(gr, 0), rc - Vector2(gr, 0), gl_col, 2.0, true)
		"star":
			_star(lc, gr + 1.0, (gr + 1.0) * 0.45, 5, gl_col)
			_star(rc, gr + 1.0, (gr + 1.0) * 0.45, 5, gl_col)

	# Laço (na cabeça ou no pescoço).
	var bow_col: Color = a.get("bow_color", Color("e84393"))
	match a.get("bow", "none"):
		"head":
			_draw_bow(Vector2(122, 72) + o, bow_col)
		"neck":
			_draw_bow(Vector2(100, 150) + o, bow_col)

func _draw_bow(center: Vector2, col: Color) -> void:
	var s := 9.0
	_triangle(center, center + Vector2(-s, -s * 0.7), center + Vector2(-s, s * 0.7), col)
	_triangle(center, center + Vector2(s, -s * 0.7), center + Vector2(s, s * 0.7), col)
	draw_circle(center, 3.0, col.darkened(0.2))

# ------------------------------------------------------------------ primitivas
func _ellipse(c: Vector2, r: Vector2, col: Color, segs := 40) -> void:
	var pts := PackedVector2Array()
	for i in segs:
		var a := TAU * i / segs
		pts.append(c + Vector2(cos(a) * r.x, sin(a) * r.y))
	draw_colored_polygon(pts, col)

## Meia-elipse superior (cúpula), com base plana — usada em chapéus.
func _dome(c: Vector2, r: Vector2, col: Color, segs := 24) -> void:
	var pts := PackedVector2Array()
	for i in segs + 1:
		var a := PI + PI * float(i) / float(segs)   # PI..TAU = metade de cima (y < c.y)
		pts.append(c + Vector2(cos(a) * r.x, sin(a) * r.y))
	draw_colored_polygon(pts, col)

func _triangle(a: Vector2, b: Vector2, c: Vector2, col: Color) -> void:
	draw_colored_polygon(PackedVector2Array([a, b, c]), col)

func _star(center: Vector2, outer: float, inner: float, points: int, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in points * 2:
		var rad := outer if i % 2 == 0 else inner
		var a := -PI / 2.0 + PI * float(i) / float(points)
		pts.append(center + Vector2(cos(a) * rad, sin(a) * rad))
	draw_colored_polygon(pts, col)

func _quad(p0: Vector2, p1: Vector2, p2: Vector2, n: int) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n + 1:
		var t := float(i) / n
		var u := 1.0 - t
		pts.append(u * u * p0 + 2.0 * u * t * p1 + t * t * p2)
	return pts

# ------------------------------------------------------------------ entrada
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				moved = false
				drag_offset = DisplayServer.mouse_get_position() - get_window().position
			else:
				dragging = false
				if not moved:
					_react()   # clique sem arrastar = carinho rápido
				else:
					_save_settings()   # guarda a nova posição
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_rebuild_automations_menu()   # capta scripts adicionados sem reiniciar
			menu.position = DisplayServer.mouse_get_position()
			menu.reset_size()
			menu.popup()

	elif event is InputEventMouseMotion and dragging:
		if event.relative.length() > 1.0:
			moved = true
		# Mantém a janela inteira dentro da tela ao arrastar.
		var scr := DisplayServer.screen_get_usable_rect()
		var pos := DisplayServer.mouse_get_position() - drag_offset
		pos.x = clampi(pos.x, scr.position.x, scr.position.x + scr.size.x - win_w)
		pos.y = clampi(pos.y, scr.position.y, scr.position.y + scr.size.y - win_h)
		get_window().position = pos
		anchor = pos + Vector2i(int(win_w / 2.0), win_h)

# ------------------------------------------------------------------ ações
## Libera uma interação respeitando dois limites: no máximo uma por segundo e a
## mesma ação no máximo 3 vezes seguidas (uma ação diferente zera a contagem).
## Se o usuário insistir na MESMA ação em menos de 1s, o pet reclama (mau humor).
func _can_act(action: String) -> bool:
	var same := action == last_action
	if action_cd > 0.0:
		if same:
			_complain()           # insistindo na mesma ação em menos de 1s
		return false
	if same and action_repeats >= MAX_REPEAT:
		return false              # já repetiu 3x (sem spam) — ignora em silêncio
	if same:
		action_repeats += 1
	else:
		last_action = action
		action_repeats = 1
	action_cd = ACTION_COOLDOWN
	return true

## Pet demonstra repulsa/raiva/tristeza/indiferença e perde um pouco de humor.
## Limitado por complain_cd para não spammar fala a cada clique.
func _complain() -> void:
	if complain_cd > 0.0:
		return
	complain_cd = COMPLAIN_COOLDOWN
	happy = clampf(happy - 6.0, 0.0, 100.0)
	say(MOOD_NEG.pick_random())

func feed() -> void:
	if not _can_act("feed"):
		return
	hunger = clampf(hunger - 25.0, 0.0, 100.0)
	happy = clampf(happy + 8.0, 0.0, 100.0)
	say(["nhac nhac! 😋", "obrigado!", "que delícia 🦴"].pick_random())
	hop()

func pet() -> void:
	if not _can_act("pet"):
		return
	happy = clampf(happy + 15.0, 0.0, 100.0)
	say(["ronron... 🥰", "adoro carinho!", "mais! mais!"].pick_random())
	hop(220.0)

func play() -> void:
	if not _can_act("play"):
		return
	happy = clampf(happy + 12.0, 0.0, 100.0)
	hunger = clampf(hunger + 10.0, 0.0, 100.0)
	say(["yupiii! 🎾", "de novo!", "tô voando! 🚀"].pick_random())
	hop(420.0)

func _react() -> void:
	if not _can_act("react"):
		return
	happy = clampf(happy + 5.0, 0.0, 100.0)
	say("oi! 👋")
	hop()

func hop(force := 320.0) -> void:
	vy = -force

func say(t: String) -> void:
	speech.text = t
	expression = _expression_from_text(t)
	speech_clear = 2.5
	_relayout()

## Deduz a emoção do rosto a partir dos emojis da fala (prioridade pela ordem).
func _expression_from_text(t: String) -> String:
	var map := {
		"happy": ["🥰", "😋", "😍", "🤩", "🧡", "✨"],
		"excited": ["🚀", "🎾", "🎉", "🎲", "⭐"],
		"angry": ["😠", "😤", "😡", "💢"],
		"sad": ["😢", "😞", "😭", "🥺"],
		"disgust": ["🤢", "🤮", "😖"],
		"indifferent": ["😑", "🙄", "😒", "🫤"],
		"sleepy": ["😴", "💤", "🥱"],
	}
	for expr in map:
		for e in map[expr]:
			if t.contains(e):
				return expr
	return "neutral"
