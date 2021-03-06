extends KinematicBody2D

var GRAVITY = GAME_SETTINGS.gravity
var JUMP_FORCE = GAME_SETTINGS.jump_force
var JUMP_THRESHOLD = GAME_SETTINGS.jump_threshold

const FLOOR_NORMAL = Vector2(0, -1)
const ACCELERATION = 1

var velocity = Vector2()
var speed = GAME_SETTINGS.movement_speed
var movement = 0

var can_jump = false
var jump_timer = 0

var push_force = 0
var push_active_timer = Timer.new()
var push_active = false
var diagonal_push = false

var knock_dir = Vector2(0,0)

var controlled_by = 0
var player
var instance_name

onready var sprite = get_node("gfx")
onready var hands = sprite.get_node("hands")
onready var size = sprite.texture.get_size()

var dirs = { "right": Vector2(1,0), "left": Vector2(-1, 0) }
var active_dir 

#onready var weapon = preload("res://weapons/machine_gun.tscn").instance()
onready var weapon = preload("res://weapons/rocket_launcher.tscn").instance()
#onready var weapon = preload("res://weapons/assault_rifle.tscn").instance()
#onready var weapon = preload("res://weapons/pulse_blaster.tscn").instance()
onready var secondary_weapon# = preload("res://weapons/shotgun.tscn").instance()

var weapon_queue
var can_shoot = true

signal hp_changed(hp)
var hp
var fragged = false

var active = true # used in last man standing mode

signal armor_changed(value)
var armor
var armor_type = GLOBAL.armor_types.red

signal update_frags(player_instance, value)

var test_damage = 100

var respawn_timer = Timer.new()

var no_damage_timer = Timer.new() # used when respawning to prevent you from taking instant damage
var can_take_damage = true

var acid_damage_timer = Timer.new()
var acid_damage_delay = 0.2
var take_acid_damage = false
var in_acid = false

func take_acid_damage():
	take_acid_damage = true

func _ready():
	
	if GLOBAL.MODE_INSTAGIB:
		weapon = preload("res://weapons/railgun.tscn").instance()
		weapon.ammo = -1

	update_hp(100)
	update_armor(0)
	connect("update_frags", GLOBAL, "update_frags")
	fragged = false
	
	if controlled_by == GLOBAL.PLAYERS.player1:
		instance_name = "player1"
		player = GLOBAL.player1

	if controlled_by == GLOBAL.PLAYERS.player2:
		instance_name = "player2"
		player = GLOBAL.player2

	if controlled_by == GLOBAL.PLAYERS.player3:
		instance_name = "player3"
		player = GLOBAL.player3

	if controlled_by == GLOBAL.PLAYERS.player4:
		instance_name = "player4"
		player = GLOBAL.player4

	$health_bar.set_modulate(player.color)

	connect("hp_changed", GLOBAL, "update_gui_hp")
	connect("armor_changed", GLOBAL, "update_gui_armor")
	update_hp(hp)
	update_armor(armor)

	sprite.set_modulate(player.color)
	
	push_active_timer.connect("timeout", self, "push_ended")
	push_active_timer.set_one_shot(true)
	push_active_timer.set_wait_time(0.1)

	add_child(push_active_timer)

	respawn_timer.set_wait_time(GLOBAL.RESPAWN_TIME)
	respawn_timer.set_one_shot(true)
	respawn_timer.connect("timeout", GLOBAL, "respawn_player", [controlled_by])
	GLOBAL.add_child(respawn_timer)

	no_damage_timer.set_wait_time(GLOBAL.NO_DAMAGE_AFTER_SPAWN_TIME)
	no_damage_timer.set_one_shot(true)
	no_damage_timer.connect("timeout", self, "can_take_damage")
	add_child(no_damage_timer)
	
	acid_damage_timer.set_wait_time(acid_damage_delay)
	acid_damage_timer.connect("timeout", self, "take_acid_damage")
	add_child(acid_damage_timer)

func spawn():
	
	GLOBAL.level.add_child(self)
	add_child(weapon)
	turn_right()

	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	randomize()
	var spawn = spawn_points[randi() % spawn_points.size()]

	var p = load("res://particles/player_appears.tscn").instance()
	GLOBAL.level.add_child(p)
	p.global_position = spawn.get_node("spawn_pos").global_position + Vector2(12, 12)
	p.set_modulate(player.color)
	global_position = spawn.get_node("spawn_pos").global_position

	can_take_damage = false
	no_damage_timer.start()

	#if GLOBAL.MODE_INSTAGIB:
		#weapon = load("res://weapons/railgun.tscn").instance()

	$spawn_marker/anim.connect("animation_finished", self, "remove_spawn_marker")
	$spawn_marker.set_modulate(player.color)
	$spawn_marker/anim.play("bounce")

	if GLOBAL.MODE_LAST_MAN_STANDING:
		GLOBAL.PLAYERS_LEFT += 1

func remove_spawn_marker(anim_name):
	$spawn_marker.queue_free()

func hit_effect(damage, dir):

	if can_take_damage and hp > 0:
		var blood = damage / 5

		if blood < 1:
			blood = 1

		for b in range(blood):

			var blood_effect = load("res://effects/hit_effect.tscn").instance()

			if dir < 0:
				blood_effect.scale = Vector2(-1, 1)

			blood_effect.find_node("fx").emitting = true
			blood_effect.position.x = self.position.x + 12
			blood_effect.position.y = self.position.y + 12
			blood_effect.set_modulate(player.color)
			GLOBAL.level.add_child(blood_effect)

func take_flat_damage(damage, armor_damage, dealt_by, weapon = null):
	
	GLOBAL.SFX.play("hit")
	
	if can_take_damage:
		if armor > 0:
			if armor_type == GLOBAL.armor_types.yellow:
				update_armor(armor - (armor_damage * 0.75))
			if armor_type == GLOBAL.armor_types.red:
				update_armor(armor - armor_damage)
		if armor < 0:
			update_armor(0)
		update_hp(hp - damage)
	
	if hp <= 0:
		fragged(dealt_by)	

func take_damage(damage, dealt_by, weapon = null):

	if weapon == "acid":
		GLOBAL.SFX.play("acid")
	else:
		GLOBAL.SFX.play("hit")

	if GLOBAL.DAMAGE_DEBUG:
		print("damage taken: %s" % damage)

		print("hp is: %s" % hp)
		print("armor is: %s of type %s" % [armor, armor_type])

	if can_take_damage:
		if armor > 0:

			var calculated_damage = 0
			var current_armor = armor

			if armor_type == GLOBAL.armor_types.yellow:
				for d in damage:
					if current_armor > 0:
						calculated_damage += 1.0 / 3
						current_armor -= 1
					else:
						calculated_damage += 1

			if armor_type == GLOBAL.armor_types.red:
				for d in damage:
					if current_armor > 0:
						calculated_damage += 1.0 / 4
						current_armor -= 1
					else:
						calculated_damage += 1

			if calculated_damage > armor:
				update_armor(0)
			else:
				if armor_type == GLOBAL.armor_types.yellow:
					update_armor(armor - calculated_damage * 2)
				if armor_type == GLOBAL.armor_types.red:
					update_armor(armor - calculated_damage * 3)

			update_hp(hp - calculated_damage)

		else:
			update_hp(hp - damage)

		if hp <= 0:
			fragged(dealt_by)
			
func fragged(fragged_by):

	if fragged_by:
		for p in get_tree().get_nodes_in_group("players"):
			if p.instance_name == fragged_by:
				var frag_marker = load("res://effects/frag_marker.tscn").instance()
				p.add_child(frag_marker)
				frag_marker.set_modulate(GLOBAL[fragged_by].color)

		update_armor(0)

		if fragged_by != self.instance_name and not fragged:
			fragged = true
			if not GLOBAL.MODE_LAST_MAN_STANDING:
				GLOBAL[fragged_by].frags += 1
		if fragged_by == self.instance_name and not fragged:
			fragged = true
			if not GLOBAL.MODE_LAST_MAN_STANDING:
				GLOBAL[fragged_by].frags -= 1

		emit_signal("update_frags", fragged_by, GLOBAL[fragged_by].frags)

		if GLOBAL[fragged_by].frags == GLOBAL.FRAG_LIMIT or GLOBAL[fragged_by].frags > GLOBAL.FRAG_LIMIT:
			GLOBAL.player_wins(GLOBAL[fragged_by].name, GLOBAL[fragged_by].color)

func add_armor(value, armor_type):

	self.armor_type = armor_type
	update_armor(self.armor + value)

func update_armor(new_armor):
	
	self.armor = round(new_armor)
	$armor_bar.value = new_armor
	
	if self.armor > 100:
		self.armor = 100
	if self.armor < 0:
		self.armor = 0		
	
	emit_signal("armor_changed", self.armor, self.armor_type, self)
	
	if self.armor_type == GLOBAL.armor_types.red:
		$armor_bar.set_modulate("b30000")
	elif self.armor_type == GLOBAL.armor_types.yellow:
		$armor_bar.set_modulate("fffb00")
	if armor == 0:
		$armor_bar.set_modulate("ffffff")
		
	
	if GLOBAL.DAMAGE_DEBUG:
		print("new armor is: %s of type %s" % [armor, armor_type])

func update_hp(new_hp):

	$health_bar.set_value(new_hp)

	self.hp = round(new_hp)

	if self.hp > 100:
		self.hp = 100

	if GLOBAL.DAMAGE_DEBUG:
		print("new hp is: %s" % new_hp)

	if self.hp <= 0:

		hp = 0
		if not fragged:
			var splat = load("res://effects/frag_splat.tscn").instance()
			splat.set_modulate(player.color)
			GLOBAL.level.add_child(splat)
			splat.global_position = self.global_position

		queue_free()

		if not GLOBAL.MODE_LAST_MAN_STANDING:
			respawn_timer.start()

		elif GLOBAL.MODE_LAST_MAN_STANDING:
			active = false
			GLOBAL.PLAYERS_LEFT -= 1

			if GLOBAL.PLAYERS_LEFT == 1:
				var player_alive
				for p in get_tree().get_nodes_in_group("players"):
					if p.active:
						player_alive = p
				
				player_alive.player.frags += 1
				emit_signal("update_frags", player_alive.instance_name, player_alive.player.frags)
				
				player_alive.queue_free()
				if not player_alive.player.frags == GLOBAL.FRAG_LIMIT:
					GLOBAL.PLAYERS_LEFT = 0
					if not GLOBAL.MODE_INSTAGIB:
						for i in get_tree().get_nodes_in_group("item_slots"):
							i.respawn_timer.stop()
							i.spawn_item()
					GLOBAL.ROUND_RESET.start()

	emit_signal("hp_changed", hp, self)

func push_loop(delta):

	var friction
	var right_push = false
	var left_push = false

	if push_force > 0:
		right_push = true
	elif push_force < 0:
		left_push = true

	if not is_on_floor():
		friction = 5
	else:
		friction = 25

#	if diagonal_push:
#		friction = 5
#	else:
#		friction = 25	

	if not push_active:
		velocity += GRAVITY * (delta * 2)
	else:
		velocity += (GRAVITY / 4) * (delta * 2)

	if not push_active and right_push:
		push_force -= friction

	if not push_active and left_push:
		push_force += friction

	if is_on_floor():
		if right_push and push_force < 25:
			push_force = 0

	if is_on_wall() and push_active_timer.time_left < 0.005:
		push_force = 0
		push_ended()

func move_loop(delta):

	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	movement = 0

	if(Input.is_action_pressed(player.right)) and not push_active:
		movement += 1
	if(Input.is_action_pressed(player.left)) and not push_active:
		movement -= 1

	movement *= speed 

	velocity.x = lerp(velocity.x, movement, ACCELERATION) + push_force

	jump_timer += delta
	can_jump = jump_timer < JUMP_THRESHOLD

	if is_on_floor():
		jump_timer = 0

func jump_loop():

	if can_jump && Input.is_action_just_pressed(player.jump):
		jump_timer = JUMP_THRESHOLD
		velocity.y -= JUMP_FORCE
		GLOBAL.SFX.play("jump")

func weapon_loop():

	if weapon_queue and can_shoot:
		switch_weapon()
		
	if weapon:
		weapon.global_position = hands.global_position

		if Input.is_action_pressed(player.shoot):
			can_take_damage()
			weapon.shoot(active_dir)

#		if Input.is_action_pressed(player.right):
#			if not Input.is_action_pressed(player.shoot):
#				if not Input.is_action_pressed(player.turnlock):
#					turn_right()
#		if Input.is_action_pressed(player.left):
#			if not Input.is_action_pressed(player.shoot):
#				if not Input.is_action_pressed(player.turnlock):
#					turn_left()		
				
#		if(Input.is_action_pressed(player.left) and not Input.is_action_pressed(player.shoot)):
#			turn_left()

		if(Input.is_action_pressed(player.right) and not Input.is_action_pressed(player.turnlock)):
			turn_right()
		if(Input.is_action_pressed(player.left) and not Input.is_action_pressed(player.turnlock)):
			turn_left()	

	if Input.is_action_just_pressed(player.switch_weapon):

		if can_shoot:
			switch_weapon()
		else:
			weapon_queue = secondary_weapon
			
	if Input.is_action_just_pressed(player.pick_up_weapon):
		if can_shoot:
			pick_up_weapon()

	if weapon.ammo == 0:
		switch_weapon(true) # removes old empty weapon

func spawn_loop():
	
	if not can_take_damage:
		if not $anim.is_playing():
			$anim.play("no_damage")
	else:
		$anim.stop()

func acid_damage_loop():
	if take_acid_damage and in_acid:
		take_acid_damage = false
		acid_damage_timer.start()
		take_damage(5, instance_name, "acid")

func gui_loop():
	if armor <= 0:
		$armor_bar.visible = false
		$progress_icon_armor.visible = false
	else:
		$armor_bar.visible = true
		$progress_icon_armor.visible = true
		
	$ammo_label.text = str(weapon.ammo)
	if weapon.ammo <= 0:
		$ammo_label.visible = false
	else:
		$ammo_label.visible = true

func _process(delta):
	if GLOBAL.GAME_ACTIVE:
		push_loop(delta)
		move_loop(delta)
		jump_loop()
		weapon_loop()
		spawn_loop()
		acid_damage_loop()
		gui_loop()

#	if Input.is_action_just_pressed("ui_accept"):
#		if instance_name == "player1":
#			take_damage(100, self.instance_name)

func pick_up_weapon():

	var weapon = null
	
	for a in get_tree().get_nodes_in_group("weapon_pickups"):

		if a.player_is_on_pickup(self):
			weapon = a.weapon_ref.instance()
			a.picked_up()
			weapon_queue = null
			GLOBAL.SFX.play("weapon_pickup")

			if can_shoot:
				if secondary_weapon == null:
					secondary_weapon = self.weapon
			
			remove_child(self.weapon)
			self.weapon = weapon
			add_child(weapon)
			turn_weapon_sprite()

func has_weapon(weapon_ref):
	
	if weapon.get_filename() == weapon_ref.get_path():
		return true
	if secondary_weapon != null:
		if secondary_weapon.get_filename() == weapon_ref.get_path():	
			return true
	return false	

func switch_weapon(remove_old = false): # remove old uses to remove weapons which are out of ammo

	if secondary_weapon != null:

		weapon_queue = null

		if weapon.ammo <= 0:
			remove_old = true

		if can_shoot:
			var wpn = weapon
			var s_wpn = secondary_weapon
			remove_child(weapon)
			weapon = s_wpn
			if not remove_old:
				secondary_weapon = wpn
			else:
				
#				if one gun goes empty, replace it with the standard rifle,
#				if the rifle is not already in inventory
				
				var m_gun = load("res://weapons/machine_gun.tscn")
				if not has_weapon(m_gun):
					secondary_weapon = m_gun.instance()
				else:
					secondary_weapon = null
					
			add_child(weapon)

		else:
			weapon_queue = weapon
	
	turn_weapon_sprite()
	
func turn_weapon_sprite():
	if weapon.sprite:
		if active_dir.x == 1:
			turn_right()
		else:
			turn_left()

func can_shoot():
	can_shoot = true

func turn_right():
	active_dir = dirs["right"]
	sprite.flip_h = false
	hands.global_position = global_position + Vector2(self.size.x - self.size.x / 4, self.size.y - self.size.y / 4)
	if weapon:
		weapon.scale.x = 1
		#weapon.sprite.flip_h = false

func turn_left():
	active_dir = dirs["left"]
	sprite.flip_h = true
	hands.global_position = global_position + Vector2(self.size.x / 4, self.size.y - self.size.y / 4)
	if weapon:
		weapon.scale.x = -1
		#weapon.sprite.flip_h = true

func push(force, duration):

	push_active = true
	velocity.y -= abs(force) / 4
	push_force = force
	push_active_timer.set_wait_time(duration)
	push_active_timer.start()

func push_ended():
	push_active = false

func can_take_damage():
	can_take_damage = true