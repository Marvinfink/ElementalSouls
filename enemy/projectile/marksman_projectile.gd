extends "res://enemy/base/base_projectile.gd"

func _ready():
	speed = 100
	range = 200
	damage = 0.5
	stun_duration = 1
	knockback_force = 300
