extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = ITEM_SETTINGS.weapon_respawn_time
	weapon_name = "ION CANNON"
	weapon_ref = preload("res://weapons/ion_cannon.tscn")
	ammo = WEAPON_SETTINGS.ion_cannon_ammo
	max_ammo = WEAPON_SETTINGS.ion_cannon_ammo
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name

func _on_ion_cannon_pickup_body_entered(body):
	.entered(body)

func _on_ion_cannon_pickup_body_exited(body):
	.exited(body)
