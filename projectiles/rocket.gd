extends "res://projectiles/projectile_base.gd"

onready var explosion = preload("res://projectiles/explosion.tscn")

func _process(delta):
	speed += 24

func _on_rocket_body_entered(body):
	if body.is_in_group("players"):
		if body != shooter:
			#body.take_damage(damage, shooter)
			destroy()
	else:		
		destroy()

func destroy():
	var e = explosion.instance()
	self.queue_free()
	e.shooter = shooter
	GLOBAL.level.add_child(e)
	e.global_position = self.global_position