extends "res://level_items/item_base.gd"

func _on_yellow_armor_body_entered(body):
	if body.is_in_group("players"):
		if body.armor < 100:
			body.add_armor(75, GLOBAL.armor_types.yellow)
			.picked_up()
