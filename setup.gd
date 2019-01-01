extends PanelContainer

onready var no_of_players = get_node("main/Container/no_of_players_number")
onready var frag_limit = get_node("main/Container/frag_limit_number")

func _ready():
	no_of_players.text = str(GLOBAL.NO_OF_PLAYERS)
	frag_limit.text = str(GLOBAL.FRAG_LIMIT)

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
