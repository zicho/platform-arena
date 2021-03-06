extends Node2D

onready var dest = find_node("dest")
onready var fx = find_node("fx")

export(bool) var fx_enabled = true

func _ready():
	if fx_enabled:
		fx.global_position = dest.global_position
	else: fx.visible = false

func _on_start_body_entered(body):
	if body.is_in_group("players"):

		body.push_force = 0
		body.global_position = dest.global_position
		var fx = load("res://particles/player_appears.tscn").instance()
		GLOBAL.level.add_child(fx) 
		fx.global_position = dest.global_position
		GLOBAL.SFX.play("portal")
