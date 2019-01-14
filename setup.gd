extends PanelContainer

onready var no_of_players = get_node("main/Container/no_of_players_number")
onready var frag_limit = get_node("main/Container/frag_limit_number")

onready var level_name = get_node("main/Container3/level_name")
onready var selected_level
var selected_level_index = 0


func _ready():
	no_of_players.text = str(GLOBAL.NO_OF_PLAYERS)
	frag_limit.text = str(GLOBAL.FRAG_LIMIT)
	
	select_level(selected_level_index)

func select_level(index):
	selected_level = load("res://levels/%s" % GLOBAL.LEVEL_LIST[index])

	if selected_level.instance().level_name == null:
		level_name.text = selected_level.instance().name
	else:
		level_name.text = selected_level.instance().level_name

func _on_increment_players_pressed():
	change_no_of_players(1)

func _on_decrement_players_pressed():
	change_no_of_players(-1)

func change_no_of_players(value):
	if value < 0:
		GLOBAL.NO_OF_PLAYERS -= 1
	else:
		GLOBAL.NO_OF_PLAYERS += 1

	if GLOBAL.NO_OF_PLAYERS == 5:
		GLOBAL.NO_OF_PLAYERS = 1
	if GLOBAL.NO_OF_PLAYERS == 0:
		GLOBAL.NO_OF_PLAYERS = 4

	no_of_players.text = str(GLOBAL.NO_OF_PLAYERS)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		play()

func play():
	GLOBAL.level = load("res://levels/test_level.tscn").instance()
	#GLOBAL.level = selected_level.instance()
	get_tree().change_scene("res://main.tscn")

func _on_Button_pressed():
	play()

func _on_increment_frags_pressed():
	GLOBAL.FRAG_LIMIT += 1
	frag_limit.text = str(GLOBAL.FRAG_LIMIT)

func _on_decrement_frags_pressed():
	if GLOBAL.FRAG_LIMIT > 1:
		GLOBAL.FRAG_LIMIT -= 1
		frag_limit.text = str(GLOBAL.FRAG_LIMIT)

func _on_next_level_pressed():
	selected_level_index += 1
	
	if selected_level_index + 1 > GLOBAL.LEVEL_LIST.size():
		selected_level_index = 0
	
	select_level(selected_level_index)

func _on_prev_level_pressed():
	selected_level_index -= 1
	
	if selected_level_index < 0:
		selected_level_index = GLOBAL.LEVEL_LIST.size() - 1
	
	select_level(selected_level_index)

func _on_chb_instagib_pressed():
	if GLOBAL.MODE_INSTAGIB:
		GLOBAL.MODE_INSTAGIB = false
		WEAPON_SETTINGS.unload_instagib_settings()
	else:
		GLOBAL.MODE_INSTAGIB = true
		WEAPON_SETTINGS.load_instagib_settings()

func _on_chb_last_man_pressed():
	if GLOBAL.MODE_LAST_MAN_STANDING:
		GLOBAL.MODE_LAST_MAN_STANDING = false
	else:
		GLOBAL.MODE_LAST_MAN_STANDING = true
