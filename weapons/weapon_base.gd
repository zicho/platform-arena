extends Node2D

onready var sprite = get_node("gfx")
onready var barrel = get_node("barrel")

export(PackedScene) var projectile

var shooter
export(int) var damage = 5

export var display_name = "Weapon Name"
var can_shoot = true
var cd_timer = Timer.new()
export var shot_delay = 0.2
export var spread = 0.0
var connected = false

export var ammo = -1
var max_ammo # NOT USED!! MAY USE IF YOU WANT TO CHANGE AMMO MECHANICS SOMEHOW BUT FOR NOW: NOT USED!!

func _ready():

	if ammo != 0: # every weapon except base rifle has ammo
		max_ammo = ammo
	
	cd_timer.set_wait_time(shot_delay)
	add_child(cd_timer)

func shoot(dir):

	if not connected:
		cd_timer.connect("timeout", shooter, "can_shoot")
		connected = true
	
	if shooter.can_shoot:

		if projectile:
			if ammo > 0:
				ammo -= 1
			var bullet = projectile.instance()
			GLOBAL.level.add_child(bullet)

			bullet.shooter = self.shooter
			bullet.damage = self.damage
			
			bullet._spawn(barrel.global_position, Vector2(dir.x, (dir.y + rand_range(-spread, spread))))
			
			
			GLOBAL.SFX.play(self.name)

		shooter.can_shoot = false
		cd_timer.start()