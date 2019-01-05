extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = 15
	weapon_name = "MACHINE GUN"
	$info.text = "Press SWITCH WEAPON to pick up %s" % weapon_name

func _on_machine_gun_pickup_body_entered(body):
	.entered(body)

func _on_machine_gun_pickup_body_exited(body):
	.exited(body)
