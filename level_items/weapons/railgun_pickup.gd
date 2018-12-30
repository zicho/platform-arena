extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	weapon_name = "RAILGUN"
	weapon_ref = preload("res://weapons/railgun.tscn")
	$info.text = "Press SWITCH WEAPON to pick up %s" % weapon_name

func _on_railgun_pickup_body_entered(body):
	.entered(body)

func _on_railgun_pickup_body_exited(body):
	.exited(body)