extends "res://weapons/weapon_base.gd"

onready var trail = preload("res://effects/railgun_trail.tscn")

var ray_hit = Vector2()
var shot_range = 2000

func _ready():
	damage = WEAPON_SETTINGS.railgun_damage
	shooter = get_parent()
	shooter_ref = shooter.instance_name
	set_cooldown_time(WEAPON_SETTINGS.railgun_delay)
	if GLOBAL.MODE_INSTAGIB:
		set_ammo(-1)
	else:
		set_ammo(WEAPON_SETTINGS.railgun_ammo)

func shoot(dir):

	if not connected:
		cd_timer.connect("timeout", shooter, "can_shoot")
		connected = true
		
	if shooter.can_shoot:
		
		GLOBAL.SFX.play("railgun")

		ammo -= 1
		
		$ray.global_position = $barrel.global_position

#		if dir.x == 1:
		$ray.cast_to = Vector2(shot_range, 0)
#		else:
#			$ray.cast_to = Vector2(-shot_range, 0)

		$ray.add_exception(get_parent())
		$ray.force_raycast_update()
		
		ray_hit = $ray.get_collision_point()
		
		var hit_effect = load("res://particles/rail_hit.tscn").instance()
		GLOBAL.level.add_child(hit_effect)
		hit_effect.emitting = true
		hit_effect.global_position = ray_hit
		hit_effect.set_modulate(shooter.player.color)
		hit_effect.get_node("anim").play("fade")
		
		if dir.x > 0:
			hit_effect.scale = Vector2(-1,1)
		
		if $ray.is_colliding():

			var collider = $ray.get_collider()
			if collider != get_parent():
				if collider.is_in_group("players"):
					collider.hit_effect(damage, dir.x)
					collider.take_damage(damage, shooter_ref)

		var t = trail.instance()

		if t:
			
			GLOBAL.level.add_child(t)
			t.global_position = Vector2(0,0)
			t.set_modulate(get_parent().player.color)
			
			for p in t.get_point_count():
				t.remove_point(0)
			
			t.add_point($ray.get_global_position())
			t.add_point(ray_hit)

		shooter.can_shoot = false
		cd_timer.start()