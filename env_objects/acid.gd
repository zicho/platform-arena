extends Area2D



func _process(delta):
	pass

func _on_acid_body_entered(body):
	if body.is_in_group("players"):
		body.take_acid_damage = true
		body.in_acid = true

func _on_acid_body_exited(body):
	if body.is_in_group("players"):
		print("left")
		body.take_acid_damage = false
		body.in_acid = false
