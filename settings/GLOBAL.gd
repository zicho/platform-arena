extends Node

onready var level
onready var LEVEL_LIST

enum armor_types { yellow, red }

var DAMAGE_DEBUG = false

## CONTROLS

var player1 = {
	"name": null,
	"color": "D5452F",
	"right": "p1_right",
	"left": "p1_left",
	"jump": "p1_jump",
	"shoot": "p1_shoot",
	"turnlock": "p1_turnlock",
	"switch_weapon": "p1_switch_weapon",
	"pick_up_weapon": "p1_pick_up_weapon",
	"frags": 0
}

var player2 = {
	"name": null,
	"color": "59B8FF",
	"right": "p2_right",
	"left": "p2_left",
	"jump": "p2_jump",
	"shoot": "p2_shoot",
	"turnlock": "p2_turnlock",
	"switch_weapon": "p2_switch_weapon",
	"pick_up_weapon": "p2_pick_up_weapon",
	"frags": 0
}

var player3 = {
	"name": null,
	"color": "32CD32",
	"right": "p3_right",
	"left": "p3_left",
	"jump": "p3_jump",
	"shoot": "p3_shoot",
	"turnlock": "p3_turnlock",
	"switch_weapon": "p3_switch_weapon",
	"pick_up_weapon": "p3_pick_up_weapon",
	"frags": 0
}

var player4 = {
	"name": null,
	"color": "FFD700",
	"right": "p4_right",
	"left": "p4_left",
	"jump": "p4_jump",
	"shoot": "p4_shoot",
	"turnlock": "p4_turnlock",
	"switch_weapon": "p4_switch_weapon",
	"pick_up_weapon": "p4_pick_up_weapon",
	"frags": 0
}

# control elements

var p1_hud = { 
	"name": null, 
	"hp_value": null,
	"hp_icon": null,
	"armor_value": null,
	"armor_icon": null,
	"frag_value": null,
	"frag_icon": null
}

var p2_hud = { 
	"name": null, 
	"hp_value": null,
	"hp_icon": null,
	"armor_value": null,
	"armor_icon": null,
	"frag_value": null,
	"frag_icon": null
}

var p3_hud = { 
	"name": null, 
	"hp_value": null,
	"hp_icon": null,
	"armor_value": null,
	"armor_icon": null,
	"frag_value": null,
	"frag_icon": null
}

var p4_hud = { 
	"name": null, 
	"hp_value": null,
	"hp_icon": null,
	"armor_value": null,
	"armor_icon": null,
	"frag_value": null,
	"frag_icon": null
}

var PLAYER_NAMES = { 
	"player1": "Player 1", 
	"player2": "Player 2", 
	"player3": "Player 3", 
	"player4": "Player 4" 
}

# GLOBAL

onready var NO_OF_PLAYERS = 4 # max 4
enum PLAYERS { player1, player2, player3, player4 }

# INSTAGIB
var MODE_INSTAGIB = false

# LAST MAN STANDING
var MODE_LAST_MAN_STANDING = false
var PLAYERS_LEFT = 0
var ROUND_RESET = Timer.new()
var ROUND_RESET_TIME = 4

var RESPAWN_TIME = 2
var NO_DAMAGE_AFTER_SPAWN_TIME = 4
var FRAG_LIMIT = 10

var MESSAGE_LOG

var SFX = preload("res://helpers/sfx_library.tscn").instance()

var GAME_ACTIVE = false

func _ready():
	#print(load_levels_from_dir("res://levels"))
	LEVEL_LIST = load_levels_from_dir("res://levels")
	
	add_child(SFX)
	
	player1.name = PLAYER_NAMES["player1"]
	player2.name = PLAYER_NAMES["player2"]
	player3.name = PLAYER_NAMES["player3"]
	player4.name = PLAYER_NAMES["player4"]
	
	MESSAGE_LOG = get_tree().get_root().get_node("main/interface/interface_panel/PLAYER_HUDS/message_log")
	
	ROUND_RESET.set_wait_time(ROUND_RESET_TIME)
	ROUND_RESET.connect("timeout", self, "spawn_initial_players")
	ROUND_RESET.set_one_shot(true)
	add_child(ROUND_RESET)

func initialize_HUD():
	var main_menu = get_tree().get_root().get_node("main/main_menu")
	if main_menu: main_menu.initialize_HUD()

func update_frags(player_instance, value):

	var hud_to_update

	if player_instance == "player1": hud_to_update = p1_hud 
	elif player_instance == "player2": hud_to_update = p2_hud
	elif player_instance == "player3": hud_to_update = p3_hud
	elif player_instance == "player4": hud_to_update = p4_hud

	if hud_to_update["frag_value"]: hud_to_update["frag_value"].text = str(value)

func spawn_initial_players():
	
	PLAYERS_LEFT = 0 # this must be reset after each rtound in last man standing
	
	var assign_player = 0

	for p in NO_OF_PLAYERS:
		var player = load("res://entities/player.tscn").instance()
		if assign_player == 0:
			player.controlled_by = PLAYERS.player1
		if assign_player == 1:
			player.controlled_by = PLAYERS.player2
		if assign_player == 2:
			player.controlled_by = PLAYERS.player3
		if assign_player == 3:
			player.controlled_by = PLAYERS.player4

		assign_player += 1
		player.spawn()
		player.can_take_damage() # the invincibilty only is available after the initial spawn

func respawn_player(controlled_by):
	if GAME_ACTIVE:
		var player = load("res://entities/player.tscn").instance()
		player.controlled_by = controlled_by
		player.spawn()

func update_gui_hp(hp, player):

	var p = player.instance_name
	var hud_to_update

	if p == "player1": hud_to_update = p1_hud 
	elif p == "player2": hud_to_update = p2_hud
	elif p == "player3": hud_to_update = p3_hud
	elif p == "player4": hud_to_update = p4_hud

	if hud_to_update["hp_value"]: hud_to_update["hp_value"].text = str(hp)

func player_wins(player, color):
	var win_label = get_tree().get_root().get_node("main/win_label")
	var win_label_text = get_tree().get_root().get_node("main/win_label/Panel/win_label_text")
	
	win_label_text.text = ""
	win_label_text.append_bbcode("[color=#%s]%s[/color] wins!!!" % [color, player])
	
	win_label.visible = true
	GAME_ACTIVE = false
	
	for p in get_tree().get_nodes_in_group("players"):
		p.can_take_damage = true
		p.sprite.set_modulate(p.player.color)
		p.get_node("anim").stop()

func update_gui_armor(armor, armor_type, player):

	var p = player.instance_name
	
	var hud_to_update

	if p == "player1": hud_to_update = p1_hud 
	elif p == "player2": hud_to_update = p2_hud
	elif p == "player3": hud_to_update = p3_hud
	elif p == "player4": hud_to_update = p4_hud

	if hud_to_update["armor_value"]: hud_to_update["armor_value"].text = str(armor)

	if hud_to_update["armor_icon"]:
		if armor_type == 0:
			hud_to_update["armor_icon"].set_modulate("fffb00")
		if armor_type == 1:
			hud_to_update["armor_icon"].set_modulate("b30000")
		if armor == 0:
			hud_to_update["armor_icon"].set_modulate("ffffff")

func load_levels_from_dir(path):

	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file == "test_level.tscn":
			break
		elif not file.begins_with(".") and file.ends_with(".tscn"):
			files.append(file)
	dir.list_dir_end()

	return files
#	var levels = []
#
#	for f in files:
#		var level = load(f)
#		levels.append(level)
#
#	return levels