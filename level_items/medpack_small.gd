extends "res://level_items/item_base.gd"

func _ready():
	respawn_time = 15
	self.add_to_group("med_items")

func _on_medpack_small_body_entered(body):
	if body.is_in_group("players"):
		if body.hp < 100:
			body.update_hp(body.hp + 15)
			.picked_up()
			GLOBAL.SFX.play("health_pickup")