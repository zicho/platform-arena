extends Node2D

export(int) var force
export(float) var delay

func _ready():
	if force < 0:
		$area/fx.scale = Vector2(-1, 1)

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.velocity.y = 0
		body.push(force, delay)
		GLOBAL.SFX.play("pad")
