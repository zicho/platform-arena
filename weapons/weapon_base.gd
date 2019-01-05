extends Node2D

onready var sprite = get_node("gfx")
onready var barrel = get_node("barrel")

export(PackedScene) var projectile

var shooter
var damage = 5

export var display_name = "Weapon Name"
var can_shoot = true
var cd_timer = Timer.new()
var shot_delay
export var spread = 0.0
var connected = false

var ammo = -1

func _ready():

	add_child(cd_timer)

func set_ammo(ammo):
	self.ammo = ammo

func set_cooldown_time(time):
	cd_timer.set_wait_time(time)

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
			bullet.damage = shooter.weapon.damage

			GLOBAL.SFX.play(self.name)

		shooter.can_shoot = false
		cd_timer.start()