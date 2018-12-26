extends "res://projectiles/projectile_base.gd"

func _on_projectile_base_body_entered(body):
	
	if body.is_in_group("players"):
		if body != shooter:
			body.take_damage(damage, shooter)
			.destroy()
	else:		
		.destroy()