extends "res://projectiles/projectile_base.gd"

onready var armor_damage

func _ready():
	pass

func _on_assault_rifle_projectile_body_entered(body):
	if body.is_in_group("players"):
		if body.instance_name != shooter:
			body.take_flat_damage(damage, armor_damage, shooter)
			body.hit_effect(damage, motion.x)
			.destroy()
	else:
		.destroy()
