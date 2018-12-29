extends Node2D

export (PackedScene) var item_to_spawn
export (float) var item_respawn_time = 0.5

onready var spawn_pos = get_node("spawn_pos").global_position

var held_item
var respawn_timer = Timer.new()

func _ready():
	call_deferred("spawn_item")
	respawn_timer.set_wait_time(item_respawn_time)
	respawn_timer.set_one_shot(true)
	respawn_timer.connect("timeout", self, "spawn_item")
	add_child(respawn_timer)
	
	

func spawn_item():

	held_item = item_to_spawn.instance()
	get_parent().add_child(held_item)
	held_item._spawn(spawn_pos, self)
	if held_item.is_in_group("med_items"):
		$sfx.stream = load("res://sfx/health_pickup.wav")
	if held_item.is_in_group("armors"):
		$sfx.stream = load("res://sfx/armor_pickup.wav")

func item_picked(item):
	if item == self.held_item:
		respawn_timer.start()
		if $sfx: $sfx.play()