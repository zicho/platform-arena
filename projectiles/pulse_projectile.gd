extends "res://projectiles/projectile_base.gd"

func _ready():
	pass

func _on_pulse_projectile_body_entered(body):
	
	if body.is_in_group("players"):
		if body != self.shooter:
			
			if motion.x < 0:
				body.push(-knockback, 0.15)
			else:	
				print("else")
				body.push(knockback, 0.15)
				
			body.take_damage(damage, shooter)
			.destroy()
	else:		
		.destroy()
