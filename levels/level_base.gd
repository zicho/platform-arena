extends TileMap

export(String) var level_name

func _ready():
	if self.level_name == null:
		self.level_name = name
