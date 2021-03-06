extends Node2D

onready var belongs_to
onready var respawn_time = 5

signal picked_up(item)

func _ready():

	respawn_time = 0.1
	var anim = get_node("anim")
	if anim:
		anim.play("hover")

func picked_up():
	emit_signal("picked_up", self)
	queue_free()

func _spawn(_pos, _item_slot):
	belongs_to = _item_slot
	global_position = _pos
	connect("picked_up", belongs_to, "item_picked")