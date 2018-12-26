extends "res://level_items/item_base.gd"

func _on_medpack_body_entered(body):
	if body.is_in_group("players"):
		if body.hp < 100:
			body.update_hp(body.hp + 50)
			.picked_up()