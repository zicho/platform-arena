extends Sprite

func _ready():
	$anim.play("fade")
	offset = Vector2(12,0)
	var kill_timer = Timer.new()
	kill_timer.connect("timeout", self, "destroy")
	kill_timer.set_wait_time($anim.get_animation("fade").length)
	kill_timer.start()
	add_child(kill_timer)

func destroy():
	queue_free()
