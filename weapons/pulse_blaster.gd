extends "res://weapons/weapon_base.gd"

func _ready():
	damage = WEAPON_SETTINGS.pulse_blaster_damage
	set_cooldown_time(WEAPON_SETTINGS.pulse_blaster_delay)
	set_ammo(WEAPON_SETTINGS.pulse_blaster_ammo)