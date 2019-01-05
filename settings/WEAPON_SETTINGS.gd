extends Node

# MACHINE GUN
const machine_gun_damage = 5
const machine_gun_delay = 0.15

# ION CANNON
const ion_cannon_damage = 8
const ion_cannon_delay = 0.01
const ion_cannon_ammo = 200

# PULSE BLASTER
const pulse_blaster_damage = 16
const pulse_blaster_knockback = 0.20
const pulse_blaster_delay = 0.16
const pulse_blaster_ammo = 80

# SHOTGUN
const shotgun_damage = 5
const shotgun_pellets = 16
const shotgun_delay = 0.8
const shotgun_ammo = 24

# ROCKET LAUNCHER
const rocket_launcher_damage = 100
const rocket_launcher_delay = 1
const rocket_launcher_ammo = 16

# RAILGUN
const railgun_damage = 80
const railgun_delay = 1.6
const railgun_ammo = 20

func load_instagib_settings():
	if GLOBAL.MODE_INSTAGIB: 
		railgun_damage = 100
		railgun_delay = 0.8
		
func unload_instagib_settings():
	if not GLOBAL.MODE_INSTAGIB: 
		railgun_damage = 80
		railgun_delay = 1.6