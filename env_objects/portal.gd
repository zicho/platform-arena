extends Node2D

onready var dest = find_node("dest")
onready var fx = find_node("fx")

func _ready():
	fx.global_position = dest.global_position

func _on_start_body_entered(body):
	if body.is_in_group("players"):
		
		body.push_force = 0
		body.global_position = dest.global_position
		var fx = load("res://particles/player_appears.tscn").instance()
		GLOBAL.level.add_child(fx) 
		fx.global_position = dest.global_position
