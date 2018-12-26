extends "res://level_items/item_base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(String) var weapon_name
export(PackedScene) var weapon_ref

func entered(body):
	if body.is_in_group("players"):
		if not body.weapon.get_filename() == weapon_ref.get_path() and not body.secondary_weapon.get_filename() == weapon_ref.get_path():
			$info.visible = true
			
func exited(body):
	if body.is_in_group("players"):
		$info.visible = false

func player_is_on_pickup(player):

	for b in get_overlapping_bodies():
		if b == player:
			if not b.weapon.get_filename() == weapon_ref.get_path() and not b.secondary_weapon.get_filename() == weapon_ref.get_path():
				return true
		else:
			return false