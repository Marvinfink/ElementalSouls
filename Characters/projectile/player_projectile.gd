extends "res://Characters/projectile/base_player_projectile.gd"

func _ready():
	speed = 100
	range = 200
	damage = 100
	stun_duration = 1
	knockback_force = 300
