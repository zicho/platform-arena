extends "res://level_items/weapons/weapon_pickup_base.gd"

func _ready():
	respawn_time = 15
	weapon_name = "PULSE BLASTER"
	weapon_ref = preload("res://weapons/pulse_blaster.tscn")
	ammo = WEAPON_SETTINGS.pulse_blaster_ammo
	max_ammo = WEAPON_SETTINGS.pulse_blaster_ammo
	$info.text = "Press PICK UP WEAPON to pick up %s" % weapon_name

func _on_pulse_blaster_pickup_body_entered(body):
	.entered(body)

func _on_pulse_blaster_pickup_body_exited(body):
	.exited(body)