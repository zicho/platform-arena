extends "res://projectiles/projectile_base.gd"

func _ready():
	pass

func _on_pulse_projectile_body_entered(body):
	
	if body.is_in_group("players"):
		if body.instance_name != self.shooter:
			
			if motion.x < 0:
				body.push(-knockback, WEAPON_SETTINGS.pulse_blaster_knockback)
			else:
				body.push(knockback, WEAPON_SETTINGS.pulse_blaster_knockback)
				
			body.take_damage(damage, shooter)
			body.hit_effect(damage, motion.x)
			.destroy()
	else:
		.destroy()
