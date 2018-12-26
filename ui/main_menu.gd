extends PanelContainer

func initialize_HUD():
	
	var hud_to_init = 0
	var player_huds = get_tree().get_nodes_in_group("player_HUD")
	
	for p in player_huds:
		p.visible = false
	
	for p in GLOBAL.NO_OF_PLAYERS:
		player_huds[hud_to_init].visible = true
		player_huds[hud_to_init].initialize_player_HUD(hud_to_init)
		hud_to_init += 1
		
