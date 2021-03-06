extends "res://level_items/item_base.gd"

export(String) var weapon_name
export(PackedScene) var weapon_ref

var ammo = 0
var max_ammo = 0

func entered(body):
	if body.is_in_group("players"):
		
		if not body.has_weapon(weapon_ref):
			$info.visible = true
		elif body.weapon.get_filename() == weapon_ref.get_path():
			if body.weapon.ammo != max_ammo:
				body.weapon.ammo = ammo
				.picked_up()
				GLOBAL.SFX.play("weapon_pickup")

		elif body.secondary_weapon.get_filename() == weapon_ref.get_path():
			weapon_ref.instance()._ready()
			if body.weapon.ammo != max_ammo:
				body.secondary_weapon.ammo = ammo
				.picked_up()
				GLOBAL.SFX.play("weapon_pickup")

func exited(body):
	if body.is_in_group("players"):
		$info.visible = false

func player_is_on_pickup(player):

	for b in get_overlapping_bodies():
		if b == player:
			if not b.weapon.get_filename() == weapon_ref.get_path():
				return true
			elif b.secondary_weapon != null:
				if b.secondary_weapon.get_filename() == weapon_ref.get_path():	
					return true
		else:
			return false