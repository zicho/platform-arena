extends Node2D

export(int) var force

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.velocity.y -= force
		if $sfx: $sfx.play()