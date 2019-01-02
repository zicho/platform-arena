extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = 15
	weapon_name = "SHOTGUN"
	weapon_ref = preload("res://weapons/shotgun.tscn")
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name

func _on_shotgun_pickup_body_entered(body):
	.entered(body)

func _on_shotgun_pickup_body_exited(body):
	.exited(body)
