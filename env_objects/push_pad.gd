extends Node2D

export(int) var force
export(float) var delay

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.velocity.y = 0
		body.push(force, delay)
		GLOBAL.SFX.play("pad")
