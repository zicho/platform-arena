extends Node2D

var timer = Timer.new()

func _ready():
	var fx = get_node("fx")
	fx.one_shot = true
	fx.emitting = true
	add_child(timer)
	timer.set_wait_time($fx.lifetime)
	timer.connect("timeout", self, "destroy")
	timer.start()
	if $sfx: $sfx.play()
	
func destroy():
	queue_free()