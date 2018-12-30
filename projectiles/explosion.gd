extends Node2D

onready var splash_radius = $splash_radius
onready var splash_shape = $splash_radius/shape
onready var sprite = $gfx

onready var shooter
onready var damage = 100
var first_loop_done = false

var players_hit = [] # add each player to this list so its possible to damage several players but not hurt one player twice

func _ready():

	splash_shape.shape.radius = 10
	splash_radius.monitoring = true

func _physics_process(delta):

	if damage > 0:
		splash_shape.shape.radius += 4
		sprite.scale += Vector2(0.5, 0.5)
	else:
    	queue_free()
		
	splash_radius.get_overlapping_bodies()

	if splash_radius.get_overlapping_bodies().size() > 0:
		for b in splash_radius.get_overlapping_bodies():

			if b.is_in_group("players") and players_hit.find(b.name) == -1:

				var r1 = RayCast2D.new()
				var r2 = RayCast2D.new()
				var r3 = RayCast2D.new()
				var r4 = RayCast2D.new()

				var rays = []

				rays.append(r1)
				rays.append(r1)
				rays.append(r2)
				rays.append(r3)

				add_child(r1)
				r1.set_collision_mask_bit(0, 1)
				r1.enabled = true
				
				add_child(r2)
				r2.set_collision_mask_bit(0, 1)
				r2.enabled = true
				
				add_child(r3)
				r3.set_collision_mask_bit(0, 1)
				r3.enabled = true
				
				add_child(r4)
				r4.set_collision_mask_bit(0, 1)
				r4.enabled = true

				var offset = 8 # the offset is the amount of pixels the splash is emanating from

				r1.position = r1.position + Vector2(-offset, -offset)
				r1.cast_to = to_local(b.global_position + Vector2(12,12))
				r1.force_raycast_update()

				r2.position = r2.position + Vector2(offset, -offset)
				r2.cast_to = to_local(b.global_position + Vector2(12,12))
				r2.force_raycast_update()

				r3.position = r3.position + Vector2(offset, offset)
				r3.cast_to = to_local(b.global_position + Vector2(12,12))
				r3.force_raycast_update()

				r4.position = r4.position + Vector2(-offset, offset)
				r4.cast_to = to_local(b.global_position + Vector2(12,12))
				r4.force_raycast_update()

				#r.cast_to = to_local(b.global_position + Vector2(12,12))
				#r.force_raycast_update()
				for r in rays:
					var hit
					hit = r.get_collision_point()
					if r.is_colliding():
						var collider = r.get_collider()
						var ray_hit = r.get_collision_point()

						if collider.is_in_group("players"):
							if not players_hit.has(collider):
								players_hit.append(collider)
								b.hit_effect(damage, b.global_position.x - global_position.x)
								b.take_damage(damage, shooter)
								

	if not first_loop_done:
		GLOBAL.SFX.play("explosion")
		first_loop_done = true
	else:
		damage -= 5