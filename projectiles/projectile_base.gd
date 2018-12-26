extends Node2D

var motion = Vector2()
var shooter
var damage

export var speed = 1200
export var knockback = 0

func _spawn(_pos, _dir):
	global_position = _pos
	motion = _dir * speed
	if motion.x > 0:
		$gfx.flip_h = true
	else:
		$gfx.flip_h = false
		
func _physics_process(delta):
	
	motion = motion.normalized() * speed
	global_position += motion * delta 
	
func destroy():
	queue_free()	
	