extends Node2D

export(int) var force
export(float) var delay

func _ready():
	pass

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.velocity.y = 0
		body.push(force, delay)
		body.can_jump = false
		body.velocity.y -= abs(force)
		body.diagonal_push = true
		GLOBAL.SFX.play("pad")
		print("diagonal push: %s" % body.diagonal_push)
