extends "res://weapons/weapon_base.gd"

var pellets = 18

func shoot(dir):

	if not connected:
		cd_timer.connect("timeout", shooter, "can_shoot")
		connected = true

	if shooter.can_shoot:
		ammo -= 1
		if projectile:
			
			for p in pellets:
				var bullet = projectile.instance()

				bullet.speed = bullet.speed + rand_range(-200, 200) 

				GLOBAL.level.add_child(bullet)
				bullet.shooter = self.shooter
				bullet.damage = self.damage
				bullet._spawn(barrel.global_position, Vector2(dir.x, (dir.y + rand_range(-spread, spread))))

		shooter.can_shoot = false
		cd_timer.start()