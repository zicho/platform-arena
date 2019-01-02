extends Node2D

export (PackedScene) var item_to_spawn

onready var spawn_pos = get_node("spawn_pos").global_position

var held_item
var respawn_timer = Timer.new()

func _ready():
	call_deferred("spawn_item")
	spawn_item()
	add_child(respawn_timer)

func spawn_item():

	if GLOBAL.GAME_ACTIVE:
		held_item = item_to_spawn.instance()
		add_child(held_item)

		respawn_timer.set_wait_time(held_item.respawn_time)
		respawn_timer.set_one_shot(true)
		respawn_timer.connect("timeout", self, "spawn_item")

		held_item._spawn(spawn_pos, self)

func item_picked(item):
	if item == self.held_item:
		respawn_timer.start()