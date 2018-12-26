extends Particles2D

func _ready():
	
	var delete_timer = Timer.new()		
	delete_timer.connect("timeout", self, "delete")
	delete_timer.set_one_shot(true)
	delete_timer.set_wait_time(self.lifetime*2)

	add_child(delete_timer)
	delete_timer.start()
	
func delete():
	queue_free()	
