extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	weapon_name = "ION CANNON"
	weapon_ref = preload("res://weapons/ion_cannon.tscn")
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name

func _on_ion_cannon_pickup_body_entered(body):
	.entered(body)

func _on_ion_cannon_pickup_body_exited(body):
	.exited(body)
