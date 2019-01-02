extends "res://level_items/item_base.gd"

func _ready():
	respawn_time = 25
	
	self.add_to_group("armors")

func _on_red_armor_body_entered(body):

	if body.is_in_group("players"):
		if body.armor < 100:
			body.add_armor(100, GLOBAL.armor_types.red)
			.picked_up()
			GLOBAL.SFX.play("armor_pickup")
		elif body.armor == 100 and 	body.armor_type == GLOBAL.armor_types.yellow:
			body.add_armor(100, GLOBAL.armor_types.red)
			.picked_up()
			GLOBAL.SFX.play("armor_pickup")
