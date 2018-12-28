extends "res://weapons/weapon_base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


var ray_hit = Vector2()
var shot_range = 500

var damage_timer = Timer.new()
var damage_cooldown = 0.1
var do_damage = true

var ammo_timer = Timer.new()
var ammo_cooldown = 0.025
var decrease_ammo = true

func _ready():

	damage_timer.connect("timeout", self, "do_damage")
	damage_timer.set_wait_time(damage_cooldown)
	add_child(damage_timer)
	
	ammo_timer.connect("timeout", self, "decrease_ammo")
	ammo_timer.set_wait_time(ammo_cooldown)
	add_child(ammo_timer)

func do_damage():
	do_damage = true
	
func decrease_ammo():
	decrease_ammo = true

func _process(delta):

	var player

	if shooter:
		if shooter.instance_name == "player":
			player = GLOBAL.p1
		if shooter.instance_name == "player2":
			player = GLOBAL.p2
		if shooter.instance_name == "player3":
			player = GLOBAL.p3
		if shooter.instance_name == "player4":
			player = GLOBAL.p4
			
	if shooter:
		if Input.is_action_pressed(player.shoot):
			$trail.visible = true
		else:
			$trail.visible = false

func shoot(dir):
	
	cd_timer.connect("timeout", shooter, "can_shoot")
	
	if shooter.can_shoot:
		
		if decrease_ammo:
			decrease_ammo = false
			ammo -=1
			ammo_timer.start()

		$ray.global_position = $barrel.global_position
		
		if dir.x == 1:
			$ray.cast_to = Vector2(shot_range, 0)
		else:
			$ray.cast_to = Vector2(-shot_range, 0)

		$ray.add_exception(get_parent())
		$ray.force_raycast_update()

		ray_hit = $ray.get_collision_point()

		if $ray.is_colliding():

			var collider = $ray.get_collider()
			
			var p = load("res://particles/ion_hit.tscn").instance()
			GLOBAL.level.add_child(p)
			p.global_position = ray_hit
			
			if collider != get_parent():
				if collider.is_in_group("players"):
					if do_damage:
						do_damage = false
						collider.take_damage(damage, get_parent())
						collider.hit_effect(damage, shot_range)
						damage_timer.start()
						
		else:
			ray_hit = Vector2(0,0)

		if $trail:
			
			$trail.global_position = Vector2(0,0)
			
			for p in $trail.get_point_count():
				$trail.remove_point(0)

			$trail.add_point($ray.get_global_position())

			if dir.x == 1 and ray_hit.x == 0:
				$trail.add_point($ray.get_global_position() + Vector2(shot_range,0))
			elif dir.x == -1 and ray_hit.x == 0:
				$trail.add_point($ray.get_global_position() + Vector2(-shot_range,0))
			elif ray_hit.x > 0:
				$trail.add_point(ray_hit)

		shooter.can_shoot = false
		cd_timer.start()