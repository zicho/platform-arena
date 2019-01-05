extends "res://weapons/weapon_base.gd"

func _ready():
	damage = WEAPON_SETTINGS.rocket_launcher_damage
	set_cooldown_time(WEAPON_SETTINGS.rocket_launcher_delay)
	set_ammo(WEAPON_SETTINGS.rocket_launcher_ammo)