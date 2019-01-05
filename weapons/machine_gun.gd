extends "res://weapons/weapon_base.gd"

func _ready():
	damage = WEAPON_SETTINGS.machine_gun_damage
	set_cooldown_time(WEAPON_SETTINGS.machine_gun_delay)