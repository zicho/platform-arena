extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = ITEM_SETTINGS.weapon_respawn_time
	weapon_name = "ASSAULT RIFLE"
	weapon_ref = preload("res://weapons/assault_rifle.tscn")
	ammo = WEAPON_SETTINGS.assault_rifle_ammo
	max_ammo = WEAPON_SETTINGS.assault_rifle_ammo
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name
	
func _on_assault_rifle_pickup_body_entered(body):
	.entered(body)

func _on_assault_rifle_pickup_body_exited(body):
	.exited(body)
