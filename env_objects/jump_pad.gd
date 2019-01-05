extends Node2D

export(int) var force

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.can_jump = false
		body.velocity.y -= force
		GLOBAL.SFX.play("pad")