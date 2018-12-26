extends Node

export (PackedScene) var level

func _ready():

	var level_instance = level.instance()
	self.add_child(level_instance)
	GLOBAL.level = level_instance

	GLOBAL.spawn_initial_players()
