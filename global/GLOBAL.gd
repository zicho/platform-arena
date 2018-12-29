extends Node

onready var level

enum armor_types { yellow, red }

var DAMAGE_DEBUG = false

## CONTROLS

var p1 = {
	"color": "D5452F",
	"right": "p1_right",
	"left": "p1_left",
	"jump": "p1_jump",
	"shoot": "p1_shoot",
	"turnlock": "p1_turnlock",
	"switch_weapon": "p1_switch_weapon",
}

var p2 = {
	"color": "59B8FF",
	"right": "p2_right",
	"left": "p2_left",
	"jump": "p2_jump",
	"shoot": "p2_shoot",
	"turnlock": "p2_turnlock",
	"switch_weapon": "p2_switch_weapon",
}

var p3 = {
	"color": "32CD32",
	"right": "p3_right",
	"left": "p3_left",
	"jump": "p3_jump",
	"shoot": "p3_shoot",
	"turnlock": "p3_turnlock",
	"switch_weapon": "p3_switch_weapon",
}


var p4 = {
	"color": "FFD700",
	"right": "p4_right",
	"left": "p4_left",
	"jump": "p4_jump",
	"shoot": "p4_shoot",
	"turnlock": "p4_turnlock",
	"switch_weapon": "p4_switch_weapon",
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

onready var NO_OF_PLAYERS = 4 # max 4
enum PLAYERS { player1, player2, player3, player4 }

var RESPAWN_TIME = 2
var FRAG_LIMIT = 1

func _ready():

	var main_menu = get_tree().get_root().get_node("main/main_menu")
	
	if main_menu: main_menu.initialize_HUD()

func update_frags(player_instance, value):

	var hud_to_update

	if player_instance == "player": hud_to_update = p1_hud 
	elif player_instance == "player2": hud_to_update = p2_hud
	elif player_instance == "player3": hud_to_update = p3_hud
	elif player_instance == "player4": hud_to_update = p4_hud

	if hud_to_update["frag_value"]: hud_to_update["frag_value"].text = str(value)

func spawn_initial_players():

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


func respawn_player(controlled_by):
	var player = load("res://entities/player.tscn").instance()
	player.controlled_by = controlled_by
	player.spawn()

func update_gui_hp(hp, player):

	var p = player.instance_name
	var hud_to_update

	if p == "player": hud_to_update = p1_hud 
	elif p == "player2": hud_to_update = p2_hud
	elif p == "player3": hud_to_update = p3_hud
	elif p == "player4": hud_to_update = p4_hud

	if hud_to_update["hp_value"]: hud_to_update["hp_value"].text = str(hp)

func update_gui_armor(armor, armor_type, player):

	var p = player.instance_name
	
	var hud_to_update

	if p == "player": hud_to_update = p1_hud 
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