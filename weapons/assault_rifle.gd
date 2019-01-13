extends "res://weapons/weapon_base.gd"

onready var armor_damage

func _ready():
	damage = WEAPON_SETTINGS.assault_rifle_damage
	spread = WEAPON_SETTINGS.assault_rifle_spread
	armor_damage = WEAPON_SETTINGS.assault_rifle_armor_damage
	set_cooldown_time(WEAPON_SETTINGS.assault_rifle_delay)
	set_ammo(WEAPON_SETTINGS.assault_rifle_ammo)
	
func reset_ammo():
	set_ammo(WEAPON_SETTINGS.assault_rifle_ammo)
	
func shoot(dir):

	if not connected:
		cd_timer.connect("timeout", shooter, "can_shoot")
		connected = true

	if shooter.can_shoot:

		if projectile:
			if ammo > 0:
				ammo -= 1
			var bullet = projectile.instance()
			GLOBAL.level.add_child(bullet)

			bullet.damage = self.damage
			bullet.armor_damage = self.armor_damage

			bullet._spawn(barrel.global_position, Vector2(dir.x, (dir.y + rand_range(-spread, spread))), shooter_ref)

			GLOBAL.SFX.play(self.name)

		shooter.can_shoot = false
		cd_timer.start()	