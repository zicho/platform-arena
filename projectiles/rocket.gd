extends "res://projectiles/projectile_base.gd"

onready var explosion = preload("res://projectiles/explosion.tscn")
onready var exploded = false

func _process(delta):
	speed += WEAPON_SETTINGS.rocket_acceleration

func _on_rocket_body_entered(body):
	if body.is_in_group("players"):
		if body.instance_name != shooter:
			#body.take_damage(damage, shooter)
			destroy()
	else:		
		destroy()

func destroy():
	var e = explosion.instance()
	e.damage = self.damage
	self.queue_free()
	
	if not exploded:
		exploded = true
		e.spawn(global_position, shooter)