extends "res://Characters/projectile/base_projectile.gd"

func _ready():
	speed = 200
	range = 500
	damage = 20
	stun_duration = 1
	knockback_force = 300
