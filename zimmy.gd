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
const MAX_W := 300          # largura máxima do balão; acima disso a fala quebra em linhas

# --- pets / acessórios ---
const PETS_FILE := "user://pets.json"
const ACC_FILE := "user://accessories.json"
const SETTINGS_FILE := "user://settings.json"   # guarda a última posição na tela
const SCHEDULES_FILE := "user://schedules.json" # quais automações agendadas estão ligadas
const NOTES_FILE := "user://notes.json"         # bloquinho de notas de texto (lista de strings)
const REMINDERS_FILE := "user://reminders.json" # lembretes recorrentes criados pelo usuário
const AUTOMACOES_DIR := "res://Automacoes/"   # scripts de automação (drop-in) — ver Automacoes/LEIAME.md
const RANDOM_PERIOD := 30.0  # segundos entre gerações aleatórias de pets/acessórios (quando ligado)
const PET_COLOR_KEYS := ["body_color", "belly_color", "ear_color", "cheek_color",
	"antenna_color", "nose_color", "horn_color"]
const ACC_COLOR_KEYS := ["hat_color", "glasses_color", "bow_color", "scarf_color",
	"necklace_color", "earring_color", "collar_color", "headphone_color",
	"monocle_color", "mustache_color", "flower_color", "badge_color", "tie_color",
	"sash_color", "mask_color", "sticker_color", "belt_color", "backpack_color"]

var current: Dictionary = {}        # config do pet exibido agora
var current_acc: Dictionary = {}    # config do acessório exibido agora
var saved_pets: Dictionary = {}     # nome -> config (em memória, com Color)
var saved_accessories: Dictionary = {}  # nome -> config de acessório
var pet_menu_ids: Dictionary = {}   # id do item no dropdown -> nome do pet
var acc_menu_ids: Dictionary = {}   # id do item no dropdown -> nome do acessório
var pet_del_ids: Dictionary = {}    # id do item no submenu "Excluir pet" -> nome do pet
var acc_del_ids: Dictionary = {}    # id do item no submenu "Excluir acessório" -> nome do acessório
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
var automation_flags: Dictionary = {}    # caminho -> código de bandeira (const ICON_FLAG: "us"/"eu"/...)
var automation_badges: Dictionary = {}   # chave de badge -> texto exibido (ex.: "3", "!")
var automation_item_menu: Dictionary = {} # id do item -> PopupMenu onde ele está (menu de automações ou de e-mail)
var _icon_cache: Dictionary = {}         # hex -> ImageTexture (ícones de provedor)
# --- credenciais (diálogo + estado) ---
const CRED_PREFIX := "user://cred_"      # arquivo por automação: user://cred_<key>.json (gitignored)
const CRED_SALT := "zimmy-cred-v1"       # salt p/ derivar a chave de criptografia das credenciais
var cred_dialog: ConfirmationDialog
var cred_user_edit: LineEdit
var cred_pass_edit: LineEdit
var cred_l1: Label   # rótulo "E-mail:" (retraduzido ao abrir o diálogo)
var cred_l2: Label   # rótulo "App Password..." (idem)
var cred_help: Label      # passo-a-passo (ex.: como obter a App Password do Gmail)
var cred_link: LinkButton # link p/ abrir a página da App Password no navegador
var cred_help_url := ""   # URL que o cred_link abre (vazio = sem link)
var cred_pending_key := ""               # chave da credencial sendo solicitada agora
var cred_pending_cb := Callable()        # callback a chamar com {user, pass} ao confirmar
var cred_prompt_suppressed: Dictionary = {} # chaves cujo prompt o usuário cancelou (não insistir)
var random_pet_on := false
var random_acc_on := false
var random_timer := 0.0     # temporizador único compartilhado por pets e acessórios
var show_accessories := true
var show_status := false    # exibir as barrinhas de necessidade (padrão: desligado; persistido)

# --- estado ---
var happy := 70.0
var hunger := 40.0

# --- necessidades (barras Alimentar/Carinho/Brincar): 0..100, começam cheias a cada
# abertura (não são persistidas). Caem 1 ponto a cada STAT_DECAY_PERIOD sem a ação. ---
const STAT_MAX := 100.0
const STAT_DECAY_PERIOD := 1800.0          # 30 min em segundos: -1 ponto por ciclo
const STAT_LOW := 20.0                     # ao cruzar p/ baixo deste valor dispara o alerta sonoro de necessidade
const COL_FEED := Color("ffffff")          # branco (Alimentar)
const COL_PET := Color("f1c40f")           # amarelo (Carinho)
const COL_PLAY := Color("e84365")          # rosa avermelhado (Brincar)
const STATUS_FOOTER := 58.0                # altura (px) reservada abaixo do pet p/ as barras (quando Status ON)
var stat_feed := STAT_MAX
var stat_pet := STAT_MAX
var stat_play := STAT_MAX
var stat_decay_timer := 0.0

# --- limite de interação: 1 ação/clique por segundo e a mesma ação no máx. 3x seguidas ---
const ACTION_COOLDOWN := 1.0
const MAX_REPEAT := 3
const COMPLAIN_COOLDOWN := 1.5    # respiro entre reclamações (evita spam de fala)
const REPEAT_RESET := 30.0        # após Ns sem repetir, a trava de 3x libera e reconta
# --- sacudida do mouse: chacoalhar rápido perto do pet dispara tontura/enjoo/susto ---
const SHAKE_MIN_SPEED := 22    # px/frame mínimos p/ contar como movimento rápido
const SHAKE_REVERSALS := 6     # reversões de direção p/ disparar a reação
const SHAKE_WINDOW := 0.6      # janela (s) p/ acumular as reversões (senão zera)
const SHAKE_COOLDOWN := 3.0    # respiro entre reações de sacudida
const SHAKE_RADIUS := 200.0    # só conta se o cursor estiver perto do centro do pet
const HOVER_EXPRS := ["happy", "excited"]  # reações ao passar o mouse por cima
# Frases de mau humor quando insistem na mesma ação: repulsa / raiva / tristeza /
# indiferença / descaso.
var action_cd := 0.0
var last_action := ""
var action_repeats := 0
var complain_cd := 0.0
var repeat_reset_cd := 0.0        # conta p/ liberar a trava de repetições (REPEAT_RESET)

# --- falas: duas pistas (ver say()/notify() e o pump em _process) ---
# REAÇÕES (say): feedback direto do usuário — aparecem NA HORA, substituindo o balão,
#   e duram REACTION_HOLD. NOTIFICAÇÕES (notify): automações/e-mails/lembretes — entram
#   numa FILA e cada uma fica visível MSG_DURATION (10s), sem se sobrepor nem se perder.
#   Enquanto uma reação está no ar, a notificação PAUSA (não gasta seus 10s visíveis).
const MSG_DURATION := 10.0     # duração de cada notificação da fila
const REACTION_HOLD := 2.5     # duração de uma reação imediata
const URGENT_WINDOW := 6.0     # após uma AÇÃO do usuário, notificações resultantes furam a fila
const MAX_QUEUE_WAIT := 60.0   # notificação que espera mais que isso na fila é descartada
var msg_queue: Array = []      # fila de notificações: itens {text, wait} (wait = seg. esperando)
var notify_text := ""          # notificação exibida agora (mantida enquanto visível)
var notify_hold := 0.0         # tempo restante da notificação atual (pausa sob reação)
var react_text := ""           # reação imediata exibida agora
var react_hold := 0.0          # tempo restante da reação atual
var urgent_cd := 0.0           # janela pós-ação do usuário: notify() fura a fila (imediato + à frente)

# --- alertas sonoros (WhatsApp / Gmail) ---
var whatsapp_sound_on := true      # toca um "telefone" quando chega conversa nova
var gmail_sound_on := true         # toca um "correio" quando chega e-mail novo
var _ring_player: AudioStreamPlayer    # som de telefone tocando (WhatsApp)
var _chime_player: AudioStreamPlayer   # som de entrega de correio (Gmail)

# --- alertas sonoros das ações (Alimentar / Carinho / Brincar) ---
# Cada toggle governa DOIS gatilhos: o som tocado ao executar a ação e o alerta
# quando a necessidade correspondente cruza STAT_LOW para baixo. Persistidos.
var sound_feed_on := true
var sound_pet_on := true
var sound_play_on := true
var _feed_player: AudioStreamPlayer    # "nhac nhac" ao alimentar / lembrete de fome
var _pet_player: AudioStreamPlayer     # ronronado ao fazer carinho / lembrete de carência
var _play_player: AudioStreamPlayer    # "boing" alegre ao brincar / lembrete de tédio
# Cada ação tem VÁRIAS variações do som (sintetizadas), sorteadas dentro do mesmo grupo
# a cada disparo p/ o áudio não ficar repetitivo (ver _play_group / _build_*_sounds).
var _feed_variants: Array = []         # variações do som de alimentar (mordidas)
var _pet_variants: Array = []          # variações do ronron (carinho)
var _play_variants: Array = []         # variações do arpejo (brincar)

# --- animação ---
var bob := 0.0          # respiração (seno)
var y_off := 0.0        # deslocamento do pulinho
var vy := 0.0           # velocidade vertical do pulo
var blink_t := 0.0      # tempo restante de piscada
var blink_timer := 2.5  # contagem até a próxima piscada
var pupil_off := Vector2.ZERO
# --- olhos fechados no clique: cada olho fecha ao ser clicado e reabre quando o
# cursor sai de cima dele (ver _input / _process / _draw). ---
var eye_closed_l := false
var eye_closed_r := false
# --- reação por hover / sacudida: expressão temporária que sobrepõe o rosto neutro ---
var react_expr := ""       # "dizzy"/"nausea"/"scared"/"happy"/"excited" ou "" (nenhuma)
var react_expr_t := 0.0    # tempo restante da expressão de reação
var hovering := false      # cursor está sobre o pet agora (p/ reagir só ao ENTRAR)
# --- detecção de sacudida do mouse (chacoalhar rápido perto do pet) ---
var _last_mouse := Vector2i.ZERO
var _shake_dir := 0        # sinal da última direção X com velocidade
var _shake_count := 0      # reversões de direção acumuladas na janela atual
var _shake_window := 0.0   # tempo restante da janela de acumulação
var shake_cd := 0.0        # respiro após disparar (não repetir em seguida)
# --- fogos de artifício (comemoração de hora cheia): partículas coloridas na faixa
# acima do pet (headroom). Enquanto fw_time > 0 novos estouros são lançados. ---
var fw_particles: Array = []   # cada: {p:Vector2, v:Vector2, life:float, max:float, col:Color}
var fw_time := 0.0             # tempo restante lançando estouros
var fw_spawn_cd := 0.0         # intervalo até o próximo estouro
# Animação de reação ("número" sorteado por ação de menu): rotação/escala/balanço
# aplicados no _draw em torno de um pivô; os pulos continuam pela física (vy/y_off).
var anim := ""          # nome da animação em curso ("" = nenhuma)
var anim_t := 0.0       # tempo decorrido na animação atual
var anim_dur := 0.0     # duração total da animação atual
var hop_queue := 0      # pulinhos extras a disparar quando aterrissar (multi-hop)
var hop_queue_force := 320.0

# Para cada ação de menu distinta, um conjunto de animações sorteáveis (pick_random):
# a reação varia a cada vez, mas combina com a "energia" da ação.
const ACTION_ANIMS := {
	"feed":   ["hop", "nod", "wiggle", "squish"],          # comer: alegria contida
	"pet":    ["nod", "wiggle", "tilt", "squish"],          # carinho: derrete/balança
	"play":   ["double_hop", "triple_hop", "spin_jump", "backflip", "dance"],  # brincar: energia alta
	"react":  ["hop", "wiggle", "spin", "tilt"],            # clique avulso
	"newpet": ["spin", "spin_jump", "dance"],              # pet novo gerado: "ta-dá"
	"newacc": ["spin", "wiggle", "nod"],                   # acessório novo
	"choose": ["hop", "spin", "tilt"],                     # escolher pet/acessório salvo
	"save":   ["nod", "hop"],                              # salvar/renomear
	"happy":  ["hop", "spin", "dance"],                    # comemoração genérica
	"sad":    ["squish", "tilt"],                          # exclusão / mau resultado
}

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
var expression := "neutral"   # emoção refletida no rosto (vinda do emoji falado)

# --- UI ---
var menu: PopupMenu
var pets_menu: PopupMenu
var acc_menu: PopupMenu
var automations_menu: PopupMenu
var timers_menu: PopupMenu          # submenu ⏱️ Temporizadores: só automações agendadas
var moedas_menu: PopupMenu
var email_menu: PopupMenu
var whatsapp_menu: PopupMenu       # submenu 💬 WhatsApp (drop-in com MENU_GROUP = "whatsapp")
var pets_del_menu: PopupMenu
var acc_del_menu: PopupMenu
var lang_menu: PopupMenu
var donate_menu: PopupMenu         # submenu ❤️ Doação / Donate (GitHub Sponsors, Ko-fi)
var sounds_menu: PopupMenu         # submenu 🔊 Alertas de som: 1 toggle por ação (Alimentar/Carinho/Brincar)
var notes_menu: PopupMenu          # submenu 📝 Notas
var notes_del_menu: PopupMenu      # subsubmenu 🗑️ Excluir nota
var _cascade_left := false         # true = abrir os submenus para a ESQUERDA (pet à direita, sem espaço à direita)
var _submenu_parent: Dictionary = {}  # submenu PopupMenu -> seu PopupMenu pai (p/ reposicionar à esquerda)
var notes_dialog: ConfirmationDialog
var note_edit: TextEdit            # campo multilinha do diálogo de nova nota
var notes: Array = []              # lista de notas (strings), persistida em notes.json
var note_ids: Dictionary = {}      # id do item no submenu Notas -> índice em `notes`
var note_del_ids: Dictionary = {}  # id do item em Excluir nota -> índice em `notes`
# --- lembretes recorrentes do usuário (⏰ Lembretes) ---
var reminders_menu: PopupMenu          # submenu ⏰ Lembretes
var reminders_del_menu: PopupMenu      # subsubmenu 🗑️ Excluir lembrete
var reminders_dialog: ConfirmationDialog
var reminder_text_edit: LineEdit       # mensagem do lembrete
var reminder_freq_opt: OptionButton    # frequência (presets)
var reminder_time_row: HBoxContainer   # linha da hora (só visível em "diariamente")
var reminder_time_edit: LineEdit       # hora HH:MM p/ o preset diário
var reminder_msg_label: Label          # rótulos re-traduzíveis do diálogo
var reminder_freq_label: Label
var reminder_time_label: Label
var reminders: Array = []          # [{text, sched, on}] — persistido em reminders.json
var reminder_defs: Array = []      # paralelo a `reminders`: def de agendamento já parseada
var reminder_rt: Dictionary = {}   # índice do lembrete ligado -> {accum, last_day, last_hour}
var reminder_ids: Dictionary = {}  # id do item no submenu -> índice em `reminders`
var reminder_del_ids: Dictionary = {}  # id do item em Excluir -> índice em `reminders`
var save_dialog: ConfirmationDialog
var name_edit: LineEdit
var save_mode := "pet"      # "pet" ou "acc" — o que o diálogo de salvar grava
var save_action := "save"   # "save" (novo) ou "rename" (renomear um item já salvo)
var suggested_pet_name := ""    # nome sugerido p/ o pet gerado (pré-preenche o diálogo)
var suggested_acc_name := ""    # nome sugerido p/ o acessório gerado
var delete_dialog: ConfirmationDialog
var delete_mode := "pet"    # "pet" ou "acc" — o que o diálogo de exclusão remove
var delete_name := ""       # nome do item pendente de exclusão

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
const MI_DEL_PET := 13
const MI_DEL_ACC := 14
const MI_LANG := 15
const MI_STATUS := 16
const MI_MOEDAS := 17   # submenu 💱 Moedas, no menu principal (logo abaixo de ⚙️ Automações)
const MI_NOTES := 18    # submenu 📝 Notas (acima de 📧 E-mails)
# ids internos do submenu 📝 Notas (espaço próprio; as notas em si usam 100+)
const NOTE_NEW := 1      # ➕ Nova nota...
const NOTE_PASTE := 2    # 📋 Colar da área de transferência
const MI_NOTES_DEL := 3  # 🗑️ Excluir nota ▸ (subsubmenu)
const MI_WHATSAPP := 19  # submenu 💬 WhatsApp (contador de conversas não lidas)
const MI_DONATE := 20    # submenu ❤️ Doação / Donate (acima de Sair)
const MI_TIMERS := 21    # submenu ⏱️ Temporizadores: automações agendadas (logo abaixo de ⚙️ Automações)
const MI_SOUNDS := 22    # submenu 🔊 Alertas de som (logo abaixo de 🎾 Brincar)
const MI_REMINDERS := 23 # submenu ⏰ Lembretes (recorrentes do usuário; logo abaixo de ⏱️ Temporizadores)
# ids internos do submenu ⏰ Lembretes (espaço próprio; os lembretes usam 100+)
const REM_NEW := 1       # ➕ Novo lembrete...
const REM_DEL := 3       # 🗑️ Excluir lembrete ▸ (subsubmenu)
# IDs dos toggles "🔔 Alerta de som" dentro dos submenus 💬 WhatsApp e 📧 E-mails.
# Ficam abaixo de 100 (onde começam os IDs das automações) para não colidirem.
const SND_WHATSAPP := 50
const SND_GMAIL := 51
# IDs dos toggles dentro do submenu 🔊 Alertas de som (menu próprio; 1/2/3 não colidem).
const SND_FEED := 1
const SND_PET := 2
const SND_PLAY := 3
# ids internos do submenu ❤️ Doação (abrem links no navegador)
const DONATE_SPONSORS := 1   # GitHub Sponsors
const DONATE_KOFI := 2       # Ko-fi
const DONATE_SPONSORS_URL := "https://github.com/sponsors/zimerfeld"
const DONATE_KOFI_URL := "https://ko-fi.com/C0D621FCGD"
const LANG_PT := 1   # ids dos itens do submenu de idioma
const LANG_EN := 2

# --- idioma (i18n) ---
var lang := "pt"   # "pt" (Português BR) ou "en" (English US); persistido em settings.json

# Tabela de textos do sistema (menu, diálogos, falas). Cada chave traz pt/en.
const STRINGS := {
	# menu de contexto
	"mi_feed":       {"pt": "🦴 Alimentar",          "en": "🦴 Feed"},
	"mi_pet":        {"pt": "🤚 Carinho",            "en": "🤚 Pet"},
	"mi_play":       {"pt": "🎾 Brincar",            "en": "🎾 Play"},
	"mi_random":     {"pt": "🐶 Gerar pets",         "en": "🐶 Random pets"},
	"mi_random_acc": {"pt": "🎲 Gerar acessórios",   "en": "🎲 Random accessories"},
	"mi_show_acc":   {"pt": "👓 Mostrar acessórios", "en": "👓 Show accessories"},
	"mi_status":     {"pt": "📊 Status",             "en": "📊 Status"},
	"mi_save_pet":   {"pt": "💾 Salvar Pet...",      "en": "💾 Save Pet..."},
	"mi_rename_pet": {"pt": "💾 Renomear Pet...",    "en": "💾 Rename Pet..."},
	"mi_choose_pet": {"pt": "📂 Escolher pet",       "en": "📂 Choose pet"},
	"mi_del_pet":    {"pt": "🗑️ Excluir pet",        "en": "🗑️ Delete pet"},
	"mi_save_acc":   {"pt": "🎀 Salvar Acessório...","en": "🎀 Save Accessory..."},
	"mi_rename_acc": {"pt": "🎀 Renomear Acessório...","en": "🎀 Rename Accessory..."},
	"mi_choose_acc": {"pt": "🧳 Escolher acessório", "en": "🧳 Choose accessory"},
	"mi_del_acc":    {"pt": "🗑️ Excluir acessório",  "en": "🗑️ Delete accessory"},
	"mi_automations":{"pt": "⚙️ Automações",         "en": "⚙️ Automations"},
	"mi_timers":     {"pt": "⏱️ Temporizadores",     "en": "⏱️ Timers"},
	"mi_moedas":     {"pt": "💱 Moedas",             "en": "💱 Currencies"},
	"mi_notes":      {"pt": "📝 Notas",              "en": "📝 Notes"},
	"mi_emails":     {"pt": "📧 E-mails",            "en": "📧 E-mails"},
	"mi_whatsapp":   {"pt": "💬 WhatsApp",           "en": "💬 WhatsApp"},
	"mi_sound_alert":{"pt": "🔊 Alerta de som",      "en": "🔊 Sound alert"},
	"mi_sounds":     {"pt": "🔊 Alertas de som",     "en": "🔊 Sound alerts"},
	"mi_donate":     {"pt": "❤️ Doação",             "en": "❤️ Donate"},
	"mi_language":   {"pt": "🌐 Idioma",             "en": "🌐 Language"},
	"mi_quit":       {"pt": "Sair",                  "en": "Quit"},
	# submenus / sentinelas (rótulo exibido; o valor lógico continua "Default"/"Nenhum")
	"select":        {"pt": "Selecione...",          "en": "Select..."},
	"default_pet":   {"pt": "Padrão",                "en": "Default"},
	"none_acc":      {"pt": "Nenhum",                "en": "None"},
	"no_saved_pets": {"pt": "(nenhum pet salvo)",    "en": "(no saved pets)"},
	"no_saved_acc":  {"pt": "(nenhum acessório salvo)","en": "(no saved accessories)"},
	# diálogos salvar / renomear
	"save_pet_title":   {"pt": "Salvar Pet",         "en": "Save Pet"},
	"save_acc_title":   {"pt": "Salvar Acessório",   "en": "Save Accessory"},
	"rename_pet_title": {"pt": "Renomear Pet",       "en": "Rename Pet"},
	"rename_acc_title": {"pt": "Renomear Acessório", "en": "Rename Accessory"},
	"name_pet_label":   {"pt": "Nome do pet:",       "en": "Pet name:"},
	"name_acc_label":   {"pt": "Nome do acessório:", "en": "Accessory name:"},
	"newname_pet_label":{"pt": "Novo nome do pet:",  "en": "New pet name:"},
	"newname_acc_label":{"pt": "Novo nome do acessório:","en": "New accessory name:"},
	"ph_pet":           {"pt": "ex: Fofinho",        "en": "e.g. Fluffy"},
	"ph_acc":           {"pt": "ex: Chapéu de Festa","en": "e.g. Party Hat"},
	"btn_save":         {"pt": "Salvar",             "en": "Save"},
	"btn_rename":       {"pt": "Renomear",           "en": "Rename"},
	# diálogo excluir
	"delete_title":   {"pt": "Excluir",              "en": "Delete"},
	"btn_delete":     {"pt": "Excluir",              "en": "Delete"},
	"btn_cancel":     {"pt": "Cancelar",             "en": "Cancel"},
	"delete_confirm": {"pt": "Excluir o %s \"%s\" permanentemente?",
		"en": "Permanently delete the %s \"%s\"?"},
	"kind_pet":       {"pt": "pet",                  "en": "pet"},
	"kind_acc":       {"pt": "acessório",            "en": "accessory"},
	# diálogo de credenciais
	"cred_ok":        {"pt": "Entrar",               "en": "Sign in"},
	"cred_email_label":{"pt": "E-mail:",             "en": "E-mail:"},
	"cred_pass_label":{"pt": "App Password (senha de app):", "en": "App Password:"},
	"cred_user_ph":   {"pt": "voce@gmail.com",       "en": "you@gmail.com"},
	"cred_pass_ph":   {"pt": "senha de aplicativo (não a senha normal)",
		"en": "app password (not your normal password)"},
	"cred_open_page": {"pt": "↗ Abrir a página da Senha de app",
		"en": "↗ Open the App Password page"},
	# falas (say)
	"hello":          {"pt": "olá! eu sou o %s 🧡","en": "hi! I'm %s 🧡"},
	"say_default":    {"pt": "Padrão 🐾",            "en": "Default 🐾"},
	"say_no_acc":     {"pt": "sem acessório 🚫",     "en": "no accessory 🚫"},
	"pet_deleted":    {"pt": "pet excluído: %s 🗑️",  "en": "pet deleted: %s 🗑️"},
	"acc_deleted":    {"pt": "acessório excluído: %s 🗑️","en": "accessory deleted: %s 🗑️"},
	"welcome_pet":    {"pt": "bem-vindo, %s! 🎉",    "en": "welcome, %s! 🎉"},
	"congrats_acc":   {"pt": "parabéns pelo novo visual, %s! 🎉",
		"en": "congrats on the new look, %s! 🎉"},
	"name_invalid":   {"pt": "nome inválido 🙈",     "en": "invalid name 🙈"},
	"pet_saved":      {"pt": "pet salvo: %s 💾",     "en": "pet saved: %s 💾"},
	"acc_saved":      {"pt": "acessório salvo: %s 🎀","en": "accessory saved: %s 🎀"},
	"name_kept":      {"pt": "nome mantido 🙂",      "en": "name unchanged 🙂"},
	"pet_exists":     {"pt": "já existe um pet com esse nome 🙈",
		"en": "a pet with that name already exists 🙈"},
	"acc_exists":     {"pt": "já existe um acessório com esse nome 🙈",
		"en": "an accessory with that name already exists 🙈"},
	"pet_renamed":    {"pt": "pet renomeado: %s ✏️", "en": "pet renamed: %s ✏️"},
	"acc_renamed":    {"pt": "acessório renomeado: %s ✏️","en": "accessory renamed: %s ✏️"},
	"automation_invalid":{"pt": "automação inválida 🚫","en": "invalid automation 🚫"},
	"automation_norun":{"pt": "automação sem run() 🤔","en": "automation has no run() 🤔"},
	# notas (📝 Notas)
	"note_new":       {"pt": "➕ Nova nota...",       "en": "➕ New note..."},
	"note_paste":     {"pt": "📋 Colar da área de transferência","en": "📋 Paste from clipboard"},
	"note_delete":    {"pt": "🗑️ Excluir nota",       "en": "🗑️ Delete note"},
	"note_empty":     {"pt": "(nenhuma nota)",       "en": "(no notes)"},
	"note_new_title": {"pt": "Nova nota",            "en": "New note"},
	"note_ph":        {"pt": "Digite ou cole o texto da nota...","en": "Type or paste the note text..."},
	"note_saved":     {"pt": "nota salva 📝",         "en": "note saved 📝"},
	"note_pasted":    {"pt": "nota colada da área de transferência 📋","en": "note pasted from clipboard 📋"},
	"note_copied":    {"pt": "nota copiada! 📋",      "en": "note copied! 📋"},
	"note_deleted":   {"pt": "nota excluída 🗑️",      "en": "note deleted 🗑️"},
	"note_clip_empty":{"pt": "área de transferência vazia 🤔","en": "clipboard is empty 🤔"},
	"note_empty_input":{"pt": "nota vazia 🤔",        "en": "empty note 🤔"},
	# lembretes (⏰ Lembretes)
	"mi_reminders":   {"pt": "⏰ Lembretes",          "en": "⏰ Reminders"},
	"rem_new":        {"pt": "➕ Novo lembrete...",   "en": "➕ New reminder..."},
	"rem_delete":     {"pt": "🗑️ Excluir lembrete",   "en": "🗑️ Delete reminder"},
	"rem_empty":      {"pt": "(nenhum lembrete)",     "en": "(no reminders)"},
	"rem_new_title":  {"pt": "Novo lembrete",         "en": "New reminder"},
	"rem_msg_label":  {"pt": "Mensagem:",             "en": "Message:"},
	"rem_freq_label": {"pt": "Frequência:",           "en": "Frequency:"},
	"rem_time_label": {"pt": "Hora (HH:MM):",         "en": "Time (HH:MM):"},
	"rem_ph":         {"pt": "ex: Beber água 💧",     "en": "e.g. Drink water 💧"},
	"rem_freq_15m":   {"pt": "A cada 15 minutos",     "en": "Every 15 minutes"},
	"rem_freq_30m":   {"pt": "A cada 30 minutos",     "en": "Every 30 minutes"},
	"rem_freq_1h":    {"pt": "A cada 1 hora",         "en": "Every 1 hour"},
	"rem_freq_hourly":{"pt": "De hora em hora (:00)", "en": "On the hour (:00)"},
	"rem_freq_daily": {"pt": "Diariamente às...",     "en": "Daily at..."},
	"rem_saved":      {"pt": "lembrete criado ⏰",     "en": "reminder created ⏰"},
	"rem_deleted":    {"pt": "lembrete excluído 🗑️",   "en": "reminder deleted 🗑️"},
	"rem_on":         {"pt": "⏰ lembrete ligado: %s", "en": "⏰ reminder on: %s"},
	"rem_off":        {"pt": "⏸️ lembrete desligado: %s","en": "⏸️ reminder off: %s"},
	"rem_empty_input":{"pt": "mensagem vazia 🤔",     "en": "empty message 🤔"},
	"rem_bad_time":   {"pt": "hora inválida (use HH:MM) 🙈","en": "invalid time (use HH:MM) 🙈"},
	"login_incomplete":{"pt": "login incompleto 🙈", "en": "incomplete login 🙈"},
	"hi_react":       {"pt": "oi! 👋",               "en": "hi! 👋"},
	"sched_on":       {"pt": "⏱️ %s ligada (%s)",    "en": "⏱️ %s on (%s)"},
	"sched_off":      {"pt": "⏸️ %s desligada",      "en": "⏸️ %s off"},
	# automações: rótulos de frequência / badges
	"automation":     {"pt": "automação",            "en": "automation"},
	"unread":         {"pt": "não lidos",            "en": "unread"},
	"freq_hourly":    {"pt": "toda hora cheia",      "en": "every hour"},
	"freq_daily":     {"pt": "todo dia %02d:%02d",   "en": "daily at %02d:%02d"},
	"freq_every":     {"pt": "a cada %s",            "en": "every %s"},
}

# Listas de falas (sorteadas) por idioma.
const STRING_LISTS := {
	"mood_neg": {
		"pt": ["eca, de novo não 🤢", "para com isso! 😠", "grrr... 😤",
			"de novo?... 😢", "tô cansado disso 😞", "tanto faz 😑",
			"que seja... 🙄", "...zzz 😴"],
		"en": ["ugh, not again 🤢", "stop it! 😠", "grrr... 😤",
			"again?... 😢", "I'm tired of this 😞", "whatever 😑",
			"sure... 🙄", "...zzz 😴"],
	},
	"feed": {
		"pt": ["nhac nhac! 😋", "obrigado!", "que delícia 🦴"],
		"en": ["nom nom! 😋", "thank you!", "yummy 🦴"],
	},
	"pet_react": {
		"pt": ["ronron... 🥰", "adoro carinho!", "mais! mais!"],
		"en": ["purr... 🥰", "I love pets!", "more! more!"],
	},
	"play": {
		"pt": ["yupiii! 🎾", "de novo!", "tô voando! 🚀"],
		"en": ["yippee! 🎾", "again!", "I'm flying! 🚀"],
	},
	# reações a chacoalhar o mouse rápido (sacudida): tontura / enjoo / susto
	"shake_dizzy": {
		"pt": ["que tontura... 😵", "para de rodar! 😵", "tô zonzo 😵"],
		"en": ["so dizzy... 😵", "stop spinning! 😵", "I'm woozy 😵"],
	},
	"shake_nausea": {
		"pt": ["ugh... tô enjoado 🤢", "vou passar mal... 🤢", "que enjoo 🤢"],
		"en": ["ugh... I feel sick 🤢", "gonna be sick... 🤢", "so queasy 🤢"],
	},
	"shake_scared": {
		"pt": ["aaah! que susto! 😱", "me assustou! 😱", "eek! 😱"],
		"en": ["aaah! so scary! 😱", "you scared me! 😱", "eek! 😱"],
	},
	# --- bancos para nomes COMBINATÓRIOS (substantivo + adjetivo) ---
	# Os adjetivos pt são propositalmente invariáveis em gênero (terminam em -e/-l/-z/
	# -ante/-ar...), p/ combinar com qualquer substantivo sem erro de concordância.
	# Ordem montada em _suggest_name: pt = "Substantivo Adjetivo"; en = "Adjective Noun".
	# 30×30 ≈ 900 combinações por categoria/idioma.
	"pet_nouns": {
		"pt": ["Mel", "Nuvem", "Biscoito", "Pipoca", "Estrela", "Trovão", "Amora", "Faísca",
			"Brisa", "Cacau", "Lua", "Pingo", "Algodão", "Cometa", "Caramelo", "Trufa", "Pudim",
			"Brigadeiro", "Confete", "Pétala", "Floco", "Raio", "Botão", "Bolacha", "Abóbora",
			"Pêssego", "Avelã", "Geleia", "Néctar", "Sol"],
		"en": ["Honey", "Cloud", "Cookie", "Popcorn", "Star", "Thunder", "Berry", "Pebble",
			"Spark", "Breeze", "Cocoa", "Luna", "Pip", "Mochi", "Waffle", "Maple", "Pumpkin",
			"Biscuit", "Noodle", "Marble", "Pixel", "Comet", "Nugget", "Button", "Pickle",
			"Muffin", "Sprout", "Bean", "Peach", "Dot"],
	},
	"pet_adjs": {
		"pt": ["Alegre", "Doce", "Saltitante", "Brilhante", "Radiante", "Veloz", "Feliz",
			"Gentil", "Nobre", "Forte", "Elegante", "Vibrante", "Cintilante", "Reluzente",
			"Valente", "Estelar", "Lunar", "Solar", "Celeste", "Sutil", "Ágil", "Jovial",
			"Leal", "Audaz", "Sagaz", "Faiscante", "Fascinante", "Genial", "Fugaz", "Astral"],
		"en": ["Fluffy", "Cheeky", "Sleepy", "Bouncy", "Sunny", "Cozy", "Tiny", "Brave",
			"Merry", "Snuggly", "Dreamy", "Peppy", "Jolly", "Spunky", "Witty", "Cuddly",
			"Zippy", "Goofy", "Plucky", "Dapper", "Breezy", "Sparky", "Mellow", "Bubbly",
			"Chirpy", "Frisky", "Nimble", "Quirky", "Wobbly", "Perky"],
	},
	"acc_nouns": {
		"pt": ["Charme", "Gala", "Visual", "Estilo", "Brilho", "Pose", "Toque", "Glamour",
			"Luxo", "Pompa", "Encanto", "Acabamento", "Traje", "Conjunto", "Aura", "Realce",
			"Detalhe", "Requinte", "Esplendor", "Fulgor", "Lustre", "Adorno", "Verniz", "Porte",
			"Capricho", "Garbo", "Apuro", "Esmero", "Trato", "Floreio"],
		"en": ["Charm", "Gala", "Look", "Style", "Flair", "Shine", "Pose", "Vibe", "Glow",
			"Touch", "Trim", "Accent", "Ensemble", "Outfit", "Getup", "Garb", "Attire",
			"Finish", "Sheen", "Luster", "Motif", "Combo", "Set", "Aura", "Drip", "Fit",
			"Statement", "Edit", "Polish", "Grace"],
	},
	"acc_adjs": {
		"pt": ["Elegante", "Radiante", "Brilhante", "Real", "Estelar", "Vibrante", "Cintilante",
			"Reluzente", "Nobre", "Sutil", "Chique", "Singular", "Faiscante", "Fascinante",
			"Jovial", "Celeste", "Astral", "Solar", "Lunar", "Imperial", "Sideral", "Floral",
			"Polar", "Especial", "Triunfal", "Magistral", "Colossal", "Genial", "Fenomenal", "Original"],
		"en": ["Stylish", "Fancy", "Dapper", "Elegant", "Chic", "Deluxe", "Royal", "Shiny",
			"Sleek", "Classy", "Glam", "Posh", "Snazzy", "Swanky", "Dashing", "Polished",
			"Refined", "Vivid", "Bold", "Festive", "Regal", "Trendy", "Glossy", "Charming",
			"Suave", "Slick", "Spiffy", "Ritzy", "Plush", "Lavish"],
	},
}

## Texto traduzido para o idioma atual (cai no pt, depois na própria chave, se faltar).
func t(key: String) -> String:
	var e: Dictionary = STRINGS.get(key, {})
	return e.get(lang, e.get("pt", key))

## Lista de falas traduzida para o idioma atual.
func ta(key: String) -> Array:
	var e: Dictionary = STRING_LISTS.get(key, {})
	return e.get(lang, e.get("pt", []))

# --- helpers de idioma/locale para as automações (Automacoes/*.gd) ---
## Escolhe entre dois textos conforme o idioma atual. As automações usam isto para
## falas bilíngues sem precisar de tabela própria: zimmy.lang_text("pt...", "en...").
func lang_text(pt_text: String, en_text: String) -> String:
	return en_text if lang == "en" else pt_text

## Formata um número com N casas, usando o separador decimal do idioma
## (vírgula no pt-BR, ponto no en-US).
func fmt_num(v: float, decimals := 2) -> String:
	var s := String.num(v, decimals)
	return s.replace(".", ",") if lang == "pt" else s

## Formata uma variação percentual com sinal (+/-) e separador localizado.
func fmt_pct(v: float) -> String:
	var s := ("+" if v >= 0.0 else "") + String.num(v, 2)
	if lang == "pt":
		s = s.replace(".", ",")
	return s + "%"

## Valor em reais formatado (símbolo R$ + número localizado).
func fmt_money_brl(v: float, decimals := 4) -> String:
	return "R$ " + fmt_num(v, decimals)

## Reformata a data "AAAA-MM-DD HH:MM:SS" da API para o formato do idioma:
## pt-BR -> "DD/MM/AAAA HH:MM"; en-US -> "MM/DD/YYYY HH:MM". Vazio se não parsear.
func fmt_quote_date(create_date: String) -> String:
	var parts := create_date.strip_edges().split(" ")
	if parts.size() < 2:
		return create_date
	var ymd := parts[0].split("-")
	var hms := parts[1].split(":")
	if ymd.size() < 3 or hms.size() < 2:
		return create_date
	var y := ymd[0]; var mo := ymd[1]; var da := ymd[2]
	var hh := hms[0]; var mi := hms[1]
	if lang == "en":
		return "%s/%s/%s %s:%s" % [mo, da, y, hh, mi]
	return "%s/%s/%s %s:%s" % [da, mo, y, hh, mi]

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
		# --- categorias geométricas adicionais (esqueleto) — Default fica "limpo" ---
		"tail": "none",
		"horn": "none", "horn_color": Color("f5e6c8"),
		"hair_tuft": "none",
		"eye_shape": "round",
		"pupil_style": "round",
		"eyebrow": "none",
		"feet": "none",
		"arms": "none",
		"belly_mark": "none",
		"whiskers": "none",
		"wings": "none",
		"freckles": "none",
		"body_pattern": "none",
		"muzzle": "none",
		"critter": "none",
	}

## Gera um pet aleatório com estética equilibrada e cores alegres.
## - Geometria: além da silhueta do corpo (round/tall/wide/pear) e forma de orelha,
##   sorteia ~uma dúzia de categorias independentes do "esqueleto" — rabo, chifre,
##   topete, formato de olho, estilo de pupila, sobrancelha, patas, bracinhos, marca
##   na barriga, bigodes, asas e sardas — para variar muito além do Default.
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
	var cfg := {
		"body_color": body, "belly_color": belly, "ear_color": ear, "cheek_color": cheek,
		"ear_dx": randf_range(28.0, 40.0), "ear_y": randf_range(68.0, 80.0),
		"ear_w": randf_range(10.0, 18.0), "ear_h": randf_range(20.0, 32.0),
		"eye_dx": randf_range(14.0, 22.0), "eye_y": randf_range(90.0, 100.0),
		"eye_w": randf_range(8.0, 12.0), "eye_h": randf_range(9.0, 14.0),
		"body_w": randf_range(52.0, 62.0), "body_h": randf_range(50.0, 58.0),
		"belly_w": randf_range(34.0, 44.0), "belly_h": randf_range(30.0, 38.0),
		"body_shape": ["round", "round", "tall", "wide", "pear", "chubby", "slim"].pick_random(),
		"has_ears": randf() < 0.85,
		"ear_shape": ["round", "pointy", "floppy"].pick_random(),
		"has_antennae": randf() < 0.4,
		"antenna_color": ear,
		"has_cheeks": randf() < 0.7,
		"has_nose": randf() < 0.6,
		"nose_color": nose,
		"has_eyelashes": randf() < 0.5,
		"mouth_style": ["smile", "cat", "open", "line", "tongue", "fang"].pick_random(),
		# --- categorias geométricas adicionais (sorteadas de forma independente) ---
		"tail": ["none", "none", "curl", "puff", "stub"].pick_random(),
		"horn": ["none", "none", "none", "unicorn", "devil", "antlers"].pick_random(),
		"horn_color": Color.from_hsv(fposmod(hue + 0.12, 1.0), randf_range(0.2, 0.5), randf_range(0.9, 1.0)),
		"hair_tuft": ["none", "none", "tuft", "cowlick", "mohawk"].pick_random(),
		"eye_shape": ["round", "round", "oval", "tall", "sleepy"].pick_random(),
		"pupil_style": ["round", "round", "big", "cat", "sparkle", "heart"].pick_random(),
		"eyebrow": ["none", "none", "none", "flat", "raised", "serious"].pick_random(),
		"feet": ["none", "paws"].pick_random(),
		"arms": ["none", "nubs"].pick_random(),
		"belly_mark": ["none", "none", "spot", "heart"].pick_random(),
		"whiskers": ["none", "none", "short", "long"].pick_random(),
		"wings": ["none", "none", "none", "small"].pick_random(),
		"freckles": ["none", "freckles"].pick_random(),
		"body_pattern": ["none", "none", "none", "spots", "stripes"].pick_random(),
		"muzzle": ["none", "none", "round"].pick_random(),
		"critter": "none",
	}
	# ~55% das vezes o pet vira um "bichinho" reconhecível (gato/cachorro/coelho/...);
	# o resto continua sendo a criatura abstrata combinatória.
	if randf() < 0.55:
		var kind: String = CRITTERS.pick_random()
		cfg["critter"] = kind
		_apply_critter(cfg, kind)
	return cfg

## Arquétipos de bichinhos: bichos reconhecíveis por orelha/boca/bigode/cauda/proporção.
## A cor segue o sorteio normal (um gato roxo é válido e fofo); só a FORMA define o bicho.
const CRITTERS := ["cat", "dog", "bunny", "bear", "frog", "fox", "mouse", "pig"]

## Ajusta as chaves geométricas de `cfg` para parecer o bicho `kind` (modifica in-place).
func _apply_critter(cfg: Dictionary, kind: String) -> void:
	# Base limpa: tira os adereços "fantasia" para o bicho ler claro.
	cfg["has_antennae"] = false
	cfg["horn"] = "none"
	cfg["hair_tuft"] = "none"
	cfg["wings"] = "none"
	cfg["eyebrow"] = "none"
	cfg["has_ears"] = true
	cfg["has_cheeks"] = true
	match kind:
		"cat":
			cfg["ear_shape"] = "pointy"; cfg["ear_w"] = 13.0; cfg["ear_h"] = 28.0; cfg["ear_dx"] = 30.0
			cfg["mouth_style"] = "cat"; cfg["has_nose"] = true; cfg["whiskers"] = "long"
			cfg["pupil_style"] = "cat"; cfg["tail"] = "curl"
			cfg["body_shape"] = ["round", "slim"].pick_random()
		"dog":
			cfg["ear_shape"] = "floppy"; cfg["ear_w"] = 14.0; cfg["ear_h"] = 26.0; cfg["ear_dx"] = 34.0
			cfg["mouth_style"] = "tongue"; cfg["has_nose"] = true; cfg["muzzle"] = "round"
			cfg["tail"] = ["puff", "stub"].pick_random(); cfg["whiskers"] = "none"
			cfg["body_shape"] = ["round", "chubby"].pick_random()
		"bunny":
			cfg["ear_shape"] = "pointy"; cfg["ear_w"] = 9.0; cfg["ear_h"] = 40.0; cfg["ear_dx"] = 18.0
			cfg["mouth_style"] = "fang"; cfg["has_nose"] = true; cfg["tail"] = "puff"
			cfg["whiskers"] = "short"; cfg["body_shape"] = "round"
		"bear":
			cfg["ear_shape"] = "round"; cfg["ear_w"] = 11.0; cfg["ear_h"] = 11.0; cfg["ear_dx"] = 30.0
			cfg["mouth_style"] = "smile"; cfg["has_nose"] = true; cfg["muzzle"] = "round"
			cfg["feet"] = "paws"; cfg["body_shape"] = "chubby"; cfg["tail"] = "none"
		"frog":
			cfg["has_ears"] = false; cfg["mouth_style"] = "line"; cfg["has_nose"] = false
			cfg["eye_dx"] = 22.0; cfg["eye_w"] = 12.0; cfg["eye_h"] = 13.0; cfg["eye_y"] = 86.0
			cfg["pupil_style"] = "big"; cfg["feet"] = "paws"; cfg["body_shape"] = "wide"
			cfg["whiskers"] = "none"; cfg["tail"] = "none"
		"fox":
			cfg["ear_shape"] = "pointy"; cfg["ear_w"] = 12.0; cfg["ear_h"] = 26.0; cfg["ear_dx"] = 32.0
			cfg["mouth_style"] = "cat"; cfg["has_nose"] = true; cfg["tail"] = ["puff", "curl"].pick_random()
			cfg["body_shape"] = "slim"
		"mouse":
			cfg["ear_shape"] = "round"; cfg["ear_w"] = 16.0; cfg["ear_h"] = 16.0; cfg["ear_dx"] = 34.0
			cfg["mouth_style"] = "line"; cfg["has_nose"] = true; cfg["whiskers"] = "long"
			cfg["tail"] = "stub"; cfg["body_shape"] = ["round", "slim"].pick_random()
		_:  # "pig"
			cfg["ear_shape"] = "pointy"; cfg["ear_w"] = 9.0; cfg["ear_h"] = 14.0; cfg["ear_dx"] = 28.0
			cfg["mouth_style"] = "line"; cfg["has_nose"] = true; cfg["muzzle"] = "round"
			cfg["tail"] = "curl"; cfg["body_shape"] = "chubby"; cfg["whiskers"] = "none"

# ------------------------------------------------------------------ config de acessório
## Acessório "vazio" (nada vestido) — é o padrão do Default.
func _default_acc() -> Dictionary:
	return {
		"hat": "none", "hat_color": Color("c0392b"),
		"glasses": "none", "glasses_color": Color("2c3e50"),
		"bow": "none", "bow_color": Color("e84393"),
		"scarf": "none", "scarf_color": Color("2980b9"),
		# --- categorias geométricas adicionais (Default não veste nada) ---
		"necklace": "none", "necklace_color": Color("f1c40f"),
		"earrings": "none", "earring_color": Color("f1c40f"),
		"collar": "none", "collar_color": Color("e74c3c"),
		"headphones": "none", "headphone_color": Color("34495e"),
		"monocle": "none", "monocle_color": Color("bdc3c7"),
		"mustache": "none", "mustache_color": Color("4a3527"),
		"flower": "none", "flower_color": Color("e84393"),
		"badge": "none", "badge_color": Color("f39c12"),
		"tie": "none", "tie_color": Color("8e44ad"),
		"sash": "none", "sash_color": Color("c0392b"),
		"mask": "none", "mask_color": Color("ecf0f1"),
		"cheek_sticker": "none", "sticker_color": Color("e84393"),
		"belt": "none", "belt_color": Color("6d4c41"),
		"backpack": "none", "backpack_color": Color("2e7d32"),
	}

## Gera acessórios aleatórios. Além dos 4 originais (chapéu/óculos/laço/cachecol),
## sorteia ~uma dúzia de categorias geométricas independentes (cada uma com cor própria).
func _random_acc() -> Dictionary:
	return {
		"hat": ["none", "beanie", "tophat", "crown", "cap", "wizard"].pick_random(),
		"hat_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.7, 0.95)),
		"glasses": ["none", "round", "square", "star", "heart", "sunglasses"].pick_random(),
		"glasses_color": Color.from_hsv(randf(), randf_range(0.2, 0.6), randf_range(0.15, 0.45)),
		"bow": ["none", "head", "neck"].pick_random(),
		"bow_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.8, 1.0)),
		"scarf": ["none", "present"].pick_random(),
		"scarf_color": Color.from_hsv(randf(), randf_range(0.4, 0.8), randf_range(0.6, 0.9)),
		# --- categorias geométricas adicionais (sorteadas de forma independente) ---
		"necklace": ["none", "none", "pearls", "pendant"].pick_random(),
		"necklace_color": Color.from_hsv(randf(), randf_range(0.4, 0.8), randf_range(0.8, 1.0)),
		"earrings": ["none", "none", "studs", "hoops"].pick_random(),
		"earring_color": Color.from_hsv(randf(), randf_range(0.3, 0.7), randf_range(0.85, 1.0)),
		"collar": ["none", "none", "plain", "bell"].pick_random(),
		"collar_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.7, 0.95)),
		"headphones": ["none", "none", "none", "present"].pick_random(),
		"headphone_color": Color.from_hsv(randf(), randf_range(0.2, 0.6), randf_range(0.25, 0.55)),
		"monocle": ["none", "none", "none", "present"].pick_random(),
		"monocle_color": Color.from_hsv(randf(), randf_range(0.1, 0.4), randf_range(0.5, 0.8)),
		"mustache": ["none", "none", "curly", "thin"].pick_random(),
		"mustache_color": Color.from_hsv(randf(), randf_range(0.2, 0.5), randf_range(0.2, 0.45)),
		"flower": ["none", "none", "present"].pick_random(),
		"flower_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.85, 1.0)),
		"badge": ["none", "none", "star", "heart"].pick_random(),
		"badge_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.8, 1.0)),
		"tie": ["none", "none", "necktie", "bowtie"].pick_random(),
		"tie_color": Color.from_hsv(randf(), randf_range(0.4, 0.85), randf_range(0.6, 0.9)),
		"sash": ["none", "none", "none", "present"].pick_random(),
		"sash_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.7, 0.95)),
		"mask": ["none", "none", "none", "medical", "ninja"].pick_random(),
		"mask_color": Color.from_hsv(randf(), randf_range(0.05, 0.35), randf_range(0.75, 0.98)),
		"cheek_sticker": ["none", "none", "star", "heart"].pick_random(),
		"sticker_color": Color.from_hsv(randf(), randf_range(0.5, 0.9), randf_range(0.85, 1.0)),
		"belt": ["none", "none", "plain", "buckle"].pick_random(),
		"belt_color": Color.from_hsv(randf(), randf_range(0.3, 0.7), randf_range(0.3, 0.6)),
		"backpack": ["none", "none", "none", "present"].pick_random(),
		"backpack_color": Color.from_hsv(randf(), randf_range(0.4, 0.8), randf_range(0.5, 0.85)),
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
	_load_notes()       # idem: notas salvas já aparecem no submenu 📝 Notas
	_load_reminders()   # idem: lembretes salvos já aparecem (e ligados) no submenu ⏰ Lembretes
	_build_audio()      # sintetiza e prepara os sons de alerta (WhatsApp / Gmail)
	_build_menu()
	_build_save_dialog()

	# Saudação usa o nome do pet salvo ativo (ou "Zimmy" se for o Default/aleatório).
	var greet_name := current_pet_name if saved_pets.has(current_pet_name) else "Zimmy"
	say(t("hello") % greet_name)

# ------------------------------------------------------------------ menu / UI
func _build_menu() -> void:
	pets_menu = PopupMenu.new()
	pets_menu.id_pressed.connect(_on_pick_pet)
	acc_menu = PopupMenu.new()
	acc_menu.id_pressed.connect(_on_pick_acc)
	pets_del_menu = PopupMenu.new()
	pets_del_menu.id_pressed.connect(_on_del_pet)
	acc_del_menu = PopupMenu.new()
	acc_del_menu.id_pressed.connect(_on_del_acc)
	automations_menu = PopupMenu.new()
	automations_menu.id_pressed.connect(_on_pick_automation)
	timers_menu = PopupMenu.new()
	timers_menu.id_pressed.connect(_on_pick_automation)
	moedas_menu = PopupMenu.new()
	moedas_menu.id_pressed.connect(_on_pick_automation)
	email_menu = PopupMenu.new()
	email_menu.id_pressed.connect(_on_pick_automation)
	whatsapp_menu = PopupMenu.new()
	whatsapp_menu.id_pressed.connect(_on_pick_automation)
	notes_menu = PopupMenu.new()
	notes_menu.id_pressed.connect(_on_pick_note)
	notes_del_menu = PopupMenu.new()
	notes_del_menu.id_pressed.connect(_on_del_note)
	notes_menu.add_child(notes_del_menu)   # fica sempre na árvore; o item-submenu é (re)criado em _rebuild
	reminders_menu = PopupMenu.new()
	reminders_menu.id_pressed.connect(_on_pick_reminder)
	reminders_del_menu = PopupMenu.new()
	reminders_del_menu.id_pressed.connect(_on_del_reminder)
	reminders_menu.add_child(reminders_del_menu)   # idem Notas: mantém na árvore
	lang_menu = PopupMenu.new()
	lang_menu.add_radio_check_item("Português (Brasil)", LANG_PT)
	lang_menu.add_radio_check_item("English (US)", LANG_EN)
	lang_menu.id_pressed.connect(_on_pick_language)
	donate_menu = PopupMenu.new()
	donate_menu.add_icon_item(_provider_icon(Color("ea4aaa")), "GitHub Sponsors", DONATE_SPONSORS)
	donate_menu.add_icon_item(_provider_icon(Color("ff5e2b")), "Ko-fi", DONATE_KOFI)
	donate_menu.id_pressed.connect(_on_pick_donate)
	sounds_menu = PopupMenu.new()
	sounds_menu.add_check_item(t("mi_feed"), SND_FEED)
	sounds_menu.add_check_item(t("mi_pet"), SND_PET)
	sounds_menu.add_check_item(t("mi_play"), SND_PLAY)
	sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_FEED), sound_feed_on)
	sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_PET), sound_pet_on)
	sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_PLAY), sound_play_on)
	sounds_menu.id_pressed.connect(_on_pick_sound)

	menu = PopupMenu.new()
	menu.add_check_item(t("mi_status"), MI_STATUS)   # mesmo grupo de Alimentar/Carinho/Brincar
	menu.set_item_checked(menu.get_item_index(MI_STATUS), show_status)
	menu.add_item(t("mi_feed"), MI_FEED)
	menu.add_item(t("mi_pet"), MI_PET)
	menu.add_item(t("mi_play"), MI_PLAY)
	menu.add_submenu_node_item(t("mi_sounds"), sounds_menu, MI_SOUNDS)   # alertas de som das 3 ações
	menu.add_separator()
	menu.add_check_item(t("mi_random"), MI_RANDOM)
	menu.add_check_item(t("mi_random_acc"), MI_RANDOM_ACC)
	menu.add_check_item(t("mi_show_acc"), MI_SHOW_ACC)
	menu.set_item_checked(menu.get_item_index(MI_SHOW_ACC), show_accessories)
	menu.add_separator()
	menu.add_item(t("mi_save_pet"), MI_SAVE_PET)
	menu.add_submenu_node_item(t("mi_choose_pet"), pets_menu, MI_CHOOSE_PET)
	menu.add_submenu_node_item(t("mi_del_pet"), pets_del_menu, MI_DEL_PET)
	menu.add_item(t("mi_save_acc"), MI_SAVE_ACC)
	menu.add_submenu_node_item(t("mi_choose_acc"), acc_menu, MI_CHOOSE_ACC)
	menu.add_submenu_node_item(t("mi_del_acc"), acc_del_menu, MI_DEL_ACC)
	menu.add_separator()
	menu.add_submenu_node_item(t("mi_automations"), automations_menu, MI_AUTOMATIONS)
	menu.add_submenu_node_item(t("mi_timers"), timers_menu, MI_TIMERS)   # agendadas isoladas aqui
	menu.add_submenu_node_item(t("mi_reminders"), reminders_menu, MI_REMINDERS)  # lembretes do usuário
	menu.add_submenu_node_item(t("mi_moedas"), moedas_menu, MI_MOEDAS)   # logo abaixo de ⚙️ Automações
	menu.add_submenu_node_item(t("mi_notes"), notes_menu, MI_NOTES)
	menu.add_submenu_node_item(t("mi_emails"), email_menu, MI_EMAIL)
	menu.add_submenu_node_item(t("mi_whatsapp"), whatsapp_menu, MI_WHATSAPP)
	menu.add_submenu_node_item(t("mi_language"), lang_menu, MI_LANG)
	menu.add_submenu_node_item(t("mi_donate"), donate_menu, MI_DONATE)
	menu.add_separator()
	menu.add_item(t("mi_quit"), MI_QUIT)
	menu.id_pressed.connect(_on_menu)
	add_child(menu)
	# Mapa submenu -> pai e gancho p/ reposicionar à esquerda quando _cascade_left.
	_submenu_parent = {
		pets_menu: menu, pets_del_menu: menu, acc_menu: menu, acc_del_menu: menu,
		automations_menu: menu, timers_menu: menu, notes_menu: menu, email_menu: menu,
		whatsapp_menu: menu, lang_menu: menu, donate_menu: menu, moedas_menu: menu,
		sounds_menu: menu, reminders_menu: menu,
		notes_del_menu: notes_menu,
		reminders_del_menu: reminders_menu,
	}
	for sub in _submenu_parent:
		(sub as PopupMenu).about_to_popup.connect(_flip_submenu_if_left.bind(sub))
	_build_cred_dialog()
	_build_delete_dialog()
	_build_notes_dialog()
	_build_reminders_dialog()
	_rebuild_pets_menu()
	_rebuild_acc_menu()
	_rebuild_automations_menu()
	_rebuild_notes_menu()
	_rebuild_reminders_menu()
	_refresh_lang_checks()

## Clique numa opção de doação: abre o link do provedor no navegador padrão.
func _on_pick_donate(id: int) -> void:
	match id:
		DONATE_SPONSORS: OS.shell_open(DONATE_SPONSORS_URL)
		DONATE_KOFI: OS.shell_open(DONATE_KOFI_URL)

## Clique num toggle do submenu 🔊 Alertas de som: liga/desliga o alerta daquela
## ação — vale tanto p/ o som ao executá-la quanto p/ o lembrete de necessidade
## baixa — e persiste a escolha.
func _on_pick_sound(id: int) -> void:
	match id:
		SND_FEED:
			sound_feed_on = not sound_feed_on
			sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_FEED), sound_feed_on)
		SND_PET:
			sound_pet_on = not sound_pet_on
			sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_PET), sound_pet_on)
		SND_PLAY:
			sound_play_on = not sound_play_on
			sounds_menu.set_item_checked(sounds_menu.get_item_index(SND_PLAY), sound_play_on)
		_:
			return
	_save_settings()

## Marca (✓) o idioma ativo no submenu de idioma.
func _refresh_lang_checks() -> void:
	lang_menu.set_item_checked(lang_menu.get_item_index(LANG_PT), lang == "pt")
	lang_menu.set_item_checked(lang_menu.get_item_index(LANG_EN), lang == "en")

## Troca o idioma, persiste e reaplica todos os rótulos da UI.
func _on_pick_language(id: int) -> void:
	var new_lang := "en" if id == LANG_EN else "pt"
	if new_lang == lang:
		return
	lang = new_lang
	_apply_menu_labels()
	_refresh_lang_checks()
	_save_settings()

## Reaplica os rótulos do menu principal e submenus ao idioma atual.
func _apply_menu_labels() -> void:
	menu.set_item_text(menu.get_item_index(MI_FEED), t("mi_feed"))
	menu.set_item_text(menu.get_item_index(MI_PET), t("mi_pet"))
	menu.set_item_text(menu.get_item_index(MI_PLAY), t("mi_play"))
	menu.set_item_text(menu.get_item_index(MI_SOUNDS), t("mi_sounds"))
	sounds_menu.set_item_text(sounds_menu.get_item_index(SND_FEED), t("mi_feed"))
	sounds_menu.set_item_text(sounds_menu.get_item_index(SND_PET), t("mi_pet"))
	sounds_menu.set_item_text(sounds_menu.get_item_index(SND_PLAY), t("mi_play"))
	menu.set_item_text(menu.get_item_index(MI_RANDOM), t("mi_random"))
	menu.set_item_text(menu.get_item_index(MI_RANDOM_ACC), t("mi_random_acc"))
	menu.set_item_text(menu.get_item_index(MI_SHOW_ACC), t("mi_show_acc"))
	menu.set_item_text(menu.get_item_index(MI_STATUS), t("mi_status"))
	menu.set_item_text(menu.get_item_index(MI_CHOOSE_PET), t("mi_choose_pet"))
	menu.set_item_text(menu.get_item_index(MI_DEL_PET), t("mi_del_pet"))
	menu.set_item_text(menu.get_item_index(MI_CHOOSE_ACC), t("mi_choose_acc"))
	menu.set_item_text(menu.get_item_index(MI_DEL_ACC), t("mi_del_acc"))
	menu.set_item_text(menu.get_item_index(MI_AUTOMATIONS), t("mi_automations"))
	menu.set_item_text(menu.get_item_index(MI_TIMERS), t("mi_timers"))
	menu.set_item_text(menu.get_item_index(MI_REMINDERS), t("mi_reminders"))
	menu.set_item_text(menu.get_item_index(MI_MOEDAS), t("mi_moedas"))
	menu.set_item_text(menu.get_item_index(MI_NOTES), t("mi_notes"))
	menu.set_item_text(menu.get_item_index(MI_EMAIL), t("mi_emails"))
	menu.set_item_text(menu.get_item_index(MI_WHATSAPP), t("mi_whatsapp"))
	menu.set_item_text(menu.get_item_index(MI_DONATE), t("mi_donate"))
	menu.set_item_text(menu.get_item_index(MI_LANG), t("mi_language"))
	menu.set_item_text(menu.get_item_index(MI_QUIT), t("mi_quit"))
	_refresh_save_labels()                 # MI_SAVE_PET/ACC (Salvar vs Renomear)
	_rebuild_pets_menu()                   # sentinelas "Selecione..."/"Padrão"
	_rebuild_acc_menu()                    # sentinelas "Selecione..."/"Nenhum"
	_rebuild_automations_menu()            # nomes das automações no idioma atual
	_rebuild_notes_menu()                  # rótulos do submenu 📝 Notas no idioma atual
	_rebuild_reminders_menu()              # rótulos do submenu ⏰ Lembretes no idioma atual

## (Re)constrói o dropdown de pets: "Selecione..." (0) e "Default" (1) no topo.
func _rebuild_pets_menu() -> void:
	pets_menu.clear()
	pet_menu_ids.clear()
	pets_menu.add_item(t("select"), 0)
	pets_menu.set_item_disabled(0, true)
	pets_menu.add_radio_check_item(t("default_pet"), 1)
	var next_id := 100
	for nm in saved_pets.keys():
		pets_menu.add_radio_check_item(nm, next_id)
		pet_menu_ids[next_id] = nm
		next_id += 1
	_refresh_pets_menu_checks()
	_rebuild_pets_del_menu()

## (Re)constrói o submenu "Excluir pet": só pets salvos (Default/Selecione não entram).
func _rebuild_pets_del_menu() -> void:
	pets_del_menu.clear()
	pet_del_ids.clear()
	if saved_pets.is_empty():
		pets_del_menu.add_item(t("no_saved_pets"), 0)
		pets_del_menu.set_item_disabled(0, true)
		return
	var next_id := 100
	for nm in saved_pets.keys():
		pets_del_menu.add_item("🗑️ %s" % nm, next_id)
		pet_del_ids[next_id] = nm
		next_id += 1

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
	acc_menu.add_item(t("select"), 0)
	acc_menu.set_item_disabled(0, true)
	acc_menu.add_radio_check_item(t("none_acc"), 1)
	var next_id := 100
	for nm in saved_accessories.keys():
		acc_menu.add_radio_check_item(nm, next_id)
		acc_menu_ids[next_id] = nm
		next_id += 1
	_refresh_acc_menu_checks()
	_rebuild_acc_del_menu()

## (Re)constrói o submenu "Excluir acessório": só acessórios salvos (Nenhum/Selecione não entram).
func _rebuild_acc_del_menu() -> void:
	acc_del_menu.clear()
	acc_del_ids.clear()
	if saved_accessories.is_empty():
		acc_del_menu.add_item(t("no_saved_acc"), 0)
		acc_del_menu.set_item_disabled(0, true)
		return
	var next_id := 100
	for nm in saved_accessories.keys():
		acc_del_menu.add_item("🗑️ %s" % nm, next_id)
		acc_del_ids[next_id] = nm
		next_id += 1

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
	timers_menu.clear()
	moedas_menu.clear()
	email_menu.clear()
	whatsapp_menu.clear()
	automation_ids.clear()
	automation_item_menu.clear()
	# Toggle "🔔 Alerta de som" no TOPO de cada submenu, antes do contador (WhatsApp/Gmail).
	whatsapp_menu.add_check_item(t("mi_sound_alert"), SND_WHATSAPP)
	whatsapp_menu.set_item_checked(whatsapp_menu.get_item_index(SND_WHATSAPP), whatsapp_sound_on)
	whatsapp_menu.add_separator()
	email_menu.add_check_item(t("mi_sound_alert"), SND_GMAIL)
	email_menu.set_item_checked(email_menu.get_item_index(SND_GMAIL), gmail_sound_on)
	email_menu.add_separator()
	var list := _scan_automations()
	var n_auto := 0
	var n_timers := 0
	var n_email := 0
	var n_moedas := 0
	var n_whatsapp := 0
	var next_id := 100
	for a in list:
		var path: String = a["path"]
		var sched: Dictionary = a["sched"]
		var group: String = automation_groups.get(path, "")
		# Roteamento: grupos dedicados primeiro; do grupo padrão, as AGENDADAS (com
		# SCHEDULE) vão para ⏱️ Temporizadores e as avulsas ficam em ⚙️ Automações.
		var target: PopupMenu = automations_menu
		if group == "email":
			target = email_menu
		elif group == "moedas":
			target = moedas_menu
		elif group == "whatsapp":
			target = whatsapp_menu
		elif not sched.is_empty():
			target = timers_menu
		# Rótulo: nome + (frequência, se agendada) + (badge, se houver).
		var label: String = a["name"]
		if not sched.is_empty():
			label += " — %s" % sched["label"]
		if automation_badge_keys.has(path):
			var bk: String = automation_badge_keys[path]
			if automation_badges.has(bk):
				label += " — %s %s" % [automation_badges[bk], t("unread")]
		# Ícone à esquerda. Provedores (e-mail/WhatsApp) usam a cor de ICON_COLOR;
		# os Temporizadores ganham um relógio e as avulsas um ▶ (play) — todo item
		# do menu recebe um ícone adequado.
		var icon: Texture2D = null
		if automation_flags.has(path):
			icon = _flag_icon(automation_flags[path])
		elif automation_icon_colors.has(path):
			icon = _provider_icon(automation_icon_colors[path])
		elif target == timers_menu:
			icon = _clock_icon()
		elif target == automations_menu:
			icon = _run_icon()
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
		elif group == "moedas":
			n_moedas += 1
		elif group == "whatsapp":
			n_whatsapp += 1
		elif target == timers_menu:
			n_timers += 1
		else:
			n_auto += 1
		next_id += 1
	menu.set_item_disabled(menu.get_item_index(MI_AUTOMATIONS), n_auto == 0)
	menu.set_item_disabled(menu.get_item_index(MI_TIMERS), n_timers == 0)
	menu.set_item_disabled(menu.get_item_index(MI_MOEDAS), n_moedas == 0)
	menu.set_item_disabled(menu.get_item_index(MI_EMAIL), n_email == 0)
	menu.set_item_disabled(menu.get_item_index(MI_WHATSAPP), n_whatsapp == 0)

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

## Ícone de relógio (Temporizadores): anel + dois ponteiros. Cacheado por "clock".
func _clock_icon() -> Texture2D:
	if _icon_cache.has("clock"):
		return _icon_cache["clock"]
	var sz := 16
	var img := Image.create(sz, sz, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(sz / 2.0, sz / 2.0)
	var col := Color("e67e22")          # laranja
	var r := sz / 2.0 - 1.0
	for y in sz:
		for x in sz:
			var d := Vector2(x + 0.5, y + 0.5).distance_to(c)
			if d <= r and d >= r - 2.0:  # anel
				img.set_pixel(x, y, col)
	_line_img(img, c, c + Vector2(0.0, -4.5), col)   # ponteiro dos minutos (12h)
	_line_img(img, c, c + Vector2(3.0, 0.5), col)    # ponteiro das horas
	var tex := ImageTexture.create_from_image(img)
	_icon_cache["clock"] = tex
	return tex

## Ícone de "executar" (▶) para automações avulsas. Cacheado por "run".
func _run_icon() -> Texture2D:
	if _icon_cache.has("run"):
		return _icon_cache["run"]
	var sz := 16
	var img := Image.create(sz, sz, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var col := Color("27ae60")          # verde
	for x in range(4, 13):
		var hh := 5.0 * float(12 - x) / 8.0   # triângulo apontando p/ a direita
		for y in range(int(round(8.0 - hh)), int(round(8.0 + hh)) + 1):
			if y >= 0 and y < sz:
				img.set_pixel(x, y, col)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache["run"] = tex
	return tex

## Risca uma linha de `a` a `b` numa Image (amostragem simples), p/ os ícones.
func _line_img(img: Image, a: Vector2, b: Vector2, col: Color) -> void:
	var steps := int(a.distance_to(b)) + 1
	for i in steps + 1:
		var p := a.lerp(b, float(i) / float(steps))
		var x := int(round(p.x))
		var y := int(round(p.y))
		if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
			img.set_pixel(x, y, col)

## Preenche o retângulo [x0,x1) × [y0,y1) de uma Image (recorte seguro), p/ as bandeiras.
func _rect_img(img: Image, x0: int, y0: int, x1: int, y1: int, col: Color) -> void:
	for y in range(y0, y1):
		for x in range(x0, x1):
			if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
				img.set_pixel(x, y, col)

## Ícone de bandeira (22×15, textura) para os itens de 💱 Moedas — os emojis de
## bandeira (regional indicators) não são desenhados nos PopupMenu, então usamos
## bandeirinhas simplificadas em pixel. Cacheado por "flag_<code>".
func _flag_icon(code: String) -> Texture2D:
	var key := "flag_" + code
	if _icon_cache.has(key):
		return _icon_cache[key]
	var w := 22
	var h := 15
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	match code:
		"us": _flag_us(img)
		"eu": _flag_eu(img)
		"gb": _flag_gb(img)
		"jp": _flag_jp(img)
		"cn": _flag_cn(img)
		_:   _rect_img(img, 1, 1, w - 1, h - 1, Color(0.6, 0.6, 0.6))
	# Borda sutil para a bandeira "saltar" do fundo do menu.
	var bcol := Color(0, 0, 0, 0.35)
	for x in w:
		img.set_pixel(x, 0, bcol); img.set_pixel(x, h - 1, bcol)
	for y in h:
		img.set_pixel(0, y, bcol); img.set_pixel(w - 1, y, bcol)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[key] = tex
	return tex

## EUA: faixas vermelhas/brancas + cantão azul com "estrelinhas" brancas.
func _flag_us(img: Image) -> void:
	var red := Color("b22234"); var white := Color("ffffff"); var blue := Color("3c3b6e")
	for y in range(1, 14):
		var col := red if (int((y - 1) / 2) % 2 == 0) else white
		_rect_img(img, 1, y, 21, y + 1, col)
	_rect_img(img, 1, 1, 10, 8, blue)
	for sy in [2, 4, 6]:
		for sx in [2, 4, 6, 8]:
			img.set_pixel(sx, sy, white)

## União Europeia: campo azul + anel de "estrelas" amarelas.
func _flag_eu(img: Image) -> void:
	_rect_img(img, 1, 1, 21, 14, Color("003399"))
	var cx := 11.0; var cy := 7.5; var r := 4.6
	for i in 12:
		var a := TAU * float(i) / 12.0
		var px := int(round(cx + cos(a) * r))
		var py := int(round(cy + sin(a) * r * 0.82))
		if px >= 1 and px < 21 and py >= 1 and py < 14:
			img.set_pixel(px, py, Color("ffcc00"))

## Reino Unido (Union Jack simplificado): cruz + saltire branco/vermelho sobre azul.
func _flag_gb(img: Image) -> void:
	var blue := Color("012169"); var white := Color("ffffff"); var red := Color("c8102e")
	_rect_img(img, 1, 1, 21, 14, blue)
	# Saltire branco (X) com leve espessura.
	_line_img(img, Vector2(1, 1), Vector2(20, 13), white)
	_line_img(img, Vector2(2, 1), Vector2(20, 12), white)
	_line_img(img, Vector2(20, 1), Vector2(1, 13), white)
	_line_img(img, Vector2(19, 1), Vector2(1, 12), white)
	# Cruz branca (St. George).
	_rect_img(img, 9, 1, 13, 14, white)
	_rect_img(img, 1, 6, 21, 10, white)
	# Cruz vermelha por cima.
	_rect_img(img, 10, 1, 12, 14, red)
	_rect_img(img, 1, 7, 21, 9, red)
	# Diagonais vermelhas finas (deslocadas p/ o branco aparecer ao lado).
	_line_img(img, Vector2(2, 1), Vector2(20, 12), red)
	_line_img(img, Vector2(20, 2), Vector2(2, 13), red)

## Japão: campo branco + círculo vermelho central.
func _flag_jp(img: Image) -> void:
	_rect_img(img, 1, 1, 21, 14, Color("ffffff"))
	var c := Vector2(11.0, 7.5); var rr := 4.0
	for y in range(1, 14):
		for x in range(1, 21):
			if Vector2(x + 0.5, y + 0.5).distance_to(c) <= rr:
				img.set_pixel(x, y, Color("bc002d"))

## China: campo vermelho + estrela grande (aprox.) e estrelinhas amarelas.
func _flag_cn(img: Image) -> void:
	_rect_img(img, 1, 1, 21, 14, Color("de2910"))
	var yel := Color("ffde00")
	# Estrela grande (cruz preenchida) no quadrante superior esquerdo.
	_rect_img(img, 3, 4, 8, 5, yel)
	_rect_img(img, 5, 2, 6, 7, yel)
	img.set_pixel(4, 3, yel); img.set_pixel(6, 3, yel)
	# Quatro estrelinhas ao redor.
	for p in [[9, 2], [11, 4], [11, 7], [9, 9]]:
		img.set_pixel(p[0], p[1], yel)

# ------------------------------------------------------------------ notas (📝 Notas)
## (Re)constrói o submenu 📝 Notas: ações fixas (nova/colar) + a lista de notas salvas
## (clicar copia para a área de transferência) + o subsubmenu 🗑️ Excluir nota.
func _rebuild_notes_menu() -> void:
	notes_menu.clear()
	notes_del_menu.clear()
	note_ids.clear()
	note_del_ids.clear()
	notes_menu.add_item(t("note_new"), NOTE_NEW)
	notes_menu.add_item(t("note_paste"), NOTE_PASTE)
	notes_menu.add_separator()
	if notes.is_empty():
		var idx := notes_menu.get_item_count()
		notes_menu.add_item(t("note_empty"))   # rótulo desabilitado quando não há notas
		notes_menu.set_item_disabled(idx, true)
	else:
		var nid := 100
		for i in notes.size():
			var preview := _note_preview(notes[i])
			notes_menu.add_item(preview, nid)
			note_ids[nid] = i
			notes_del_menu.add_item(preview, nid)
			note_del_ids[nid] = i
			nid += 1
	notes_menu.add_separator()
	notes_menu.add_submenu_node_item(t("note_delete"), notes_del_menu, MI_NOTES_DEL)
	notes_menu.set_item_disabled(notes_menu.get_item_index(MI_NOTES_DEL), notes.is_empty())

## Prévia de uma nota numa única linha: tira quebras/tabs e limita o comprimento.
func _note_preview(text: String) -> String:
	var one := text.strip_edges().replace("\n", " ").replace("\t", " ")
	if one.length() > 30:
		one = one.substr(0, 30).strip_edges() + "..."
	return "🗒️ " + one

## Clique no submenu Notas: ações fixas ou (id 100+) copiar a nota para a transferência.
func _on_pick_note(id: int) -> void:
	if id == NOTE_NEW:
		_open_note_dialog()
	elif id == NOTE_PASTE:
		_paste_note_from_clipboard()
	elif note_ids.has(id):
		var i: int = note_ids[id]
		if i >= 0 and i < notes.size():
			DisplayServer.clipboard_set(notes[i])
			play_action_anim("react")
			say(t("note_copied"))

## Clique em 🗑️ Excluir nota: remove a nota e regrava o disco.
func _on_del_note(id: int) -> void:
	if not note_del_ids.has(id):
		return
	var i: int = note_del_ids[id]
	if i >= 0 and i < notes.size():
		notes.remove_at(i)
		_save_notes()
		_rebuild_notes_menu()
		say(t("note_deleted"))

## Cria uma nota a partir do texto atual da área de transferência (copy/paste).
func _paste_note_from_clipboard() -> void:
	var txt := DisplayServer.clipboard_get()
	if txt.strip_edges() == "":
		say(t("note_clip_empty"))
		return
	_add_note(txt)
	play_action_anim("save")
	say(t("note_pasted"))

## Acrescenta uma nota, persiste e reconstrói o submenu.
func _add_note(text: String) -> void:
	notes.append(text)
	_save_notes()
	_rebuild_notes_menu()

## Diálogo (multilinha) de nova nota — texto digitado à mão.
func _build_notes_dialog() -> void:
	notes_dialog = ConfirmationDialog.new()
	notes_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	note_edit = TextEdit.new()
	note_edit.custom_minimum_size = Vector2(340, 150)
	note_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	notes_dialog.add_child(note_edit)
	notes_dialog.confirmed.connect(_on_note_confirmed)
	add_child(notes_dialog)

func _open_note_dialog() -> void:
	notes_dialog.title = t("note_new_title")
	notes_dialog.ok_button_text = t("btn_save")
	notes_dialog.cancel_button_text = t("btn_cancel")
	note_edit.placeholder_text = t("note_ph")
	note_edit.text = ""
	var scr := DisplayServer.screen_get_usable_rect()
	notes_dialog.size = Vector2i(400, 230)
	notes_dialog.position = scr.position + (scr.size - notes_dialog.size) / 2
	notes_dialog.popup()
	note_edit.grab_focus()

func _on_note_confirmed() -> void:
	var txt := note_edit.text.strip_edges()
	if txt == "":
		say(t("note_empty_input"))
		return
	_add_note(txt)
	play_action_anim("save")
	say(t("note_saved"))

## Persiste a lista de notas (JSON simples — um array de strings).
func _save_notes() -> void:
	var f := FileAccess.open(NOTES_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(notes, "  "))
		f.close()

## Carrega as notas salvas (notes.json). Ignora silenciosamente se faltar/for inválido.
func _load_notes() -> void:
	var parsed = _read_json(NOTES_FILE)
	if parsed is Array:
		notes = []
		for v in parsed:
			notes.append(str(v))

# ------------------------------------------------------------------ ⏰ Lembretes
# Lembretes recorrentes criados pelo usuário SEM editar .gd: nativos, persistidos em
# user://reminders.json e disparados pelo mesmo relógio do agendador (_tick_reminders).

## (Re)constrói o submenu ⏰ Lembretes: "Novo", a lista (marcável = ligado) e "Excluir ▸".
func _rebuild_reminders_menu() -> void:
	reminders_menu.clear()
	reminders_del_menu.clear()
	reminder_ids.clear()
	reminder_del_ids.clear()
	reminders_menu.add_item(t("rem_new"), REM_NEW)
	reminders_menu.add_separator()
	if reminders.is_empty():
		var idx := reminders_menu.get_item_count()
		reminders_menu.add_item(t("rem_empty"))
		reminders_menu.set_item_disabled(idx, true)
	else:
		var rid := 100
		for i in reminders.size():
			var r: Dictionary = reminders[i]
			reminders_menu.add_check_item(_reminder_label(r), rid)
			reminders_menu.set_item_checked(reminders_menu.get_item_index(rid), bool(r.get("on", false)))
			reminder_ids[rid] = i
			reminders_del_menu.add_item(_reminder_label(r), rid)
			reminder_del_ids[rid] = i
			rid += 1
	reminders_menu.add_separator()
	reminders_menu.add_submenu_node_item(t("rem_delete"), reminders_del_menu, REM_DEL)
	reminders_menu.set_item_disabled(reminders_menu.get_item_index(REM_DEL), reminders.is_empty())

## Rótulo completo de um lembrete no menu: "⏰ <mensagem> · <frequência>".
func _reminder_label(r: Dictionary) -> String:
	var def := _parse_schedule_str(str(r.get("sched", "")))
	var freq := str(def.get("label", "?")) if not def.is_empty() else "?"
	return "⏰ %s · %s" % [_reminder_short(r), freq]

## Prévia curta da mensagem do lembrete (uma linha, truncada) — usada em rótulos/falas.
func _reminder_short(r: Dictionary) -> String:
	var one := str(r.get("text", "")).strip_edges().replace("\n", " ").replace("\t", " ")
	if one.length() > 24:
		one = one.substr(0, 24).strip_edges() + "..."
	return one

## Clique no submenu ⏰ Lembretes: "Novo" abre o diálogo; um lembrete (id 100+) liga/desliga.
func _on_pick_reminder(id: int) -> void:
	if id == REM_NEW:
		_open_reminder_dialog()
		return
	if reminder_ids.has(id):
		var i: int = reminder_ids[id]
		if i < 0 or i >= reminders.size():
			return
		var on := not bool(reminders[i].get("on", false))
		reminders[i]["on"] = on
		_save_reminders()
		_refresh_reminder_defs()
		_rebuild_reminders_menu()
		say((t("rem_on") if on else t("rem_off")) % _reminder_short(reminders[i]))

## Clique em 🗑️ Excluir lembrete: remove o lembrete e regrava o disco.
func _on_del_reminder(id: int) -> void:
	if not reminder_del_ids.has(id):
		return
	var i: int = reminder_del_ids[id]
	if i >= 0 and i < reminders.size():
		reminders.remove_at(i)
		_save_reminders()
		_refresh_reminder_defs()
		_rebuild_reminders_menu()
		say(t("rem_deleted"))

## Recalcula os descritores de agendamento (paralelos a `reminders`) e zera o runtime
## dos que estão ligados. Chamado após carregar/adicionar/excluir/alternar um lembrete.
func _refresh_reminder_defs() -> void:
	reminder_defs.clear()
	reminder_rt.clear()
	for i in reminders.size():
		reminder_defs.append(_parse_schedule_str(str(reminders[i].get("sched", ""))))
		if bool(reminders[i].get("on", false)):
			reminder_rt[i] = {"accum": 0.0, "last_day": -1, "last_hour": -1}

## Percorre os lembretes ligados e dispara os que atingiram a frequência (igual ao
## agendador das automações). Chamado a cada frame por _process.
func _tick_reminders(delta: float) -> void:
	var now := Time.get_datetime_dict_from_system()
	var cur_min: int = int(now.hour) * 60 + int(now.minute)
	for i in reminders.size():
		if not bool(reminders[i].get("on", false)):
			continue
		if i >= reminder_defs.size():
			continue
		var def: Dictionary = reminder_defs[i]
		if def.is_empty():
			continue
		if not reminder_rt.has(i):
			reminder_rt[i] = {"accum": 0.0, "last_day": -1, "last_hour": -1}
		var rt: Dictionary = reminder_rt[i]
		match def["kind"]:
			"interval":
				rt["accum"] += delta
				if rt["accum"] >= float(def["every"]):
					rt["accum"] = 0.0
					_fire_reminder(i)
			"hourly":
				if int(now.minute) == 0 and rt.get("last_hour", -1) != int(now.hour):
					rt["last_hour"] = int(now.hour)
					_fire_reminder(i)
			"daily":
				if cur_min == int(def["at_minute"]) and rt.get("last_day", -1) != int(now.day):
					rt["last_day"] = int(now.day)
					_fire_reminder(i)

## Dispara um lembrete: fala a mensagem na fila (notify, ~5 s), como as automações.
func _fire_reminder(i: int) -> void:
	if i < 0 or i >= reminders.size():
		return
	notify("⏰ " + str(reminders[i].get("text", "")))

## Diálogo de novo lembrete: mensagem + frequência (dropdown) + hora (só p/ "diariamente").
func _build_reminders_dialog() -> void:
	reminders_dialog = ConfirmationDialog.new()
	reminders_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	var vb := VBoxContainer.new()
	vb.custom_minimum_size = Vector2(340, 0)
	reminder_msg_label = Label.new()
	vb.add_child(reminder_msg_label)
	reminder_text_edit = LineEdit.new()
	vb.add_child(reminder_text_edit)
	reminder_freq_label = Label.new()
	vb.add_child(reminder_freq_label)
	reminder_freq_opt = OptionButton.new()
	reminder_freq_opt.item_selected.connect(_on_reminder_freq_changed)
	vb.add_child(reminder_freq_opt)
	reminder_time_row = HBoxContainer.new()
	reminder_time_label = Label.new()
	reminder_time_row.add_child(reminder_time_label)
	reminder_time_edit = LineEdit.new()
	reminder_time_edit.custom_minimum_size = Vector2(80, 0)
	reminder_time_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	reminder_time_row.add_child(reminder_time_edit)
	vb.add_child(reminder_time_row)
	reminders_dialog.add_child(vb)
	reminders_dialog.confirmed.connect(_on_reminder_confirmed)
	add_child(reminders_dialog)

## Abre o diálogo de novo lembrete (rótulos/opções no idioma atual).
func _open_reminder_dialog() -> void:
	reminders_dialog.title = t("rem_new_title")
	reminders_dialog.ok_button_text = t("btn_save")
	reminders_dialog.cancel_button_text = t("btn_cancel")
	reminder_msg_label.text = t("rem_msg_label")
	reminder_freq_label.text = t("rem_freq_label")
	reminder_time_label.text = t("rem_time_label")
	reminder_text_edit.placeholder_text = t("rem_ph")
	reminder_text_edit.text = ""
	reminder_freq_opt.clear()
	reminder_freq_opt.add_item(t("rem_freq_15m"))    # 0
	reminder_freq_opt.add_item(t("rem_freq_30m"))    # 1
	reminder_freq_opt.add_item(t("rem_freq_1h"))     # 2
	reminder_freq_opt.add_item(t("rem_freq_hourly")) # 3
	reminder_freq_opt.add_item(t("rem_freq_daily"))  # 4
	reminder_freq_opt.select(1)
	reminder_time_edit.text = "08:00"
	_on_reminder_freq_changed(1)
	var scr := DisplayServer.screen_get_usable_rect()
	reminders_dialog.size = Vector2i(400, 300)
	reminders_dialog.position = scr.position + (scr.size - reminders_dialog.size) / 2
	reminders_dialog.popup()
	reminder_text_edit.grab_focus()

## Mostra o campo de hora apenas quando o preset escolhido é "diariamente" (índice 4).
func _on_reminder_freq_changed(idx: int) -> void:
	reminder_time_row.visible = (idx == 4)

## Confirma o diálogo: monta a string de frequência do preset, valida e cria o lembrete.
func _on_reminder_confirmed() -> void:
	var txt := reminder_text_edit.text.strip_edges()
	if txt == "":
		say(t("rem_empty_input"))
		return
	var sched := ""
	match reminder_freq_opt.selected:
		0: sched = "15m"
		1: sched = "30m"
		2: sched = "1h"
		3: sched = "hourly"
		4:
			var hm := _parse_hhmm(reminder_time_edit.text)
			if hm.is_empty():
				say(t("rem_bad_time"))
				return
			sched = "daily@%02d:%02d" % [hm["h"], hm["m"]]
		_: sched = "30m"
	if _parse_schedule_str(sched).is_empty():
		say(t("rem_bad_time"))
		return
	reminders.append({"text": txt, "sched": sched, "on": true})
	_save_reminders()
	_refresh_reminder_defs()
	_rebuild_reminders_menu()
	play_action_anim("save")
	say(t("rem_saved"))

## Valida uma hora "HH:MM" -> {h, m} (ou {} se inválida).
func _parse_hhmm(s: String) -> Dictionary:
	var parts := s.strip_edges().split(":")
	if parts.size() != 2:
		return {}
	if not (parts[0].is_valid_int() and parts[1].is_valid_int()):
		return {}
	var h := int(parts[0])
	var m := int(parts[1])
	if h < 0 or h > 23 or m < 0 or m > 59:
		return {}
	return {"h": h, "m": m}

## Persiste os lembretes (array de {text, sched, on}).
func _save_reminders() -> void:
	var f := FileAccess.open(REMINDERS_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(reminders, "  "))
		f.close()

## Carrega os lembretes salvos (reminders.json) e recalcula os descritores.
func _load_reminders() -> void:
	var parsed = _read_json(REMINDERS_FILE)
	if parsed is Array:
		reminders = []
		for v in parsed:
			if v is Dictionary and v.has("text") and v.has("sched"):
				reminders.append({
					"text": str(v["text"]),
					"sched": str(v["sched"]),
					"on": bool(v.get("on", true)),
				})
	_refresh_reminder_defs()

## Lista os scripts .gd de res://Automacoes/ como [{name, path, sched}], ordenados pelo
## nome. Também (re)preenche schedule_defs com as automações que declaram frequência.
func _scan_automations() -> Array:
	var out: Array = []
	schedule_defs.clear()
	automation_groups.clear()
	automation_badge_keys.clear()
	automation_cred_keys.clear()
	automation_icon_colors.clear()
	automation_flags.clear()
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
				if consts.has("ICON_FLAG"):
					automation_flags[path] = str(consts["ICON_FLAG"]).to_lower()
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
		# Nome bilíngue: usa AUTOMATION_NAME_EN no inglês, se a automação declarar.
		if lang == "en" and consts.has("AUTOMATION_NAME_EN"):
			return str(consts["AUTOMATION_NAME_EN"])
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
		raw = str(consts["SCHEDULE"])
	elif consts.has("SCHEDULE_SECONDS"):
		raw = str(consts["SCHEDULE_SECONDS"])
	return _parse_schedule_str(raw)

## Converte uma string de frequência ("30s"/"5m"/"2h"/"hourly"/"daily@HH:MM"/número em
## segundos) num descritor {kind, every, at_minute, label}. Usado tanto pelas automações
## (const SCHEDULE) quanto pelos lembretes do usuário (⏰ Lembretes). {} se inválida/vazia.
func _parse_schedule_str(raw: String) -> Dictionary:
	raw = raw.strip_edges().to_lower()
	if raw == "":
		return {}
	if raw.is_valid_float():                       # número puro => segundos
		return _interval_def(float(raw))
	if raw == "hourly":                            # toda hora cheia (XX:00)
		return {"kind": "hourly", "every": 0.0, "at_minute": -1, "label": t("freq_hourly")}
	if raw.begins_with("daily@"):                  # uma vez por dia em HH:MM
		var hm := raw.substr(6).split(":")
		var h := clampi(int(hm[0]), 0, 23)
		var m := clampi((int(hm[1]) if hm.size() > 1 else 0), 0, 59)
		return {"kind": "daily", "every": 0.0, "at_minute": h * 60 + m, "label": t("freq_daily") % [h, m]}
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
	return {"kind": "interval", "every": secs, "at_minute": -1, "label": t("freq_every") % _human_secs(secs)}

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
	# Toggles de alerta sonoro (não são automações; vivem no topo dos submenus).
	if id == SND_WHATSAPP:
		whatsapp_sound_on = not whatsapp_sound_on
		whatsapp_menu.set_item_checked(whatsapp_menu.get_item_index(SND_WHATSAPP), whatsapp_sound_on)
		_save_settings()
		return
	if id == SND_GMAIL:
		gmail_sound_on = not gmail_sound_on
		email_menu.set_item_checked(email_menu.get_item_index(SND_GMAIL), gmail_sound_on)
		_save_settings()
		return
	if not automation_ids.has(id):
		return
	var path := String(automation_ids[id])
	# Ação do usuário: abre a janela p/ a resposta (mesmo assíncrona, via callback web)
	# furar a fila e aparecer na hora — ver notify()/_preempt_with.
	urgent_cd = URGENT_WINDOW
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
			say(t("sched_on") % [schedule_defs[path].get("name", t("automation")), schedule_defs[path]["label"]])
		# Automações com credencial (e-mail): ao ligar, dispara já (pede login se faltar).
		if automation_cred_keys.has(path):
			cred_prompt_suppressed.erase(automation_cred_keys[path])
			_fire_automation(path)
	else:
		sched_runtime.erase(path)
		if announce and schedule_defs.has(path):
			say(t("sched_off") % schedule_defs[path].get("name", t("automation")))
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
		say(t("automation_invalid"))
		return
	var inst = (gd as GDScript).new()
	if inst == null:
		say(t("automation_invalid"))
		return
	if inst is Node:
		add_child(inst)               # Node persiste para automações contínuas
	if inst.has_method("run"):
		inst.run(self)
	else:
		say(t("automation_norun"))

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

## Utilitário para automações web COM autenticação HTTP Basic: faz um GET em `url`
## enviando o cabeçalho Authorization derivado de user/password e chama
## `cb.call(status: int, body: String)`:
##  - status = código HTTP (200 ok, 401 credencial inválida, 0 = falha de rede/DNS/timeout)
##  - body   = corpo da resposta como texto (vazio em falha de rede)
## A senha é limpa de espaços (App Passwords são exibidas em grupos de 4). Cria e descarta
## o HTTPRequest sozinho. Na closure passada use só `zimmy` e variáveis locais (não `self`).
func http_get_auth(url: String, user: String, password: String, cb: Callable) -> void:
	var http := HTTPRequest.new()
	add_child(http)
	var pass_clean := password.replace(" ", "").replace("\t", "")
	var token := Marshalls.utf8_to_base64("%s:%s" % [user, pass_clean])
	var headers := ["Authorization: Basic " + token]
	http.request_completed.connect(func(result, code, _headers, body):
		var status: int = (code if result == HTTPRequest.RESULT_SUCCESS else 0)
		if cb.is_valid():
			cb.call(status, body.get_string_from_utf8())
		http.queue_free()
	)
	if http.request(url, headers, HTTPClient.METHOD_GET) != OK:
		if cb.is_valid():
			cb.call(0, "")
		http.queue_free()

# ------------------------------------------------------------------ badges de automação
## Define o texto do badge (ex.: contador de não-lidos) de uma automação, por chave
## (const BADGE_KEY). Aparece no rótulo do item na próxima vez que o menu é montado.
## Quando o contador AUMENTA (chegou mensagem nova) e o alerta sonoro está ligado,
## toca o som correspondente — telefone (WhatsApp) ou correio (Gmail).
func set_automation_badge(key: String, text: String) -> void:
	var prev := str(automation_badges.get(key, ""))
	automation_badges[key] = text
	if prev != "" and prev.is_valid_int() and text.is_valid_int() and int(text) > int(prev):
		if key == "whatsapp" and whatsapp_sound_on:
			_play_alert(_ring_player)
		elif key == "email_gmail" and gmail_sound_on:
			_play_alert(_chime_player)

# ------------------------------------------------------------------ áudio (alertas)
## Cria os dois AudioStreamPlayer e sintetiza os sons em código (sem arquivos de
## áudio no projeto, para o build exportado não depender de assets externos).
func _build_audio() -> void:
	_ring_player = AudioStreamPlayer.new()
	_ring_player.stream = _build_ring_sound()
	_ring_player.volume_db = -8.0     # "baixo som" de telefone
	add_child(_ring_player)
	_chime_player = AudioStreamPlayer.new()
	_chime_player.stream = _build_chime_sound()
	_chime_player.volume_db = -8.0    # "baixo som" de correio
	add_child(_chime_player)
	# Sons das ações (Alimentar/Carinho/Brincar): tocam ao executar a ação e como
	# lembrete quando a necessidade fica baixa. Também sintetizados em código.
	_feed_variants = _build_feed_sounds()
	_feed_player = AudioStreamPlayer.new()
	_feed_player.stream = _feed_variants[0]
	_feed_player.volume_db = -8.0
	add_child(_feed_player)
	_pet_variants = _build_pet_sounds()
	_pet_player = AudioStreamPlayer.new()
	_pet_player.stream = _pet_variants[0]
	_pet_player.volume_db = -8.0
	add_child(_pet_player)
	_play_variants = _build_play_sounds()
	_play_player = AudioStreamPlayer.new()
	_play_player.stream = _play_variants[0]
	_play_player.volume_db = -8.0
	add_child(_play_player)

## Toca um alerta — só se ainda não estiver tocando, para não se sobrepor a si mesmo.
func _play_alert(player: AudioStreamPlayer) -> void:
	if player and not player.playing:
		player.play()

## Toca uma variação SORTEADA do grupo (Alimentar/Carinho/Brincar): troca o stream do
## player por uma das variações antes de tocar, p/ o som variar dentro do mesmo caráter.
func _play_group(player: AudioStreamPlayer, variants: Array) -> void:
	if player and not player.playing:
		if not variants.is_empty():
			player.stream = variants.pick_random()
		player.play()

## Empacota amostras float [-1,1] num AudioStreamWAV PCM 16-bit mono.
func _make_wav(samples: PackedFloat32Array, rate: int) -> AudioStreamWAV:
	var bytes := PackedByteArray()
	bytes.resize(samples.size() * 2)
	for i in samples.size():
		bytes.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = bytes
	return wav

## Telefone tocando: dois toques curtos (par de tons 440+480 Hz) com uma pausa,
## imitando a cadência "trim-trim" de um telefone.
func _build_ring_sound() -> AudioStreamWAV:
	var rate := 22050
	var samples := PackedFloat32Array()
	var pattern := [[0.30, true], [0.12, false], [0.30, true]]   # toque, pausa, toque
	for seg in pattern:
		var dur: float = seg[0]
		var on: bool = seg[1]
		var n := int(dur * rate)
		for i in n:
			var t := float(i) / rate
			var v := 0.0
			if on:
				v = (sin(TAU * 440.0 * t) + sin(TAU * 480.0 * t)) * 0.5
				var env := 1.0                       # micro fade p/ não estalar
				if t < 0.01: env = t / 0.01
				elif t > dur - 0.01: env = (dur - t) / 0.01
				v *= env * 0.7
			samples.append(v)
	return _make_wav(samples, rate)

## Entrega de correio: um "ding-dong" de duas notas com decaimento de sino.
func _build_chime_sound() -> AudioStreamWAV:
	var rate := 22050
	var samples := PackedFloat32Array()
	for f in [660.0, 520.0]:                          # ding (agudo) → dong (grave)
		var dur := 0.45
		var n := int(dur * rate)
		for i in n:
			var t := float(i) / rate
			var env: float = exp(-5.0 * t)            # decaimento exponencial (sino)
			var v := (sin(TAU * f * t) + 0.3 * sin(TAU * f * 2.0 * t)) * env
			samples.append(v * 0.7)
	return _make_wav(samples, rate)

## Alimentar: "mordidinhas" curtas e graves (mastigada) — blips no tom-base `base_f`.
## Parametrizado p/ gerar variações (tom, nº de mordidas, ritmo) — ver _build_feed_sounds.
func _synth_feed(base_f: float, munches: int, dur: float, gap: float) -> AudioStreamWAV:
	var rate := 22050
	var samples := PackedFloat32Array()
	for _munch in munches:
		var n := int(dur * rate)
		for i in n:
			var t := float(i) / rate
			var env: float = exp(-13.0 * t)            # ataque seco que decai rápido (mordida)
			var v := (sin(TAU * base_f * t) + 0.5 * sin(TAU * base_f * 0.5 * t)) * env
			samples.append(v * 0.7)
		for _j in int(gap * rate):                     # pausinha entre as mordidas
			samples.append(0.0)
	return _make_wav(samples, rate)

## Carinho: ronronado quente — tom grave `base_f` com tremolo `trem_hz` e envelope suave.
func _synth_pet(base_f: float, trem_hz: float, dur: float) -> AudioStreamWAV:
	var rate := 22050
	var samples := PackedFloat32Array()
	var n := int(dur * rate)
	for i in n:
		var t := float(i) / rate
		var env: float = sin(PI * t / dur)             # sobe e desce (não começa/termina seco)
		var tremolo: float = 0.5 + 0.5 * sin(TAU * trem_hz * t)   # o "rrrr" do ronron
		var v := sin(TAU * base_f * t) * tremolo * env
		samples.append(v * 0.8)
	return _make_wav(samples, rate)

## Brincar: arpejo alegre com as notas `notes` (Hz), cada uma com decaimento curto.
func _synth_play(notes: Array, note_dur: float) -> AudioStreamWAV:
	var rate := 22050
	var samples := PackedFloat32Array()
	for f in notes:
		var n := int(note_dur * rate)
		for i in n:
			var t := float(i) / rate
			var env: float = exp(-6.0 * t)
			var v := sin(TAU * float(f) * t) * env
			samples.append(v * 0.7)
	return _make_wav(samples, rate)

## Variações do som de Alimentar (mordidas): tom-base, nº de mordidas e ritmo distintos.
func _build_feed_sounds() -> Array:
	return [
		_synth_feed(190.0, 2, 0.13, 0.06),
		_synth_feed(160.0, 3, 0.10, 0.05),
		_synth_feed(220.0, 2, 0.12, 0.07),
		_synth_feed(140.0, 3, 0.11, 0.05),
	]

## Variações do ronron (Carinho): tons e tremolos diferentes p/ o "rrrr" variar.
func _build_pet_sounds() -> Array:
	return [
		_synth_pet(72.0, 26.0, 0.70),
		_synth_pet(64.0, 22.0, 0.80),
		_synth_pet(80.0, 30.0, 0.60),
		_synth_pet(68.0, 18.0, 0.75),
	]

## Variações do arpejo (Brincar): sequências de notas alegres diferentes.
func _build_play_sounds() -> Array:
	return [
		_synth_play([392.0, 523.0, 659.0, 784.0], 0.12),    # sol-dó-mi-dó agudo
		_synth_play([440.0, 554.0, 659.0, 880.0], 0.12),    # lá-dó#-mi-lá
		_synth_play([523.0, 659.0, 784.0, 1046.0], 0.11),   # dó-mi-sol-dó agudo
		_synth_play([349.0, 440.0, 523.0, 698.0], 0.13),    # fá-lá-dó-fá
	]

# ------------------------------------------------------------------ credenciais
## Caminho do arquivo de credencial de uma automação: user://cred_<key>.json (gitignored).
func _cred_path(key: String) -> String:
	return CRED_PREFIX + key + ".json"

## Chave de criptografia das credenciais, derivada do salt do app + ID único da
## máquina (OS.get_unique_id). Assim o arquivo não fica em texto puro e não vale em
## outro computador. Não é um segredo perfeito (o salt está no código), mas evita a
## leitura casual da App Password no disco.
func _cred_key() -> String:
	var uid := OS.get_unique_id()
	if uid == "":
		uid = "zimmy-fallback"
	return CRED_SALT + ":" + uid

## Lê as credenciais salvas de `key` (ou {} se não houver / inválidas). Lê o arquivo
## **criptografado**; se encontrar um arquivo antigo em texto puro, migra-o (re-grava
## criptografado) para não deixar a senha em claro.
func load_credentials(key: String) -> Dictionary:
	var path := _cred_path(key)
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open_encrypted_with_pass(path, FileAccess.READ, _cred_key())
	if f:
		var txt := f.get_as_text()
		f.close()
		var parsed = JSON.parse_string(txt)
		if parsed is Dictionary and parsed.has("user") and parsed.has("pass"):
			return {"user": str(parsed["user"]), "pass": str(parsed["pass"])}
	# Migração: arquivo antigo em texto puro → recriptografa.
	var legacy = _read_json(path)
	if legacy is Dictionary and legacy.has("user") and legacy.has("pass"):
		var creds := {"user": str(legacy["user"]), "pass": str(legacy["pass"])}
		save_credentials(key, creds)
		return creds
	return {}

## Grava as credenciais de `key` em disco, **criptografadas** (AES via
## open_encrypted_with_pass), em arquivo separado por automação.
func save_credentials(key: String, data: Dictionary) -> void:
	var f := FileAccess.open_encrypted_with_pass(_cred_path(key), FileAccess.WRITE, _cred_key())
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
## `help_steps`/`help_url` (opcionais): passo-a-passo + link exibidos no topo do diálogo
## (ex.: como gerar a App Password) — aparecem na 1ª vez, quando ainda não há credencial.
func with_credentials(key: String, title: String, cb: Callable, help_steps := "", help_url := "") -> void:
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
	cred_dialog.ok_button_text = t("cred_ok")        # reflete o idioma atual
	cred_l1.text = t("cred_email_label")
	cred_l2.text = t("cred_pass_label")
	cred_user_edit.placeholder_text = t("cred_user_ph")
	cred_pass_edit.placeholder_text = t("cred_pass_ph")
	cred_user_edit.text = ""
	cred_pass_edit.text = ""
	# Passo-a-passo opcional no topo (ex.: Gmail). Sem ajuda, some e o diálogo fica compacto.
	cred_help.text = help_steps
	cred_help.visible = help_steps != ""
	cred_help_url = help_url
	cred_link.text = t("cred_open_page")
	cred_link.visible = help_url != ""
	var scr := DisplayServer.screen_get_usable_rect()
	cred_dialog.size = Vector2i(380, 260) if help_steps != "" else Vector2i(360, 170)
	cred_dialog.reset_size()
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
	cred_dialog.ok_button_text = t("cred_ok")
	cred_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	# Passo-a-passo (ex.: como gerar a App Password) — exibido no topo quando há ajuda.
	cred_help = Label.new()
	cred_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cred_help.custom_minimum_size = Vector2(360, 0)
	cred_help.visible = false
	cred_link = LinkButton.new()
	cred_link.visible = false
	cred_link.pressed.connect(func(): if cred_help_url != "": OS.shell_open(cred_help_url))
	cred_l1 = Label.new(); cred_l1.text = t("cred_email_label")
	cred_user_edit = LineEdit.new()
	cred_user_edit.custom_minimum_size = Vector2(320, 0)
	cred_user_edit.placeholder_text = t("cred_user_ph")
	cred_l2 = Label.new(); cred_l2.text = t("cred_pass_label")
	cred_pass_edit = LineEdit.new()
	cred_pass_edit.secret = true
	cred_pass_edit.placeholder_text = t("cred_pass_ph")
	box.add_child(cred_help); box.add_child(cred_link)
	box.add_child(cred_l1); box.add_child(cred_user_edit)
	box.add_child(cred_l2); box.add_child(cred_pass_edit)
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
		say(t("login_incomplete"))
		return
	if cb.is_valid():
		cb.call({"user": u, "pass": p})

func _on_cred_canceled() -> void:
	if cred_pending_key != "":
		cred_prompt_suppressed[cred_pending_key] = true   # não insistir até religar/clicar
	cred_pending_key = ""
	cred_pending_cb = Callable()

func _build_save_dialog() -> void:
	save_dialog = ConfirmationDialog.new()
	save_dialog.ok_button_text = t("btn_save")
	save_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	name_edit = LineEdit.new()
	name_edit.custom_minimum_size = Vector2(240, 0)
	save_dialog.add_child(name_edit)
	save_dialog.register_text_enter(name_edit)
	save_dialog.confirmed.connect(_on_save_confirmed)
	add_child(save_dialog)

## Diálogo de confirmação de exclusão (compartilhado por pets e acessórios).
func _build_delete_dialog() -> void:
	delete_dialog = ConfirmationDialog.new()
	delete_dialog.title = t("delete_title")
	delete_dialog.ok_button_text = t("btn_delete")
	delete_dialog.cancel_button_text = t("btn_cancel")
	delete_dialog.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	delete_dialog.confirmed.connect(_on_delete_confirmed)
	add_child(delete_dialog)

func _on_menu(id: int) -> void:
	match id:
		MI_FEED: feed()
		MI_PET: pet()
		MI_PLAY: play()
		MI_RANDOM: _set_random_pet(not random_pet_on)
		MI_RANDOM_ACC: _set_random_acc(not random_acc_on)
		MI_SHOW_ACC: _set_show_accessories(not show_accessories)
		MI_STATUS: _set_show_status(not show_status)
		MI_SAVE_PET: _open_save_dialog("pet", "rename" if saved_pets.has(current_pet_name) else "save")
		MI_SAVE_ACC: _open_save_dialog("acc", "rename" if saved_accessories.has(current_acc_name) else "save")
		MI_QUIT: get_tree().quit()

func _on_pick_pet(id: int) -> void:
	if id == 0:
		return                     # "Selecione..." é apenas um rótulo
	_set_random_pet(false)         # escolher um pet específico desliga o aleatório de pet
	if id == 1:
		current = _default_cfg()
		current_pet_name = "Default"
		say(t("say_default"))
	elif pet_menu_ids.has(id):
		current = (saved_pets[pet_menu_ids[id]] as Dictionary).duplicate(true)
		current_pet_name = String(pet_menu_ids[id])
		say("%s ✨" % pet_menu_ids[id])
	suggested_pet_name = ""        # escolha explícita: sem sugestão de nome gerado
	_refresh_pets_menu_checks()
	play_action_anim("choose")
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
		say(t("say_no_acc"))
	elif acc_menu_ids.has(id):
		current_acc = (saved_accessories[acc_menu_ids[id]] as Dictionary).duplicate(true)
		current_acc_name = String(acc_menu_ids[id])
		say("%s 🎀" % acc_menu_ids[id])
	suggested_acc_name = ""        # escolha explícita: sem sugestão de nome gerado
	_refresh_acc_menu_checks()
	play_action_anim("choose")
	_save_settings()   # persiste a escolha para a próxima abertura
	queue_redraw()

## Excluir pet/acessório — abre a confirmação; só itens salvos chegam aqui
## (Default/Nenhum/Selecione nunca aparecem nos submenus de exclusão).
func _on_del_pet(id: int) -> void:
	if pet_del_ids.has(id):
		_open_delete_dialog("pet", String(pet_del_ids[id]))

func _on_del_acc(id: int) -> void:
	if acc_del_ids.has(id):
		_open_delete_dialog("acc", String(acc_del_ids[id]))

func _open_delete_dialog(mode: String, nm: String) -> void:
	delete_mode = mode
	delete_name = nm
	var tipo := t("kind_pet") if mode == "pet" else t("kind_acc")
	delete_dialog.title = t("delete_title")
	delete_dialog.ok_button_text = t("btn_delete")
	delete_dialog.cancel_button_text = t("btn_cancel")
	delete_dialog.dialog_text = t("delete_confirm") % [tipo, nm]
	var scr := DisplayServer.screen_get_usable_rect()
	delete_dialog.reset_size()
	delete_dialog.position = scr.position + (scr.size - delete_dialog.size) / 2
	delete_dialog.popup()

func _on_delete_confirmed() -> void:
	if delete_mode == "pet":
		if not saved_pets.has(delete_name):
			return
		saved_pets.erase(delete_name)
		_save_pets_to_disk()
		# Ao excluir um pet, recarrega sempre o Default.
		_set_random_pet(false)
		current = _default_cfg()
		current_pet_name = "Default"
		_save_settings()
		queue_redraw()
		_relayout()
		_rebuild_pets_menu()
		play_action_anim("sad")
		say(t("pet_deleted") % delete_name)
	else:
		if not saved_accessories.has(delete_name):
			return
		saved_accessories.erase(delete_name)
		_save_accessories_to_disk()
		# Ao excluir um acessório, recarrega sempre o Default (Nenhum).
		_set_random_acc(false)
		current_acc = _default_acc()
		current_acc_name = "Nenhum"
		_save_settings()
		queue_redraw()
		_rebuild_acc_menu()
		play_action_anim("sad")
		say(t("acc_deleted") % delete_name)

func _set_random_pet(on: bool) -> void:
	random_pet_on = on
	menu.set_item_checked(menu.get_item_index(MI_RANDOM), on)
	random_timer = 0.0            # mesmo temporizador de pets e acessórios
	if on:
		_generate_pet()

func _set_random_acc(on: bool) -> void:
	random_acc_on = on
	menu.set_item_checked(menu.get_item_index(MI_RANDOM_ACC), on)
	random_timer = 0.0            # mesmo temporizador de pets e acessórios
	if on:
		_set_show_accessories(true)   # gerar acessórios também liga a exibição
		_generate_acc()

## Gera um pet aleatório, sorteia um nome sugestivo e dá as boas-vindas com ele.
## O nome fica guardado p/ pré-preencher o diálogo de salvar.
func _generate_pet() -> void:
	current = _random_cfg()
	current_pet_name = ""              # pet aleatório não corresponde a nenhuma opção salva
	suggested_pet_name = _suggest_name("pet")
	_refresh_pets_menu_checks()
	say(t("welcome_pet") % suggested_pet_name)
	play_action_anim("newpet")
	queue_redraw()
	_relayout()

## Gera um acessório aleatório, sorteia um nome sugestivo e parabeniza com ele.
func _generate_acc() -> void:
	current_acc = _random_acc()
	current_acc_name = ""             # acessório aleatório não corresponde a nenhuma opção salva
	suggested_acc_name = _suggest_name("acc")
	_refresh_acc_menu_checks()
	say(t("congrats_acc") % suggested_acc_name)
	play_action_anim("newacc")
	queue_redraw()

## Monta um nome sugestivo combinando substantivo + adjetivo dos bancos do idioma
## (`<kind>_nouns` / `<kind>_adjs`, kind = "pet"/"acc"). ~900 combinações por categoria,
## então quase nunca repete. Ordem: pt = "Substantivo Adjetivo"; en = "Adjective Noun".
func _suggest_name(kind: String) -> String:
	var nouns := ta(kind + "_nouns")
	if nouns.is_empty():
		return ""
	var noun := String(nouns.pick_random())
	var adjs := ta(kind + "_adjs")
	if adjs.is_empty():
		return noun
	var adj := String(adjs.pick_random())
	return ("%s %s" % [adj, noun]) if lang == "en" else ("%s %s" % [noun, adj])

func _set_show_accessories(on: bool) -> void:
	show_accessories = on
	menu.set_item_checked(menu.get_item_index(MI_SHOW_ACC), on)
	_save_settings()   # persiste o estado de exibição de acessórios
	queue_redraw()

func _set_show_status(on: bool) -> void:
	show_status = on
	menu.set_item_checked(menu.get_item_index(MI_STATUS), on)
	_save_settings()   # persiste o estado de exibição das barras
	_relayout()        # adiciona/remove o rodapé das barras
	queue_redraw()

func _open_save_dialog(mode: String, action := "save") -> void:
	save_mode = mode
	save_action = action
	var is_pet := mode == "pet"
	if action == "rename":
		# Renomear um item já salvo: pré-preenche o nome atual para edição.
		var atual := current_pet_name if is_pet else current_acc_name
		save_dialog.title = t("rename_pet_title") if is_pet else t("rename_acc_title")
		save_dialog.get_label().text = t("newname_pet_label") if is_pet else t("newname_acc_label")
		save_dialog.ok_button_text = t("btn_rename")
		name_edit.text = atual
		name_edit.select_all()
	else:
		# Salvar novo: congela a geração automática **do item sendo salvo** para gravar
		# exatamente o que está na tela (o outro tipo continua como estava).
		if is_pet:
			_set_random_pet(false)
		else:
			_set_random_acc(false)
		save_dialog.title = t("save_pet_title") if is_pet else t("save_acc_title")
		save_dialog.get_label().text = t("name_pet_label") if is_pet else t("name_acc_label")
		save_dialog.ok_button_text = t("btn_save")
		name_edit.placeholder_text = t("ph_pet") if is_pet else t("ph_acc")
		# Pré-preenche o nome sugerido do item gerado (selecionado, fácil de trocar).
		var sug := suggested_pet_name if is_pet else suggested_acc_name
		name_edit.text = sug
		if sug != "":
			name_edit.select_all()
	var scr := DisplayServer.screen_get_usable_rect()
	save_dialog.size = Vector2i(320, 150)
	save_dialog.position = scr.position + (scr.size - save_dialog.size) / 2
	save_dialog.popup()
	name_edit.grab_focus()

func _on_save_confirmed() -> void:
	var nm := name_edit.text.strip_edges()
	if nm == "" or nm == "Default" or nm == "Selecione..." or nm == "Nenhum":
		say(t("name_invalid"))
		return
	if save_action == "rename":
		_do_rename(nm)
		return
	if save_mode == "pet":
		_set_random_pet(false)         # ao confirmar, desmarca "Gerar pets"
		saved_pets[nm] = current.duplicate(true)
		current_pet_name = nm          # o pet recém-salvo passa a ser o ativo (vira "Renomear")
		_save_pets_to_disk()
		_rebuild_pets_menu()
		_save_settings()
		play_action_anim("save")
		say(t("pet_saved") % nm)
	else:
		_set_random_acc(false)         # ao confirmar, desmarca "Gerar acessórios"
		saved_accessories[nm] = current_acc.duplicate(true)
		current_acc_name = nm          # idem para o acessório
		_save_accessories_to_disk()
		_rebuild_acc_menu()
		_save_settings()
		play_action_anim("save")
		say(t("acc_saved") % nm)

## Renomeia o item salvo atualmente ativo, preservando a ordem no dropdown e
## persistindo a mudança em disco + settings.json.
func _do_rename(new_name: String) -> void:
	if save_mode == "pet":
		var old_name := current_pet_name
		if not saved_pets.has(old_name):
			return
		if new_name == old_name:
			say(t("name_kept"))
			return
		if saved_pets.has(new_name):
			say(t("pet_exists"))
			return
		saved_pets = _rename_key(saved_pets, old_name, new_name)
		current_pet_name = new_name
		_save_pets_to_disk()
		_rebuild_pets_menu()
		_save_settings()
		say(t("pet_renamed") % new_name)
	else:
		var old_name := current_acc_name
		if not saved_accessories.has(old_name):
			return
		if new_name == old_name:
			say(t("name_kept"))
			return
		if saved_accessories.has(new_name):
			say(t("acc_exists"))
			return
		saved_accessories = _rename_key(saved_accessories, old_name, new_name)
		current_acc_name = new_name
		_save_accessories_to_disk()
		_rebuild_acc_menu()
		_save_settings()
		say(t("acc_renamed") % new_name)

## Renomeia uma chave de Dictionary preservando a ordem de inserção (o dropdown
## não embaralha ao renomear).
func _rename_key(store: Dictionary, old_name: String, new_name: String) -> Dictionary:
	var out := {}
	for k in store:
		out[new_name if k == old_name else k] = store[k]
	return out

## Ajusta os rótulos: vira "Renomear" (mesmo ícone) quando o item exibido já está
## salvo; senão fica "Salvar". Chamado antes de abrir o menu.
func _refresh_save_labels() -> void:
	var pet_saved := saved_pets.has(current_pet_name)
	menu.set_item_text(menu.get_item_index(MI_SAVE_PET),
		t("mi_rename_pet") if pet_saved else t("mi_save_pet"))
	var acc_saved := saved_accessories.has(current_acc_name)
	menu.set_item_text(menu.get_item_index(MI_SAVE_ACC),
		t("mi_rename_acc") if acc_saved else t("mi_save_acc"))

## Reposiciona um submenu à ESQUERDA do seu pai quando a cascata está indo para a esquerda
## (`_cascade_left`). Os submenus do Godot abrem à direita do pai; aqui, no `about_to_popup`,
## sobrescrevemos só o X (mantendo o Y que o Godot alinhou ao item) para o lado esquerdo.
func _flip_submenu_if_left(sub: PopupMenu) -> void:
	if not _cascade_left:
		return
	var parent: PopupMenu = _submenu_parent.get(sub, null)
	if parent == null:
		return
	var new_x := parent.position.x - sub.size.x
	var scr := DisplayServer.screen_get_usable_rect()
	if new_x >= scr.position.x:
		sub.position = Vector2i(new_x, sub.position.y)

## Escolhe a posição do menu de contexto ao lado do pet, mantendo-o PERTO do pet e
## garantindo espaço para a cascata de submenus (menu + 2 níveis). Como os submenus do
## Godot abrem para a direita, decidimos aqui a direção da cascata:
##  1) pet à esquerda/centro com espaço à direita → menu à direita do pet, cascata p/ direita;
##  2) sem espaço à direita, mas com espaço à esquerda → menu à esquerda do pet, cascata p/
##     a ESQUERDA (`_cascade_left`, via `_flip_submenu_if_left`) — assim o menu fica colado
##     no pet mesmo quando ele está na direita da tela;
##  3) nenhum dos dois (tela estreita) → recua p/ a direita o necessário (melhor esforço).
func _context_menu_position(menu_size: Vector2i) -> Vector2i:
	var scr := DisplayServer.screen_get_usable_rect()
	var scr_right := scr.position.x + scr.size.x
	var scr_bottom := scr.position.y + scr.size.y
	# Retângulo real do pet na tela (dentro da janela, ignorando a faixa transparente).
	var win_pos := get_window().position
	var pet_rect := Rect2i(win_pos + Vector2i(int(pet_x), int(pet_y)),
		Vector2i(PET_DRAW, PET_DRAW))
	var gap := 8
	var lvl := maxi(menu_size.x, 300)            # largura estimada por nível de submenu
	var cascade := 2 * lvl                        # espaço dos 2 níveis de submenu além do menu
	var rx := pet_rect.end.x + gap                # menu à direita do pet
	var lx := pet_rect.position.x - gap - menu_size.x  # menu à esquerda do pet
	var x: int
	if rx + menu_size.x + cascade <= scr_right:           # 1) cascata p/ a direita cabe
		_cascade_left = false
		x = rx
	elif lx - cascade >= scr.position.x:                  # 2) cascata p/ a esquerda cabe
		_cascade_left = true
		x = lx
	else:                                                 # 3) melhor esforço: recua à direita
		_cascade_left = false
		x = scr_right - (menu_size.x + cascade)
	x = clampi(x, scr.position.x, scr_right - menu_size.x)
	# Y ao lado do pet; se nessa posição o menu cobrir o pet, desce (ou sobe).
	var y := pet_rect.position.y
	if Rect2i(Vector2i(x, y), menu_size).intersects(pet_rect):
		if pet_rect.end.y + gap + menu_size.y <= scr_bottom:
			y = pet_rect.end.y + gap
		elif pet_rect.position.y - gap - menu_size.y >= scr.position.y:
			y = pet_rect.position.y - gap - menu_size.y
	y = clampi(y, scr.position.y, scr_bottom - menu_size.y)
	return Vector2i(x, y)

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
			"show_acc": show_accessories, "lang": lang, "status": show_status,
			"wa_sound": whatsapp_sound_on, "gmail_sound": gmail_sound_on,
			"feed_sound": sound_feed_on, "pet_sound": sound_pet_on, "play_sound": sound_play_on,
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
	if parsed.has("lang"):
		lang = "en" if String(parsed["lang"]) == "en" else "pt"
	if parsed.has("show_acc"):
		show_accessories = bool(parsed["show_acc"])
	if parsed.has("status"):
		show_status = bool(parsed["status"])
	if parsed.has("wa_sound"):
		whatsapp_sound_on = bool(parsed["wa_sound"])
	if parsed.has("gmail_sound"):
		gmail_sound_on = bool(parsed["gmail_sound"])
	if parsed.has("feed_sound"):
		sound_feed_on = bool(parsed["feed_sound"])
	if parsed.has("pet_sound"):
		sound_pet_on = bool(parsed["pet_sound"])
	if parsed.has("play_sound"):
		sound_play_on = bool(parsed["play_sound"])
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
	# Janela pós-ação do usuário (notificações resultantes furam a fila).
	if urgent_cd > 0.0:
		urgent_cd -= delta

	# Trava de repetições: após REPEAT_RESET (30s) sem nova ação aceita, zera a
	# contagem para a mesma ação voltar a funcionar (e recontar até 3).
	if repeat_reset_cd > 0.0:
		repeat_reset_cd -= delta
		if repeat_reset_cd <= 0.0:
			action_repeats = 0
			last_action = ""

	# Necessidades: a cada STAT_DECAY_PERIOD (30 min) cada barra perde 1 ponto. Quando
	# as TRÊS chegam a zero, o Zimmy fecha a janela e encerra o processo.
	stat_decay_timer += delta
	if stat_decay_timer >= STAT_DECAY_PERIOD:
		stat_decay_timer = 0.0
		var before_feed := stat_feed
		var before_pet := stat_pet
		var before_play := stat_play
		stat_feed = maxf(stat_feed - 1.0, 0.0)
		stat_pet = maxf(stat_pet - 1.0, 0.0)
		stat_play = maxf(stat_play - 1.0, 0.0)
		# Alerta sonoro só na TRANSIÇÃO para baixo de STAT_LOW (não a cada ciclo abaixo dele).
		if sound_feed_on and before_feed > STAT_LOW and stat_feed <= STAT_LOW:
			_play_group(_feed_player, _feed_variants)
		if sound_pet_on and before_pet > STAT_LOW and stat_pet <= STAT_LOW:
			_play_group(_pet_player, _pet_variants)
		if sound_play_on and before_play > STAT_LOW and stat_play <= STAT_LOW:
			_play_group(_play_player, _play_variants)
		if stat_feed <= 0.0 and stat_pet <= 0.0 and stat_play <= 0.0:
			get_tree().quit()

	# Pulinho com "gravidade".
	y_off += vy * delta
	vy += 900.0 * delta
	if y_off > 0.0:
		y_off = 0.0
		vy = 0.0

	# Multi-hop: ao aterrissar, dispara o próximo pulo da sequência (se houver).
	if hop_queue > 0 and y_off == 0.0 and vy == 0.0:
		hop_queue -= 1
		vy = -hop_queue_force

	# Avanço da animação de reação (rotação/escala/balanço); encerra ao fim.
	if anim != "":
		anim_t += delta
		if anim_t >= anim_dur:
			anim = ""

	# Fogos de artifício da comemoração (só processa quando há algo ativo).
	if fw_time > 0.0 or not fw_particles.is_empty():
		_update_fireworks(delta)

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

	# --- Reações ao cursor: expressão temporária, hover, sacudida e clique no olho ---
	if react_expr_t > 0.0:
		react_expr_t -= delta
		if react_expr_t <= 0.0:
			react_expr = ""
	if shake_cd > 0.0:
		shake_cd -= delta

	var win_pos := get_window().position
	var pet_rect := Rect2i(win_pos + Vector2i(int(pet_x), int(pet_y)),
		Vector2i(PET_DRAW, PET_DRAW))
	var over_pet := pet_rect.has_point(gm)

	# Hover: ao ENTRAR sobre o pet (sem arrastar/sem fala) ele reage com uma expressão.
	# Enquanto o cursor fica parado por cima, a reação some e o rosto volta ao normal.
	if over_pet and not dragging and speech.text == "":
		if not hovering:
			hovering = true
			if react_expr == "":
				_show_react(HOVER_EXPRS.pick_random(), 1.1)
	else:
		hovering = false

	# Sacudida: reversões rápidas de direção do mouse perto do pet → tontura/enjoo/susto.
	var mdelta := gm - _last_mouse
	_last_mouse = gm
	if _shake_window > 0.0:
		_shake_window -= delta
		if _shake_window <= 0.0:
			_shake_count = 0
			_shake_dir = 0
	if d.length() < SHAKE_RADIUS and absi(mdelta.x) > SHAKE_MIN_SPEED:
		var sdir := signi(mdelta.x)
		if sdir != 0 and _shake_dir != 0 and sdir != _shake_dir:
			_shake_count += 1
			_shake_window = SHAKE_WINDOW
			if _shake_count >= SHAKE_REVERSALS and shake_cd <= 0.0:
				_trigger_shake()
		_shake_dir = sdir

	# Olho fechado no clique: reabre assim que o cursor sai de cima daquele olho.
	if eye_closed_l or eye_closed_r:
		var over_eye := _mouse_over_eye_local(Vector2(gm - win_pos))
		if eye_closed_l and over_eye != 1:
			eye_closed_l = false
		if eye_closed_r and over_eye != 2:
			eye_closed_r = false

	# Geração aleatória contínua: um único temporizador para pets e acessórios — quando
	# ambos estão ligados, trocam JUNTOS no mesmo tique de RANDOM_PERIOD.
	if random_pet_on or random_acc_on:
		random_timer += delta
		if random_timer >= RANDOM_PERIOD:
			random_timer = 0.0
			if random_pet_on:
				_generate_pet()
			if random_acc_on:
				_generate_acc()

	# Automações agendadas (auto-alimentar, lembretes, comemorações...).
	if not schedule_defs.is_empty():
		_tick_schedules(delta)

	# Lembretes recorrentes criados pelo usuário (⏰ Lembretes).
	if not reminders.is_empty():
		_tick_reminders(delta)

	# Necessidades com o tempo.
	hunger = clampf(hunger + delta * 0.7, 0.0, 100.0)
	if hunger > 70.0:
		happy = clampf(happy - delta * 0.5, 0.0, 100.0)

	# Envelhece a fila e descarta o que esperou demais (> MAX_QUEUE_WAIT, 60s): mensagens
	# antigas já não são relevantes e não devem "ressuscitar" muito depois.
	if not msg_queue.is_empty():
		var kept: Array = []
		for it in msg_queue:
			it["wait"] += delta
			if it["wait"] <= MAX_QUEUE_WAIT:
				kept.append(it)
		msg_queue = kept

	# Falas: reações (say) têm prioridade e aparecem na hora; notificações (notify) entram
	# numa fila de 10s cada e PAUSAM enquanto uma reação está no ar (assim veem os 10s
	# cheios e não se perdem). Prioridade no balão: reação > notificação > nada.
	if react_hold > 0.0:
		react_hold -= delta
		if react_hold <= 0.0:
			react_text = ""
	if react_hold <= 0.0:
		if notify_hold > 0.0:
			notify_hold -= delta          # só corre quando não há reação por cima
			if notify_hold <= 0.0:
				notify_text = ""
		if notify_hold <= 0.0 and not msg_queue.is_empty():
			notify_text = String(msg_queue.pop_front()["text"])
			notify_hold = MSG_DURATION
	var shown := react_text if react_hold > 0.0 else (notify_text if notify_hold > 0.0 else "")
	if shown != speech.text:
		speech.text = shown
		expression = _expression_from_text(shown) if shown != "" else "neutral"
		_relayout()

	queue_redraw()

# ----------------------------------------------------- layout dinâmico da janela
## Redimensiona a janela para caber a fala atual e mantém o pet ancorado.
func _relayout() -> void:
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

	# Rodapé extra abaixo do pet para as barras de status (só quando ligado). O pet
	# continua ancorado pelo seu centro-inferior; o rodapé "cresce para baixo".
	var pet_bottom := top_space + float(PET_DRAW)
	var footer := STATUS_FOOTER if show_status else 0.0
	win_h = int(pet_bottom + footer)
	pet_x = (float(win_w) - float(PET_DRAW)) * 0.5
	pet_y = top_space

	# O balão fica logo acima do corpo do pet (e o headroom do pulo sobra por cima).
	speech.position = Vector2(SPEECH_PAD_X, pet_y - SPEECH_GAP - band)
	speech.size = Vector2(float(win_w) - 2.0 * SPEECH_PAD_X, band)

	get_window().size = Vector2i(win_w, win_h)
	# `anchor` = centro-inferior do PET. A posição na tela vem SÓ da âncora, sem reclampar
	# pelo tamanho da janela: assim uma fala grande que excede a janela NÃO desloca o pet —
	# o balão pode transbordar a borda da tela, mas o pet fica fixo. (A âncora já é mantida
	# dentro da tela ao arrastar/carregar; as animações de pulo continuam normais.)
	get_window().position = anchor - Vector2i(int(win_w / 2.0), int(pet_bottom))
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

	# Geometria da silhueta — calculada cedo para as camadas traseiras (asas/rabo/
	# patas) e as do topo (chifre/topete) se posicionarem em relação ao corpo.
	var bw_mul := 1.0
	var bh_mul := 1.0
	var by := 0.0
	match c.get("body_shape", "round"):
		"tall":   bw_mul = 0.9;  bh_mul = 1.2;  by = -3.0  # ovinho em pé
		"wide":   bw_mul = 1.16; bh_mul = 0.86; by = 3.0   # baixinho fofo
		"pear":   bw_mul = 0.96; bh_mul = 1.02; by = 0.0   # gota (bojo embaixo)
		"chubby": bw_mul = 1.25; bh_mul = 0.95; by = 2.0   # gorduchinho
		"slim":   bw_mul = 0.8;  bh_mul = 1.12; by = -2.0  # esguio
		_:        pass                                      # round (padrão)
	var bw := body_w * bw_mul
	var bh := body_h * bh_mul * (1.0 + br)
	var head_top := 108.0 + by - bh                        # topo do "crânio"

	# Sombra (fica no chão, encolhe quando ele pula) — desenhada com a transform base,
	# ANTES da transform animada, para não rodar/escalar junto com o corpo.
	var sh := 1.0 + y_off * 0.0035               # y_off é negativo no ar
	_ellipse(Vector2(100, 178), Vector2(46.0 * sh, 7.0), Color(0, 0, 0, 0.10))

	# Transform da animação de reação: rotação/escala/balanço em torno de um pivô
	# (pés ou centro). Em repouso (anim == "") é a identidade — nada muda.
	if anim != "":
		var p := clampf(anim_t / anim_dur, 0.0, 1.0)
		var a_rot := 0.0
		var a_sx := 1.0
		var a_sy := 1.0
		var a_dx := 0.0
		var pivot := Vector2(100.0, 150.0)
		match anim:
			"spin", "spin_jump":
				a_rot = TAU * p; pivot = Vector2(100.0, 110.0)
			"backflip":
				a_rot = -TAU * p; pivot = Vector2(100.0, 110.0)
			"wiggle":
				a_dx = sin(p * TAU * 2.0) * 10.0; a_rot = sin(p * TAU * 2.0) * 0.18
				pivot = Vector2(100.0, 160.0)
			"dance":
				a_dx = sin(p * TAU * 2.0) * 12.0; a_rot = sin(p * TAU * 2.0) * 0.22
				pivot = Vector2(100.0, 160.0)
			"tilt":
				a_rot = sin(p * PI) * 0.35; pivot = Vector2(100.0, 160.0)
			"nod":
				a_sy = 1.0 - sin(p * PI) * 0.18; a_sx = 1.0 + sin(p * PI) * 0.12
				pivot = Vector2(100.0, 162.0)
			"squish":
				a_sy = 1.0 - sin(p * PI) * 0.28; a_sx = 1.0 + sin(p * PI) * 0.22
				pivot = Vector2(100.0, 162.0)
			"dizzy":   # cambaleia: rotação oscilante ampla + vai-e-vem lento
				a_rot = sin(p * TAU * 2.5) * 0.42; a_dx = sin(p * TAU * 1.5) * 9.0
				pivot = Vector2(100.0, 160.0)
			"nausea":   # enjoo: balanço lento + "engulo" (squish vertical pulsante)
				a_dx = sin(p * TAU * 1.5) * 8.0
				a_sy = 1.0 - sin(p * TAU * 3.0) * 0.10; a_sx = 1.0 + sin(p * TAU * 3.0) * 0.06
				a_rot = sin(p * TAU * 1.5) * 0.12; pivot = Vector2(100.0, 162.0)
			"scared":   # susto: tremor rápido (jitter) + encolhida
				a_dx = sin(p * TAU * 15.0) * 5.0; a_rot = sin(p * TAU * 17.0) * 0.06
				a_sy = 1.0 - sin(p * PI) * 0.12; pivot = Vector2(100.0, 150.0)
		var base := Transform2D(0.0, Vector2(pet_x, pet_y))
		base.x *= PET_SCALE
		base.y *= PET_SCALE
		var rs := Transform2D(a_rot, Vector2.ZERO)
		rs.x *= a_sx
		rs.y *= a_sy
		var about := Transform2D(0.0, Vector2(a_dx, 0.0) + pivot) * rs * Transform2D(0.0, -pivot)
		draw_set_transform_matrix(base * about)

	# Asas e rabo (camadas mais atrás, por trás do corpo).
	if c.get("wings", "none") != "none":
		_draw_wings(o, bw, by, belly_color)
	if c.get("tail", "none") != "none":
		_draw_tail(c.get("tail"), o, bw, bh, by, ear_color)

	# Antenas (atrás do corpo).
	if c.get("has_antennae", false):
		var antenna_color: Color = c.get("antenna_color", ear_color)
		_draw_antenna(Vector2(100.0 - 12.0, ear_y - 2.0) + o, Vector2(100.0 - 26.0, ear_y - 30.0) + o, antenna_color)
		_draw_antenna(Vector2(100.0 + 12.0, ear_y - 2.0) + o, Vector2(100.0 + 26.0, ear_y - 30.0) + o, antenna_color)

	# Orelhas (redondas, pontudas ou caídas), se houver.
	if c.get("has_ears", true):
		match c.get("ear_shape", "round"):
			"pointy":
				_triangle(Vector2(100.0 - ear_dx - ear_w, ear_y + ear_h) + o,
					Vector2(100.0 - ear_dx + ear_w, ear_y + ear_h) + o,
					Vector2(100.0 - ear_dx, ear_y - ear_h) + o, ear_color)
				_triangle(Vector2(100.0 + ear_dx - ear_w, ear_y + ear_h) + o,
					Vector2(100.0 + ear_dx + ear_w, ear_y + ear_h) + o,
					Vector2(100.0 + ear_dx, ear_y - ear_h) + o, ear_color)
			"floppy":   # orelhas caídas (elipses alongadas, deslocadas p/ baixo e p/ fora)
				_ellipse(Vector2(100.0 - ear_dx - 2.0, ear_y + ear_h * 0.5) + o, Vector2(ear_w * 0.8, ear_h * 1.15), ear_color)
				_ellipse(Vector2(100.0 + ear_dx + 2.0, ear_y + ear_h * 0.5) + o, Vector2(ear_w * 0.8, ear_h * 1.15), ear_color)
			_:          # round
				_ellipse(Vector2(100.0 - ear_dx, ear_y) + o, Vector2(ear_w, ear_h), ear_color)
				_ellipse(Vector2(100.0 + ear_dx, ear_y) + o, Vector2(ear_w, ear_h), ear_color)

	# Patas (atrás da base do corpo, p/ o corpo cobrir o topo delas).
	if c.get("feet", "none") != "none":
		_draw_feet(o, bw, bh, by, body_color)

	# Corpo + barriga (respiram). A silhueta usa bw/bh/by calculados acima; "pear"
	# desenha um bojo inferior extra (corpo em gota).
	if c.get("body_shape", "round") == "pear":
		_ellipse(Vector2(100, 122 + by) + o, Vector2(bw * 1.18, bh * 0.6), body_color)  # bojo inferior
	_ellipse(Vector2(100, 108 + by) + o, Vector2(bw, bh), body_color)
	_ellipse(Vector2(100, 118 + by * 0.5) + o, Vector2(belly_w * bw_mul, belly_h * bh_mul * (1.0 + br)), belly_color)

	# Padrão no corpo (manchas ou listras), por cima do corpo e por baixo do rosto.
	if c.get("body_pattern", "none") != "none":
		_draw_body_pattern(c.get("body_pattern"), o, bw, bh, by, ear_color)

	# Focinho: um remendo mais claro ao redor da boca/nariz.
	if c.get("muzzle", "none") != "none":
		_ellipse(Vector2(100, 117) + o, Vector2(16, 11), belly_color.lightened(0.08))

	# Bracinhos nas laterais do corpo.
	if c.get("arms", "none") != "none":
		_draw_arms(o, bw, by, body_color)

	# Chifre e topete (no alto da cabeça, por cima do corpo).
	if c.get("horn", "none") != "none":
		_draw_horns(c.get("horn"), o, head_top, c.get("horn_color", ear_color))
	if c.get("hair_tuft", "none") != "none":
		_draw_hair(c.get("hair_tuft"), o, head_top, ear_color)

	# Marca na barriga.
	if c.get("belly_mark", "none") != "none":
		_draw_belly_mark(c.get("belly_mark"), o, by, ear_color, cheek_color)

	# Bochechas.
	if c.get("has_cheeks", true):
		_ellipse(Vector2(70, 116) + o, Vector2(7, 4), cheek_color)
		_ellipse(Vector2(130, 116) + o, Vector2(7, 4), cheek_color)

	# Sardas (pontinhos sob os olhos).
	if c.get("freckles", "none") != "none":
		_draw_freckles(o, ear_color)

	# Nariz (entre/abaixo dos olhos).
	if c.get("has_nose", false):
		var nose_color: Color = c.get("nose_color", INK)
		var ny := eye_y + 9.0
		_triangle(Vector2(100, ny + 3.0) + o, Vector2(96, ny - 2.0) + o, Vector2(104, ny - 2.0) + o, nose_color)

	# Bigodes (ao lado do focinho).
	if c.get("whiskers", "none") != "none":
		_draw_whiskers(c.get("whiskers"), o)

	# Olhos / boca. Prioridade: reação (hover/sacudida) > fala com emoji emotivo >
	# necessidade zerada > rosto padrão (olhos seguindo o cursor + boca do config).
	var lx := 100.0 - eye_dx
	var rx := 100.0 + eye_dx
	var expr := "neutral"
	if react_expr != "":
		expr = react_expr
	elif speech.text != "":
		expr = expression
	else:
		expr = _need_expression()
	if expr != "neutral":
		_draw_expression(expr, lx, rx, eye_y, eye_w, eye_h, o)
	else:
		# Formato do olho ajusta as proporções do branco do olho.
		var ew_eff := eye_w
		var eh_eff := eye_h
		match c.get("eye_shape", "round"):
			"oval":   ew_eff = eye_w * 1.18; eh_eff = eye_h * 0.82
			"tall":   eh_eff = eye_h * 1.3
			"sleepy": eh_eff = eye_h * 0.55
			_:        pass
		if blink_t > 0.0:
			_ellipse(Vector2(lx, eye_y) + o, Vector2(ew_eff, 2), Color.WHITE)
			_ellipse(Vector2(rx, eye_y) + o, Vector2(ew_eff, 2), Color.WHITE)
		else:
			# Cada olho pode estar fechado por clique (arco ∪) ou aberto (branco + pupila).
			var pstyle: String = c.get("pupil_style", "round")
			if eye_closed_l:
				draw_arc(Vector2(lx, eye_y) + o, ew_eff, 0.15, PI - 0.15, 10, INK, 2.2, true)
			else:
				_ellipse(Vector2(lx, eye_y) + o, Vector2(ew_eff, eh_eff), Color.WHITE)
			if eye_closed_r:
				draw_arc(Vector2(rx, eye_y) + o, ew_eff, 0.15, PI - 0.15, 10, INK, 2.2, true)
			else:
				_ellipse(Vector2(rx, eye_y) + o, Vector2(ew_eff, eh_eff), Color.WHITE)
			if not eye_closed_l:
				_draw_pupil(Vector2(lx, eye_y) + o, pstyle)
			if not eye_closed_r:
				_draw_pupil(Vector2(rx, eye_y) + o, pstyle)
			# Sobrancelhas (só no rosto neutro de olhos abertos).
			if c.get("eyebrow", "none") != "none":
				_draw_eyebrows(c.get("eyebrow"), lx, rx, eye_y, eh_eff, o)

		# Cílios.
		if c.get("has_eyelashes", false):
			_draw_eyelashes(Vector2(lx, eye_y) + o, ew_eff, eh_eff, -1.0)
			_draw_eyelashes(Vector2(rx, eye_y) + o, ew_eff, eh_eff, 1.0)

		# Boca (estilo configurável).
		_draw_mouth(c.get("mouth_style", "smile"), o)

	# Acessórios (camada por cima, controlada pela checkbox).
	if show_accessories:
		_draw_accessories(o, eye_dx, eye_y, eye_w)

	# Barras de necessidade (no rodapé — fixas, não acompanham o pulo). Só com Status ligado.
	if show_status:
		_draw_stat_bars()

	# Fogos de artifício por cima de tudo (comemoração).
	if not fw_particles.is_empty():
		_draw_fireworks()

## Desenha as fagulhas dos fogos em coords lógicas (transform base do pet), com brilho
## que some conforme a vida da partícula e um pequeno rastro.
func _draw_fireworks() -> void:
	draw_set_transform(Vector2(pet_x, pet_y), 0.0, Vector2(PET_SCALE, PET_SCALE))
	for pt in fw_particles:
		var a: float = clampf(pt.life / pt.max, 0.0, 1.0)
		var col: Color = pt.col
		var tail: Vector2 = pt.p - pt.v * 0.03
		draw_line(tail, pt.p, Color(col.r, col.g, col.b, a * 0.5), 1.5, true)
		draw_circle(pt.p, 2.2, Color(col.r, col.g, col.b, a))

## Barras de necessidade (Alimentar/Carinho/Brincar) no **rodapé** abaixo do pet, em
## pixels reais (transform identidade — não escala com PET_SCALE nem com o pulo). Só a
## parte colorida representa a % (0..100), sem números. Ícone do menu à esquerda de cada
## barra (🦴/🤚/🎾, ~2× o tamanho anterior), via fonte padrão (renderiza emojis coloridos).
func _draw_stat_bars() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)   # px reais, no rodapé
	var font := speech.get_theme_font("font")
	var top := pet_y + float(PET_DRAW) + 5.0             # início do rodapé (abaixo do pet)
	var icon_fs := 17                                    # ~2× o ícone anterior
	var row_h := 16.0
	var bh := 8.0                                        # barra um pouco mais alta
	# Largura amarrada ao PET (não à janela): o conjunto ícone+barra ocupa a largura do
	# pet (PET_DRAW) e fica centralizado sob ele — não estica com o balão de fala.
	var icon_w := 18.0
	var gap := 4.0
	var icon_x := pet_x                                  # alinhado à borda esquerda do pet
	var bx := pet_x + icon_w + gap
	var bw := float(PET_DRAW) - icon_w - gap            # barra preenche o resto da largura do pet
	var rows := [[stat_feed, COL_FEED, "🦴"], [stat_pet, COL_PET, "🤚"], [stat_play, COL_PLAY, "🎾"]]
	for i in rows.size():
		var r = rows[i]
		var val: float = clampf(r[0], 0.0, 100.0)
		var col: Color = r[1]
		var icon: String = r[2]
		var ry := top + float(i) * row_h
		var bar_y := ry + (row_h - bh) * 0.5
		draw_string(font, Vector2(icon_x, ry + row_h - 3.0), icon, HORIZONTAL_ALIGNMENT_LEFT, -1.0, icon_fs)
		draw_rect(Rect2(Vector2(bx, bar_y), Vector2(bw, bh)), Color(0, 0, 0, 0.18))   # trilho
		if val > 0.0:
			draw_rect(Rect2(Vector2(bx, bar_y), Vector2(bw * val / 100.0, bh)), col)  # preenchimento

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
		"tongue":   # sorrisinho com línguinha saindo
			var sm := _quad(Vector2(91, 113) + o, Vector2(100, 121) + o, Vector2(109, 113) + o, 12)
			draw_polyline(sm, INK, 2.4, true)
			_ellipse(Vector2(100, 120) + o, Vector2(4.5, 3.5), Color(0.9, 0.4, 0.45))
		"fang":     # boca reta com uma presinha
			draw_line(Vector2(92, 115) + o, Vector2(108, 115) + o, INK, 2.4, true)
			_triangle(Vector2(98, 115) + o, Vector2(102, 115) + o, Vector2(100, 121) + o, Color.WHITE)
		_:  # "smile" — reflete a felicidade
			var ctrl_y := 124.0 if happy > 60.0 else (116.0 if happy > 30.0 else 108.0)
			var mouth := _quad(Vector2(90, 112) + o, Vector2(100, ctrl_y) + o, Vector2(110, 112) + o, 14)
			draw_polyline(mouth, INK, 2.5, true)

## Rosto de "necessidade" quando uma barra zera (sem fala). Prioridade: fome > carente
## > entediado. "neutral" = nenhuma zerada (rosto padrão segue o cursor).
func _need_expression() -> String:
	if stat_feed <= 0.0:
		return "hungry"
	if stat_pet <= 0.0:
		return "needy"
	if stat_play <= 0.0:
		return "bored"
	return "neutral"

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
		"hungry":   # Alimentar = 0: cara de fome + boca aberta (com línguinha)
			draw_line(lc + Vector2(-eye_w - 1.0, -2.0), lc + Vector2(eye_w, -eye_h), INK, 2.0, true)
			draw_line(rc + Vector2(eye_w + 1.0, -2.0), rc + Vector2(-eye_w, -eye_h), INK, 2.0, true)
			_ellipse(lc, Vector2(eye_w, eye_h), Color.WHITE)
			_ellipse(rc, Vector2(eye_w, eye_h), Color.WHITE)
			draw_circle(lc + Vector2(0.0, eye_h * 0.4), 4.0, INK)
			draw_circle(rc + Vector2(0.0, eye_h * 0.4), 4.0, INK)
			_ellipse(Vector2(100, 119) + o, Vector2(8, 8), INK)                  # boca bem aberta
			_ellipse(Vector2(100, 123) + o, Vector2(4.5, 4.0), Color(0.85, 0.4, 0.45))  # língua
		"needy":   # Carinho = 0: cara de necessitado + lágrimas (chorando)
			draw_line(lc + Vector2(-eye_w - 1.0, -2.0), lc + Vector2(eye_w, -eye_h - 1.0), INK, 2.2, true)
			draw_line(rc + Vector2(eye_w + 1.0, -2.0), rc + Vector2(-eye_w, -eye_h - 1.0), INK, 2.2, true)
			_ellipse(lc, Vector2(eye_w, eye_h), Color.WHITE)
			_ellipse(rc, Vector2(eye_w, eye_h), Color.WHITE)
			draw_circle(lc + Vector2(0.0, eye_h * 0.4), 4.2, INK)
			draw_circle(rc + Vector2(0.0, eye_h * 0.4), 4.2, INK)
			var tear := Color(0.45, 0.7, 0.98, 0.9)                              # lágrimas (as duas)
			_ellipse(lc + Vector2(-2.0, eye_h + 6.0), Vector2(2.6, 4.4), tear)
			_ellipse(rc + Vector2(2.0, eye_h + 6.0), Vector2(2.6, 4.4), tear)
			var nm := _quad(Vector2(91, 117) + o, Vector2(100, 109) + o, Vector2(109, 117) + o, 14)  # boca triste
			draw_polyline(nm, INK, 2.4, true)
		"bored":   # Brincar = 0: cara de chateado + olhos fechados (—) + boca reta
			draw_line(lc + Vector2(-eye_w, 0.0), lc + Vector2(eye_w, 0.0), INK, 2.4, true)
			draw_line(rc + Vector2(-eye_w, 0.0), rc + Vector2(eye_w, 0.0), INK, 2.4, true)
			draw_line(lc + Vector2(-eye_w - 1.0, -eye_h - 2.0), lc + Vector2(eye_w, -eye_h - 1.0), INK, 1.8, true)  # sobrancelha caída
			draw_line(rc + Vector2(eye_w + 1.0, -eye_h - 2.0), rc + Vector2(-eye_w, -eye_h - 1.0), INK, 1.8, true)
			draw_line(Vector2(92, 117) + o, Vector2(108, 117) + o, INK, 2.4, true)
		"dizzy":   # tontura (sacudida): olhos em espiral (@_@) + boca ondulada
			for ec in [lc, rc]:
				var sp := PackedVector2Array()
				for i in 24:
					var tt := float(i) / 23.0
					var ang := tt * TAU * 2.0
					var rad := (eye_w + 1.5) * tt
					sp.append(ec + Vector2(cos(ang) * rad, sin(ang) * rad))
				draw_polyline(sp, INK, 1.7, true)
			var dw := PackedVector2Array()
			for i in 7:
				var x := 92.0 + float(i) * 2.7
				var yy := 117.0 + (2.0 if i % 2 == 0 else -2.0)
				dw.append(Vector2(x, yy) + o)
			draw_polyline(dw, INK, 2.0, true)
		"nausea":   # enjoo (sacudida): olhos semicerrados + bochechas esverdeadas + boca ondulada
			var green := Color(0.5, 0.75, 0.4, 0.5)
			_ellipse(Vector2(72, 118) + o, Vector2(8, 5), green)
			_ellipse(Vector2(128, 118) + o, Vector2(8, 5), green)
			_ellipse(lc, Vector2(eye_w, eye_h * 0.5), Color.WHITE)
			_ellipse(rc, Vector2(eye_w, eye_h * 0.5), Color.WHITE)
			draw_circle(lc + Vector2(0.0, 1.5), 3.4, INK)
			draw_circle(rc + Vector2(0.0, 1.5), 3.4, INK)
			draw_line(lc + Vector2(-eye_w, -eye_h * 0.5), lc + Vector2(eye_w, -eye_h * 0.5), INK, 1.8, true)  # pálpebra caída
			draw_line(rc + Vector2(-eye_w, -eye_h * 0.5), rc + Vector2(eye_w, -eye_h * 0.5), INK, 1.8, true)
			var nw := PackedVector2Array()
			for i in 7:
				var x := 91.0 + float(i) * 3.0
				var yy := 118.0 + (2.5 if i % 2 == 0 else -2.5)
				nw.append(Vector2(x, yy) + o)
			draw_polyline(nw, INK, 2.2, true)
		"scared":   # susto (sacudida): olhos arregalados (pupila pequena) + sobrancelhas altas + boca aberta + suor
			for ec in [lc, rc]:
				_ellipse(ec, Vector2(eye_w + 2.0, eye_h + 2.5), Color.WHITE)
				draw_circle(ec, 2.5, INK)
			draw_arc(lc + Vector2(0.0, -eye_h - 3.0), eye_w, PI + 0.3, TAU - 0.3, 8, INK, 1.8, true)
			draw_arc(rc + Vector2(0.0, -eye_h - 3.0), eye_w, PI + 0.3, TAU - 0.3, 8, INK, 1.8, true)
			_ellipse(Vector2(100, 118) + o, Vector2(5, 6), INK)
			_ellipse(Vector2(115, 100) + o, Vector2(2.5, 4.0), Color(0.45, 0.7, 0.98, 0.85))

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

# ---------------------------------------- partes geométricas adicionais (esqueleto)
## Rabo (atrás do corpo): enroladinho, fofo (puff) ou tococo (stub).
func _draw_tail(style: String, o: Vector2, bw: float, bh: float, by: float, col: Color) -> void:
	var base := Vector2(100.0 + bw * 0.72, 108.0 + by + bh * 0.35) + o
	match style:
		"puff":
			_ellipse(base + Vector2(9, -2), Vector2(11, 11), col)
		"curl":
			var pts := PackedVector2Array()
			for i in 18:
				var tt := float(i) / 17.0
				var ang := tt * PI * 1.7
				var rad := 3.0 + tt * 9.0
				pts.append(base + Vector2(7.0 + cos(ang) * rad, -sin(ang) * rad))
			draw_polyline(pts, col, 4.0, true)
		_:  # "stub"
			_ellipse(base + Vector2(6, 0), Vector2(7, 6), col)

## Chifres no alto da cabeça: único (unicorn), dois retos (devil) ou galhada (antlers).
func _draw_horns(style: String, o: Vector2, head_top: float, col: Color) -> void:
	var ty := head_top + 4.0
	match style:
		"unicorn":
			_triangle(Vector2(96, ty) + o, Vector2(104, ty) + o, Vector2(100, ty - 16.0) + o, col)
		"devil":
			_triangle(Vector2(80, ty) + o, Vector2(88, ty) + o, Vector2(82, ty - 12.0) + o, col)
			_triangle(Vector2(112, ty) + o, Vector2(120, ty) + o, Vector2(118, ty - 12.0) + o, col)
		_:  # "antlers"
			for sx in [-1.0, 1.0]:
				var s := float(sx)
				var b := Vector2(100.0 + s * 14.0, ty) + o
				draw_line(b, b + Vector2(s * 4.0, -14.0), col, 3.0, true)
				draw_line(b + Vector2(s * 2.0, -7.0), b + Vector2(s * 9.0, -10.0), col, 2.5, true)

## Topete/cabelo no alto da cabeça: tufo, cacho (cowlick) ou crista (mohawk).
func _draw_hair(style: String, o: Vector2, head_top: float, col: Color) -> void:
	var ty := head_top + 2.0
	match style:
		"mohawk":
			for i in 5:
				var x := 100.0 + (float(i) - 2.0) * 7.0
				var h := 12.0 - absf(float(i) - 2.0) * 2.0
				_triangle(Vector2(x - 4.0, ty) + o, Vector2(x + 4.0, ty) + o, Vector2(x, ty - h) + o, col)
		"cowlick":
			var pts := _quad(Vector2(100, ty) + o, Vector2(110, ty - 16.0) + o, Vector2(116, ty - 4.0) + o, 12)
			draw_polyline(pts, col, 3.5, true)
		_:  # "tuft"
			for sx in [-6.0, 0.0, 6.0]:
				draw_line(Vector2(100.0 + sx, ty) + o, Vector2(100.0 + sx * 1.4, ty - 12.0) + o, col, 3.0, true)

## Patinhas na base do corpo.
func _draw_feet(o: Vector2, bw: float, bh: float, by: float, col: Color) -> void:
	var fy := 108.0 + by + bh * 0.82
	_ellipse(Vector2(100.0 - bw * 0.42, fy) + o, Vector2(11, 7), col)
	_ellipse(Vector2(100.0 + bw * 0.42, fy) + o, Vector2(11, 7), col)

## Bracinhos nas laterais do corpo.
func _draw_arms(o: Vector2, bw: float, by: float, col: Color) -> void:
	_ellipse(Vector2(100.0 - bw * 0.92, 120.0 + by) + o, Vector2(7, 10), col)
	_ellipse(Vector2(100.0 + bw * 0.92, 120.0 + by) + o, Vector2(7, 10), col)

## Asinhas atrás do corpo.
func _draw_wings(o: Vector2, bw: float, by: float, col: Color) -> void:
	for sx in [-1.0, 1.0]:
		var s := float(sx)
		var b := Vector2(100.0 + s * bw * 0.7, 100.0 + by) + o
		var w := PackedVector2Array([
			b,
			b + Vector2(s * 22.0, -10.0),
			b + Vector2(s * 26.0, 4.0),
			b + Vector2(s * 18.0, 6.0),
			b + Vector2(s * 22.0, 16.0),
			b + Vector2(s * 6.0, 10.0),
		])
		draw_colored_polygon(w, col)

## Marca na barriga: bolinha (spot) ou coraçãozinho (heart).
func _draw_belly_mark(style: String, o: Vector2, by: float, spot: Color, heart: Color) -> void:
	var c := Vector2(100, 120.0 + by * 0.5) + o
	if style == "heart":
		draw_circle(c + Vector2(-2.5, -1.0), 3.0, heart)
		draw_circle(c + Vector2(2.5, -1.0), 3.0, heart)
		_triangle(c + Vector2(-5.0, 0.0), c + Vector2(5.0, 0.0), c + Vector2(0.0, 6.0), heart)
	else:  # "spot"
		_ellipse(c, Vector2(6, 5), spot)

## Bigodes ao lado do focinho (curtos ou longos).
func _draw_whiskers(style: String, o: Vector2) -> void:
	var ln := 14.0 if style == "long" else 9.0
	for side in [-1.0, 1.0]:
		var s := float(side)
		var bx := 100.0 + s * 16.0
		for k in 3:
			var yy := 112.0 + float(k) * 4.0
			draw_line(Vector2(bx, yy) + o, Vector2(bx + s * ln, yy - 3.0 + float(k) * 3.0) + o, INK, 1.2, true)

## Sardinhas sob os olhos.
func _draw_freckles(o: Vector2, col: Color) -> void:
	for side in [-1.0, 1.0]:
		var s := float(side)
		for k in 3:
			draw_circle(Vector2(100.0 + s * (16.0 + float(k) * 4.0), 112.0 + float(k % 2) * 3.0) + o, 1.4, col)

## Padrão no corpo: manchas (spots) ou listras (stripes), recortadas no contorno do corpo.
func _draw_body_pattern(style: String, o: Vector2, bw: float, bh: float, by: float, col: Color) -> void:
	var cy := 108.0 + by
	var pc := Color(col.r, col.g, col.b, 0.5)   # translúcido p/ não "pesar" sobre o corpo
	if style == "stripes":
		for i in 3:
			var yy := cy - bh * 0.35 + float(i) * (bh * 0.42)
			var hw := bw * sqrt(max(0.0, 1.0 - pow((yy - cy) / bh, 2.0))) * 0.9
			draw_line(Vector2(100.0 - hw, yy) + o, Vector2(100.0 + hw, yy) + o, pc, 4.0, true)
	else:  # "spots"
		var spots := [Vector2(-0.45, -0.2), Vector2(0.4, 0.05), Vector2(-0.15, 0.4),
			Vector2(0.2, -0.45), Vector2(-0.5, 0.3)]
		for sp in spots:
			draw_circle(Vector2(100.0 + sp.x * bw, cy + sp.y * bh) + o, bw * 0.13, pc)

## Sobrancelhas (rosto neutro): retas, levantadas ou sérias (\  /).
func _draw_eyebrows(style: String, lx: float, rx: float, eye_y: float, eh: float, o: Vector2) -> void:
	var top := eye_y - eh - 5.0
	match style:
		"flat":
			draw_line(Vector2(lx - 5.0, top) + o, Vector2(lx + 5.0, top) + o, INK, 2.0, true)
			draw_line(Vector2(rx - 5.0, top) + o, Vector2(rx + 5.0, top) + o, INK, 2.0, true)
		"raised":
			draw_line(Vector2(lx - 5.0, top - 2.0) + o, Vector2(lx + 5.0, top - 4.0) + o, INK, 2.0, true)
			draw_line(Vector2(rx - 5.0, top - 4.0) + o, Vector2(rx + 5.0, top - 2.0) + o, INK, 2.0, true)
		_:  # "serious"
			draw_line(Vector2(lx - 5.0, top - 3.0) + o, Vector2(lx + 5.0, top) + o, INK, 2.2, true)
			draw_line(Vector2(rx - 5.0, top) + o, Vector2(rx + 5.0, top - 3.0) + o, INK, 2.2, true)

## Pupilas conforme o estilo (o pupil_off faz seguir o cursor). lc/rc já com offset.
## Pupila de UM olho (centro `ec`), no estilo dado. Permite desenhar só o olho aberto
## quando o outro está fechado por clique (ver _draw).
func _draw_pupil(ec: Vector2, style: String) -> void:
	var p := pupil_off
	match style:
		"big":
			draw_circle(ec + Vector2(1.5, 1.5) + p, 7.0, INK)
			draw_circle(ec + Vector2(3.5, -1.5) + p, 2.4, Color.WHITE)
			draw_circle(ec + Vector2(-1.5, 2.5) + p, 1.2, Color.WHITE)
		"cat":
			_ellipse(ec + Vector2(2.0, 2.0) + p, Vector2(2.2, 6.5), INK)
			draw_circle(ec + Vector2(3.5, -1.5) + p, 1.4, Color.WHITE)
		"sparkle":
			draw_circle(ec + Vector2(2.0, 2.0) + p, 5.5, INK)
			_star(ec + Vector2(3.5, -1.5) + p, 2.8, 1.1, 4, Color.WHITE)
		"heart":
			var hc: Vector2 = ec + Vector2(2.0, 2.0) + p
			draw_circle(hc + Vector2(-2.2, -1.4), 2.6, INK)
			draw_circle(hc + Vector2(2.2, -1.4), 2.6, INK)
			_triangle(hc + Vector2(-4.2, -0.2), hc + Vector2(4.2, -0.2), hc + Vector2(0.0, 4.6), INK)
		_:  # "round"
			draw_circle(ec + Vector2(2.0, 2.0) + p, 5.5, INK)
			draw_circle(ec + Vector2(4.0, -1.0) + p, 1.8, Color.WHITE)

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
		"wizard":   # chapéu de bruxo: cone alto + aba + estrelinha
			_ellipse(Vector2(100, 78) + o, Vector2(32, 7), hat_col.darkened(0.1))
			_triangle(Vector2(78, 78) + o, Vector2(122, 78) + o, Vector2(100, 30) + o, hat_col)
			_star(Vector2(100, 58) + o, 4.0, 1.7, 5, hat_col.lightened(0.45))

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
		"heart":   # lentes em coração
			for gc in [lc, rc]:
				draw_circle(gc + Vector2(-gr * 0.45, -gr * 0.3), gr * 0.55, gl_col)
				draw_circle(gc + Vector2(gr * 0.45, -gr * 0.3), gr * 0.55, gl_col)
				_triangle(gc + Vector2(-gr * 0.9, 0.0), gc + Vector2(gr * 0.9, 0.0), gc + Vector2(0.0, gr * 1.1), gl_col)
			draw_line(lc + Vector2(gr, 0), rc - Vector2(gr, 0), gl_col, 2.0, true)
		"sunglasses":   # lentes escuras preenchidas + ponte
			var sz := Vector2(gr * 2.1, gr * 1.7)
			draw_rect(Rect2(lc - sz * 0.5, sz), gl_col)
			draw_rect(Rect2(rc - sz * 0.5, sz), gl_col)
			draw_line(lc + Vector2(gr, -2.0), rc - Vector2(gr, 2.0), gl_col, 2.0, true)

	# Laço (na cabeça ou no pescoço).
	var bow_col: Color = a.get("bow_color", Color("e84393"))
	match a.get("bow", "none"):
		"head":
			_draw_bow(Vector2(122, 72) + o, bow_col)
		"neck":
			_draw_bow(Vector2(100, 150) + o, bow_col)

	# --- categorias geométricas adicionais (cada uma independente) ---
	if a.get("sash", "none") != "none":
		_draw_sash(o, a.get("sash_color", Color("c0392b")))
	if a.get("collar", "none") != "none":
		_draw_collar(a.get("collar"), o, a.get("collar_color", Color("e74c3c")))
	if a.get("necklace", "none") != "none":
		_draw_necklace(a.get("necklace"), o, a.get("necklace_color", Color("f1c40f")))
	if a.get("tie", "none") != "none":
		_draw_tie(a.get("tie"), o, a.get("tie_color", Color("8e44ad")))
	if a.get("badge", "none") != "none":
		_draw_badge(a.get("badge"), o, a.get("badge_color", Color("f39c12")))
	if a.get("headphones", "none") != "none":
		_draw_headphones(o, a.get("headphone_color", Color("34495e")))
	if a.get("flower", "none") != "none":
		_draw_flower(o, a.get("flower_color", Color("e84393")))
	if a.get("earrings", "none") != "none":
		_draw_earrings(a.get("earrings"), o, a.get("earring_color", Color("f1c40f")))
	if a.get("monocle", "none") != "none":
		_draw_monocle(o, eye_dx, eye_y, eye_w, a.get("monocle_color", Color("bdc3c7")))
	if a.get("mustache", "none") != "none":
		_draw_mustache(a.get("mustache"), o, a.get("mustache_color", Color("4a3527")))
	if a.get("mask", "none") != "none":
		_draw_mask(a.get("mask"), o, a.get("mask_color", Color("ecf0f1")))
	if a.get("cheek_sticker", "none") != "none":
		_draw_cheek_sticker(a.get("cheek_sticker"), o, a.get("sticker_color", Color("e84393")))
	if a.get("backpack", "none") != "none":
		_draw_backpack(o, a.get("backpack_color", Color("2e7d32")))
	if a.get("belt", "none") != "none":
		_draw_belt(a.get("belt"), o, a.get("belt_color", Color("6d4c41")))

# ---------------------------------------- acessórios geométricos adicionais
## Faixa diagonal atravessando o corpo.
func _draw_sash(o: Vector2, col: Color) -> void:
	var p := PackedVector2Array([
		Vector2(70, 120) + o, Vector2(80, 116) + o,
		Vector2(132, 152) + o, Vector2(122, 156) + o])
	draw_colored_polygon(p, col)

## Coleira no pescoço: lisa ou com guizo.
func _draw_collar(style: String, o: Vector2, col: Color) -> void:
	_ellipse(Vector2(100, 142) + o, Vector2(30, 7), col)
	_ellipse(Vector2(100, 142) + o, Vector2(24, 4), col.darkened(0.25))
	if style == "bell":
		draw_circle(Vector2(100, 150) + o, 5.0, Color("f1c40f"))
		draw_circle(Vector2(100, 151) + o, 1.6, col.darkened(0.4))

## Colar: fio de pérolas ou pingente.
func _draw_necklace(style: String, o: Vector2, col: Color) -> void:
	var arc := _quad(Vector2(80, 136) + o, Vector2(100, 150) + o, Vector2(120, 136) + o, 16)
	if style == "pearls":
		for i in range(0, arc.size(), 2):
			draw_circle(arc[i], 2.4, col)
	else:  # "pendant"
		draw_polyline(arc, col.lightened(0.2), 1.6, true)
		draw_circle(Vector2(100, 150) + o, 4.0, col)
		_triangle(Vector2(96, 150) + o, Vector2(104, 150) + o, Vector2(100, 158) + o, col)

## Gravata (necktie) ou gravata-borboleta (bowtie), no pescoço.
func _draw_tie(style: String, o: Vector2, col: Color) -> void:
	if style == "bowtie":
		var c := Vector2(100, 142) + o
		_triangle(c, c + Vector2(-11, -7), c + Vector2(-11, 7), col)
		_triangle(c, c + Vector2(11, -7), c + Vector2(11, 7), col)
		draw_circle(c, 3.0, col.darkened(0.25))
	else:  # "necktie"
		var top := Vector2(100, 138) + o
		_triangle(top + Vector2(-5, 0), top + Vector2(5, 0), top + Vector2(0, 7), col)
		draw_colored_polygon(PackedVector2Array([
			top + Vector2(-4, 7), top + Vector2(4, 7),
			top + Vector2(6, 26), top + Vector2(0, 32), top + Vector2(-6, 26)]), col)

## Broche no peito: estrela ou coração.
func _draw_badge(style: String, o: Vector2, col: Color) -> void:
	var c := Vector2(84, 134) + o
	if style == "heart":
		draw_circle(c + Vector2(-2.5, -1.0), 3.0, col)
		draw_circle(c + Vector2(2.5, -1.0), 3.0, col)
		_triangle(c + Vector2(-5, 0), c + Vector2(5, 0), c + Vector2(0, 6), col)
	else:  # "star"
		_star(c, 5.5, 2.4, 5, col)

## Fones de ouvido: arco sobre a cabeça + conchas nas laterais.
func _draw_headphones(o: Vector2, col: Color) -> void:
	draw_arc(Vector2(100, 92) + o, 34.0, PI + 0.2, TAU - 0.2, 24, col, 4.0, true)
	_ellipse(Vector2(67, 92) + o, Vector2(7, 11), col)
	_ellipse(Vector2(133, 92) + o, Vector2(7, 11), col)

## Florzinha na lateral da cabeça.
func _draw_flower(o: Vector2, col: Color) -> void:
	var c := Vector2(74, 70) + o
	for i in 5:
		var a := TAU * float(i) / 5.0
		draw_circle(c + Vector2(cos(a), sin(a)) * 5.0, 3.2, col)
	draw_circle(c, 3.0, Color("f9e79f"))

## Brincos: tachas (studs) ou argolas (hoops), nas laterais inferiores da cabeça.
func _draw_earrings(style: String, o: Vector2, col: Color) -> void:
	for sx in [-1.0, 1.0]:
		var s := float(sx)
		var c := Vector2(100.0 + s * 30.0, 104.0) + o
		if style == "hoops":
			draw_arc(c + Vector2(0, 3), 4.0, 0.0, TAU, 16, col, 2.0, true)
		else:  # "studs"
			draw_circle(c, 2.6, col)

## Monóculo no olho direito + correntinha.
func _draw_monocle(o: Vector2, eye_dx: float, eye_y: float, eye_w: float, col: Color) -> void:
	var rc := Vector2(100.0 + eye_dx, eye_y) + o
	draw_arc(rc, eye_w + 4.0, 0.0, TAU, 24, col, 2.2, true)
	draw_line(rc + Vector2(0, eye_w + 4.0), rc + Vector2(-2, eye_w + 18.0), col.darkened(0.2), 1.4, true)

## Bigode: encaracolado ou fino, abaixo do focinho.
func _draw_mustache(style: String, o: Vector2, col: Color) -> void:
	var c := Vector2(100, 110) + o
	if style == "thin":
		draw_line(c + Vector2(-10, 0), c + Vector2(0, 2), col, 2.0, true)
		draw_line(c + Vector2(0, 2), c + Vector2(10, 0), col, 2.0, true)
	else:  # "curly"
		var l := _quad(c, c + Vector2(-9, 1), c + Vector2(-12, -5), 10)
		var r := _quad(c, c + Vector2(9, 1), c + Vector2(12, -5), 10)
		draw_polyline(l, col, 2.6, true)
		draw_polyline(r, col, 2.6, true)

## Máscara cobrindo a parte de baixo do rosto (cirúrgica ou ninja).
func _draw_mask(style: String, o: Vector2, col: Color) -> void:
	if style == "ninja":
		draw_rect(Rect2(Vector2(72, 104) + o, Vector2(56, 18)), col)
	else:  # "medical"
		draw_colored_polygon(PackedVector2Array([
			Vector2(84, 106) + o, Vector2(116, 106) + o,
			Vector2(113, 124) + o, Vector2(100, 128) + o, Vector2(87, 124) + o]), col)
		draw_line(Vector2(84, 106) + o, Vector2(72, 100) + o, col.darkened(0.2), 1.6, true)
		draw_line(Vector2(116, 106) + o, Vector2(128, 100) + o, col.darkened(0.2), 1.6, true)

## Adesivo na bochecha: estrelinha ou coraçãozinho (em cada lado).
func _draw_cheek_sticker(style: String, o: Vector2, col: Color) -> void:
	for sx in [-1.0, 1.0]:
		var s := float(sx)
		var c := Vector2(100.0 + s * 30.0, 116.0) + o
		if style == "heart":
			draw_circle(c + Vector2(-1.6, -0.6), 1.8, col)
			draw_circle(c + Vector2(1.6, -0.6), 1.8, col)
			_triangle(c + Vector2(-3, 0), c + Vector2(3, 0), c + Vector2(0, 3.5), col)
		else:  # "star"
			_star(c, 3.2, 1.3, 5, col)

## Cinto na parte baixa do corpo (liso ou com fivela).
func _draw_belt(style: String, o: Vector2, col: Color) -> void:
	draw_rect(Rect2(Vector2(72, 144) + o, Vector2(56, 7)), col)
	if style == "buckle":
		draw_rect(Rect2(Vector2(95, 143) + o, Vector2(10, 9)), col.lightened(0.4))
		draw_rect(Rect2(Vector2(98, 146) + o, Vector2(4, 3)), col.darkened(0.2))

## Mochila: duas alças cruzando o peito (a bolsa fica "atrás", então só as alças aparecem).
func _draw_backpack(o: Vector2, col: Color) -> void:
	draw_line(Vector2(86, 104) + o, Vector2(94, 150) + o, col, 5.0, true)
	draw_line(Vector2(114, 104) + o, Vector2(106, 150) + o, col, 5.0, true)
	_ellipse(Vector2(94, 150) + o, Vector2(3.5, 3.5), col.darkened(0.15))
	_ellipse(Vector2(106, 150) + o, Vector2(3.5, 3.5), col.darkened(0.15))

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
		var tt := float(i) / n
		var u := 1.0 - tt
		pts.append(u * u * p0 + 2.0 * u * tt * p1 + tt * tt * p2)
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
					# Clique no olho fecha aquele olho (reabre ao sair de cima — ver
					# _process). Fora dos olhos, é o carinho rápido de sempre.
					var eye := _mouse_over_eye_local(event.position)
					if eye == 1:
						eye_closed_l = true
					elif eye == 2:
						eye_closed_r = true
					else:
						_react()   # clique sem arrastar = carinho rápido
				else:
					_save_settings()   # guarda a nova posição
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_rebuild_automations_menu()   # capta scripts adicionados sem reiniciar
			_refresh_save_labels()        # "Salvar" vira "Renomear" se o item já existe
			menu.reset_size()
			# Posiciona ao lado do pet, sem cobri-lo e dentro da tela.
			menu.position = _context_menu_position(menu.size)
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
		# anchor = centro-inferior do PET (desconta o rodapé das barras, se houver).
		var footer := int(STATUS_FOOTER) if show_status else 0
		anchor = pos + Vector2i(int(win_w / 2.0), win_h - footer)

# ------------------------------------------------------------------ ações
## Libera uma interação respeitando dois limites: no máximo uma por segundo e a
## mesma ação no máximo 3 vezes seguidas (uma ação diferente zera a contagem). A trava
## de 3x também **libera sozinha após REPEAT_RESET (30s)** sem repetir (ver _process).
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
	repeat_reset_cd = REPEAT_RESET # cada ação aceita reinicia a janela de 30s
	return true

## Pet demonstra repulsa/raiva/tristeza/indiferença e perde um pouco de humor.
## Limitado por complain_cd para não spammar fala a cada clique.
func _complain() -> void:
	if complain_cd > 0.0:
		return
	complain_cd = COMPLAIN_COOLDOWN
	happy = clampf(happy - 6.0, 0.0, 100.0)
	say(ta("mood_neg").pick_random())

func feed() -> void:
	if not _can_act("feed"):
		return
	stat_feed = STAT_MAX          # enche a barra de Alimentar
	hunger = clampf(hunger - 25.0, 0.0, 100.0)
	happy = clampf(happy + 8.0, 0.0, 100.0)
	say(ta("feed").pick_random())
	play_action_anim("feed")
	if sound_feed_on:
		_play_group(_feed_player, _feed_variants)

func pet() -> void:
	if not _can_act("pet"):
		return
	stat_pet = STAT_MAX           # enche a barra de Carinho
	happy = clampf(happy + 15.0, 0.0, 100.0)
	say(ta("pet_react").pick_random())
	play_action_anim("pet")
	if sound_pet_on:
		_play_group(_pet_player, _pet_variants)

func play() -> void:
	if not _can_act("play"):
		return
	stat_play = STAT_MAX          # enche a barra de Brincar
	happy = clampf(happy + 12.0, 0.0, 100.0)
	hunger = clampf(hunger + 10.0, 0.0, 100.0)
	say(ta("play").pick_random())
	play_action_anim("play")
	if sound_play_on:
		_play_group(_play_player, _play_variants)

func _react() -> void:
	if not _can_act("react"):
		return
	happy = clampf(happy + 5.0, 0.0, 100.0)
	say(t("hi_react"))
	play_action_anim("react")

## Mostra uma expressão de reação temporária (hover/sacudida) por `dur` segundos.
## Sobrepõe o rosto neutro/necessidade enquanto react_expr_t > 0 (ver _draw).
func _show_react(expr: String, dur: float) -> void:
	react_expr = expr
	react_expr_t = dur

## Disparo da sacudida: sorteia tontura/enjoo/susto (animação + expressão + fala) e
## tira um tiquinho de humor. Limitado por SHAKE_COOLDOWN p/ não repetir em sequência.
func _trigger_shake() -> void:
	_shake_count = 0
	_shake_window = 0.0
	_shake_dir = 0
	shake_cd = SHAKE_COOLDOWN
	var kind: String = ["dizzy", "nausea", "scared"].pick_random()
	play_anim(kind)
	_show_react(kind, anim_dur + 0.4)
	say(ta("shake_" + kind).pick_random(), anim_dur + 0.4)
	happy = clampf(happy - 4.0, 0.0, 100.0)

## Qual olho está sob o ponto `wl` (em coords da janela)? 0 = nenhum, 1 = esquerdo,
## 2 = direito. Converte para o espaço lógico do pet (0..200) e testa cada elipse com
## uma margem generosa p/ o clique não precisar de mira perfeita.
func _mouse_over_eye_local(wl: Vector2) -> int:
	var p := (wl - Vector2(pet_x, pet_y)) / PET_SCALE
	var eye_dx: float = current.get("eye_dx", 18.0)
	var eye_y: float = current.get("eye_y", 96.0) + y_off
	var rw: float = current.get("eye_w", 10.0) + 5.0
	var rh: float = current.get("eye_h", 12.0) + 5.0
	if _in_ellipse(p, Vector2(100.0 - eye_dx, eye_y), rw, rh):
		return 1
	if _in_ellipse(p, Vector2(100.0 + eye_dx, eye_y), rw, rh):
		return 2
	return 0

## Ponto `p` dentro da elipse de centro `c` e raios `rw`/`rh`?
func _in_ellipse(p: Vector2, c: Vector2, rw: float, rh: float) -> bool:
	var dx := (p.x - c.x) / rw
	var dy := (p.y - c.y) / rh
	return dx * dx + dy * dy <= 1.0

func hop(force := 320.0) -> void:
	vy = -force

## Comemoração: dispara fogos de artifício por `duration` segundos + pulo e dancinha.
## Chamado por automações (ex.: comemoração de hora cheia) via zimmy.celebrate().
func celebrate(duration := 3.0) -> void:
	fw_time = maxf(fw_time, duration)
	fw_spawn_cd = 0.0
	hop(440.0)
	play_anim("dance")

## Avança os fogos: lança novos estouros enquanto fw_time > 0 e move as partículas
## (com leve gravidade), descartando as que apagaram. Barato — só roda quando ativo.
func _update_fireworks(delta: float) -> void:
	if fw_time > 0.0:
		fw_time -= delta
		fw_spawn_cd -= delta
		if fw_spawn_cd <= 0.0:
			fw_spawn_cd = randf_range(0.22, 0.5)
			_spawn_burst()
	var alive: Array = []
	for pt in fw_particles:
		pt.life -= delta
		if pt.life > 0.0:
			pt.v.y += 55.0 * delta        # gravidade leve (as fagulhas caem)
			pt.p += pt.v * delta
			alive.append(pt)
	fw_particles = alive

## Um estouro: ~14 fagulhas radiais de uma cor, na faixa acima do pet (coords lógicas;
## y negativo = headroom acima do corpo).
func _spawn_burst() -> void:
	var cx := randf_range(45.0, 155.0)
	var cy := randf_range(-80.0, 10.0)
	var col := Color.from_hsv(randf(), 0.55, 1.0)
	var n := 14
	for i in n:
		var ang := TAU * float(i) / float(n) + randf_range(-0.12, 0.12)
		var spd := randf_range(38.0, 72.0)
		var life := randf_range(0.6, 1.0)
		fw_particles.append({
			"p": Vector2(cx, cy),
			"v": Vector2(cos(ang), sin(ang)) * spd,
			"life": life, "max": life, "col": col,
		})

## Sorteia e dispara uma das animações associadas à `action` (ver ACTION_ANIMS).
## É como cada item de menu distinto ganha uma reação variada do pet.
func play_action_anim(action: String) -> void:
	var pool: Array = ACTION_ANIMS.get(action, ["hop"])
	play_anim(pool.pick_random())

## Inicia a animação `name`: define duração e, p/ as de salto, dispara o(s) pulo(s).
## A rotação/escala/balanço são calculados por fase no _draw enquanto anim != "".
func play_anim(name: String) -> void:
	anim = name
	anim_t = 0.0
	hop_queue = 0
	match name:
		"hop":        anim_dur = 0.5; hop(320.0)
		"double_hop": anim_dur = 0.9; hop(300.0); hop_queue = 1; hop_queue_force = 300.0
		"triple_hop": anim_dur = 1.2; hop(280.0); hop_queue = 2; hop_queue_force = 280.0
		"spin":       anim_dur = 0.6
		"spin_jump":  anim_dur = 0.7; hop(380.0)
		"backflip":   anim_dur = 0.8; hop(440.0)
		"wiggle":     anim_dur = 0.7
		"nod":        anim_dur = 0.5
		"squish":     anim_dur = 0.5
		"tilt":       anim_dur = 0.6
		"dance":      anim_dur = 1.1; hop(220.0); hop_queue = 1; hop_queue_force = 220.0
		"dizzy":      anim_dur = 1.5          # cambaleia tonto (sacudida)
		"nausea":     anim_dur = 1.4          # balanço enjoado (sacudida)
		"scared":     anim_dur = 1.0; hop(150.0)   # tremor + pulinho de susto (sacudida)
		_:            anim_dur = 0.5; hop(320.0)

## Reação imediata (feedback direto do usuário): aparece NA HORA, substituindo o balão,
## e dura `hold` segundos. Pausa a notificação que estiver no ar (que retoma depois).
func say(msg: String, hold := REACTION_HOLD) -> void:
	react_text = msg
	react_hold = hold

## Notificação (automação/e-mail/lembrete): entra numa FILA e é exibida por MSG_DURATION
## (10s) na sua vez, sem se sobrepor às outras. Enquanto uma reação está no ar, a
## notificação atual pausa e retoma quando a reação some (ver o pump em _process). Item
## que espera mais de MAX_QUEUE_WAIT (60s) na fila é descartado (já não é relevante).
## Se veio logo após uma AÇÃO do usuário (janela urgent_cd), fura a fila e aparece na hora.
func notify(msg: String) -> void:
	if urgent_cd > 0.0:
		_preempt_with(msg)
	else:
		msg_queue.append({"text": msg, "wait": 0.0})

## Mostra `msg` imediatamente no lugar da notificação (resposta a uma ação do usuário),
## devolvendo a notificação de fundo que estava no ar à FRENTE da fila p/ retomar depois —
## assim a resposta do usuário fura a fila sem descartar o que estava rodando.
func _preempt_with(msg: String) -> void:
	if notify_hold > 0.0 and notify_text != "":
		msg_queue.push_front({"text": notify_text, "wait": 0.0})
	notify_text = msg
	notify_hold = MSG_DURATION

## Deduz a emoção do rosto a partir dos emojis da fala (prioridade pela ordem).
func _expression_from_text(msg: String) -> String:
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
			if msg.contains(e):
				return expr
	return "neutral"
