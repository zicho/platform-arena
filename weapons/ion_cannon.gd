extends "res://weapons/weapon_base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


var ray_hit = Vector2()
var shot_range = 500

var damage_timer = Timer.new()
var damage_cooldown = 0.1 # pause between doing damage
var do_damage = true

var ammo_timer = Timer.new()
var ammo_cooldown = 0.05
var decrease_ammo = true

var increase_damage_timer = Timer.new()
var increase_damage = false

var damage_increase_reset = Timer.new()
var target # damage is reset if target is changed

func _ready():
	shooter = get_parent()
	shooter_ref = shooter.instance_name
	damage = WEAPON_SETTINGS.ion_cannon_damage
	damage_timer.connect("timeout", self, "do_damage")
	damage_timer.set_wait_time(damage_cooldown)
	add_child(damage_timer)

	ammo_timer.connect("timeout", self, "decrease_ammo")
	ammo_timer.set_wait_time(ammo_cooldown)
	add_child(ammo_timer)

	set_ammo(WEAPON_SETTINGS.ion_cannon_ammo)
	set_cooldown_time(WEAPON_SETTINGS.ion_cannon_delay)
	
	increase_damage_timer.connect("timeout", self, "increase_damage")
	increase_damage_timer.set_wait_time(WEAPON_SETTINGS.ion_cannon_damage_increase_time)
	add_child(increase_damage_timer)
	
	damage_increase_reset.connect("timeout", self, "damage_increase_reset")
	damage_increase_reset.set_wait_time(WEAPON_SETTINGS.ion_cannon_damage_increase_reset)
	add_child(damage_increase_reset)

func increase_damage():
	increase_damage = true
	
func damage_increase_reset():
	increase_damage = false
	damage = WEAPON_SETTINGS.ion_cannon_damage
	target = null

func do_damage():
	do_damage = true
	
func decrease_ammo():
	decrease_ammo = true

func _process(delta):

	var player

	if shooter:
		if shooter.instance_name == "player1":
			player = GLOBAL.player1
		if shooter.instance_name == "player2":
			player = GLOBAL.player2
		if shooter.instance_name == "player3":
			player = GLOBAL.player3
		if shooter.instance_name == "player4":
			player = GLOBAL.player4
			
	if shooter:
		if Input.is_action_pressed(player.shoot):
			$trail.visible = true
		else:
			$trail.visible = false

func shoot(dir):
	
	if not connected:
		cd_timer.connect("timeout", shooter, "can_shoot")
		connected = true
	
	if shooter.can_shoot:
		
		if not GLOBAL.SFX.get_node("ion_cannon").is_playing():
			GLOBAL.SFX.play("ion_cannon")
		
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

					if target == null:
						damage_increase_reset()
						target = collider
						increase_damage_timer.start()

					if increase_damage and collider.can_take_damage:

						if collider != target:
							target = collider
							damage_increase_reset()
						
						damage_increase_reset.start()
						damage += WEAPON_SETTINGS.ion_cannon_damage_increase_value
						increase_damage = false
						increase_damage_timer.start()
					
					if do_damage:
						do_damage = false
						collider.take_damage(damage, shooter_ref)
						if collider.hp <= 0:
							damage_increase_reset()
						collider.hit_effect(damage, dir.x)
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