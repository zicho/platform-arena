extends Node

func _ready():
	GLOBAL.initialize_HUD()
	GLOBAL.GAME_ACTIVE = true
	$win_label.visible = false
	