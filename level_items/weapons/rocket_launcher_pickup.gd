extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = 15
	weapon_name = "ROCKET LAUNCHER"
	weapon_ref = preload("res://weapons/rocket_launcher.tscn")
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name

func _on_rocket_launcher_pickup_body_entered(body):
	.entered(body)

func _on_rocket_launcher_pickup_body_exited(body):
	.exited(body)