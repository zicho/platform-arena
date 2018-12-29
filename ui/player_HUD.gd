extends PanelContainer

func initialize_player_HUD(player_no):

	if player_no == 0: # PLAYER 1
		get_node("container/name_label").text = GLOBAL.PLAYER_NAMES["player"]
		GLOBAL.p1_hud["name"] = get_node("container/name_label").text
		GLOBAL.p1_hud["hp_value"] = get_node("container/hp_value")
		GLOBAL.p1_hud["hp_icon"] = get_node("container/hp_icon")
		GLOBAL.p1_hud["armor_value"] = get_node("container/armor_value")
		GLOBAL.p1_hud["armor_icon"] = get_node("container/armor_icon")
		GLOBAL.p1_hud["frag_value"] = get_node("container/frag_value")
		GLOBAL.p1_hud["frag_icon"] = get_node("container/frag_icon")

	if player_no == 1: # PLAYER 2
		get_node("container/name_label").text = GLOBAL.PLAYER_NAMES["player2"]
		GLOBAL.p2_hud["name"] = get_node("container/name_label").text
		GLOBAL.p2_hud["hp_value"] = get_node("container/hp_value")
		GLOBAL.p2_hud["hp_icon"] = get_node("container/hp_icon")
		GLOBAL.p2_hud["armor_value"] = get_node("container/armor_value")
		GLOBAL.p2_hud["armor_icon"] = get_node("container/armor_icon")
		GLOBAL.p2_hud["frag_value"] = get_node("container/frag_value")
		GLOBAL.p2_hud["frag_icon"] = get_node("container/frag_icon")

	if player_no == 2: # PLAYER 3
		get_node("container/name_label").text = GLOBAL.PLAYER_NAMES["player3"]
		GLOBAL.p3_hud["name"] = get_node("container/name_label").text
		GLOBAL.p3_hud["hp_value"] = get_node("container/hp_value")
		GLOBAL.p3_hud["hp_icon"] = get_node("container/hp_icon")
		GLOBAL.p3_hud["armor_value"] = get_node("container/armor_value")
		GLOBAL.p3_hud["armor_icon"] = get_node("container/armor_icon")
		GLOBAL.p3_hud["frag_value"] = get_node("container/frag_value")
		GLOBAL.p3_hud["frag_icon"] = get_node("container/frag_icon")

	if player_no == 3: # PLAYER 4
		get_node("container/name_label").text = GLOBAL.PLAYER_NAMES["player4"]
		GLOBAL.p4_hud["name"] = get_node("container/name_label").text
		GLOBAL.p4_hud["hp_value"] = get_node("container/hp_value")
		GLOBAL.p4_hud["hp_icon"] = get_node("container/hp_icon")
		GLOBAL.p4_hud["armor_value"] = get_node("container/armor_value")
		GLOBAL.p4_hud["armor_icon"] = get_node("container/armor_icon")
		GLOBAL.p4_hud["frag_value"] = get_node("container/frag_value")
		GLOBAL.p4_hud["frag_icon"] = get_node("container/frag_icon")